import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/firebase_utils.dart';
import '../../models/message.dart';
import '../views/layouts/item_message_audio.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  String chatId;
  bool showImage;
  bool? personalChat;
  String notificationToken;
  List<String> notificationsList;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = message.senderId == FirebaseUtils.myId;
    String url = extractUrl(message.content);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (personalChat == true)
              ? SizedBox()
              : (message.senderId != FirebaseUtils.myId && showImage)
                  ? Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "${message.senderProfileImage}"))),
                    )
                  : SizedBox(
                      width: 35.w,
                      height: 35.h,
                    ),
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (personalChat == false && showImage)
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ).marginOnly(
                    top: 4.0,
                  ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        launch(url);
                      },
                      onLongPress: () {
                        showReactionPicker(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 4.0),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Color(0xFF000000)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(isCurrentUser ? 15.0 : 2.0),
                            topRight:
                                Radius.circular(isCurrentUser ? 2.0 : 15.0),
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: message.content.replaceAll(url, ''),
                                      style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    TextSpan(
                                      text: url,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ).marginOnly(right: 20.w),

                              // Show "Seen" text for sent messages
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (message.reactions.isNotEmpty)
                      Positioned(
                        bottom: 0.0,
                        right: 15.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Wrap(
                              children: message.reactions.entries
                                  .fold<Map<String, int>>({}, (acc, entry) {
                                    acc[entry.value] =
                                        (acc[entry.value] ?? 0) + 1;
                                    return acc;
                                  })
                                  .entries
                                  .map((entry) {
                                    return GestureDetector(
                                      onTap: () {
                                        addReactionToMessage(
                                            chatId.toString(),
                                            message,
                                            entry.key,
                                            personalChat!,
                                            notificationsList,
                                            notificationToken);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Text(
                                          '${entry.key} ${entry.value > 1 ? entry.value : ''}',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (isCurrentUser)
                  Text(
                    message.status,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
              ],
            ),
          ),
          (personalChat == true)
              ? SizedBox()
              : (message.senderId == FirebaseUtils.myId && showImage)
                  ? Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "${message.senderProfileImage}"))),
                    )
                  : SizedBox(
                      width: 35.w,
                      height: 35.h,
                    ),
        ],
      ),
    );
  }

  void showReactionPicker(BuildContext context) {
    final List<String> reactions = ['👍', '❤️', '😢', '😊', '👌', '+'];
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset messageOffset = renderBox.localToGlobal(Offset.zero);
    Size messageSize = renderBox.size;
    double pickerTopPosition = messageOffset.dy - 60;
    double pickerLeftPosition = messageOffset.dx + messageSize.width / 2 - 75;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: pickerLeftPosition,
              top: pickerTopPosition,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () async {
                          if (reaction == '+') {
                            final emoji = await showModalBottomSheet<Emoji>(
                              context: context,
                              builder: (BuildContext context) {
                                return EmojiPicker(
                                  onEmojiSelected: (category, emoji) {
                                    Navigator.pop(context, emoji);
                                  },
                                );
                              },
                            );

                            if (emoji != null) {
                              addReactionToMessage(
                                  chatId.toString(),
                                  message,
                                  emoji.emoji,
                                  personalChat!,
                                  notificationsList,
                                  notificationToken);
                            }
                          } else {
                            addReactionToMessage(
                                chatId.toString(),
                                message,
                                reaction,
                                personalChat!,
                                notificationsList,
                                notificationToken);
                          }
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(reaction, style: TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String extractUrl(String content) {
    final urlPattern = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+', // Simple URL regex
      caseSensitive: false,
    );
    final match = urlPattern.firstMatch(content);
    return match?.group(0) ?? '';
  }

  Future<void> _launchUrl(String content) async {
    final urlPattern = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+', // Simple URL regex
      caseSensitive: false,
    );
    final match = urlPattern.firstMatch(content);
    String url = match?.group(0) ?? '';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ChatBubble({
    required this.message,
    required this.chatId,
    required this.showImage,
    this.personalChat = false,
    required this.notificationToken,
    required this.notificationsList,
  });
}
