import 'dart:math' as m;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';
import '../screen_full_image_preview.dart';
import 'item_message_audio.dart';

class ImageMessageBubble extends StatelessWidget {
  final Message message;
  bool showImage;
  bool? personalChat;
  String notificationToken;
  List<String> notificationsList;

  String chatId;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = message.senderId == FirebaseUtils.myId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: GestureDetector(
        onLongPress: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset messageOffset = renderBox.localToGlobal(Offset.zero);
          Size messageSize = renderBox.size;
          showReactionPicker(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            personalChat == true
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
                    ).marginOnly(top: 4.0),
                  Stack(
                    children: [
                      Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(isCurrentUser ? 15.0 : 2.0),
                                topRight:
                                    Radius.circular(isCurrentUser ? 2.0 : 15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(ScreenFullImagePreview(
                                    imageUrl: message.imageMessage!.imageUrl,
                                  ));
                                },
                                child: Image.network(
                                  message.imageMessage!.imageUrl,
                                  width: Get.width * .7,
                                  height: Get.height * .4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (message.reactions.isNotEmpty)
                        Positioned(
                          bottom: 0.0,
                          right: 30, // Adjust to your requirement
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
                                              '${entry.key} ${entry.value > 1 ? entry.value : ''}'),
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
            personalChat == true
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
      ),
    );
  }

  void showReactionPicker(BuildContext context) {
    final List<String> reactions = ['👍', '❤️', '😢', '😊', '👌', '+'];

    // Get the render box of the message widget
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
                            // Open the emoji picker here
                            // Implement your emoji picker logic
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

  void removeReactionToMessage(
      String groupId, Message message, String reaction) {
    final String userId = FirebaseUtils.myId;
    if (message.reactions[userId] == reaction) {
      message.reactions.remove(userId); // Remove the reaction if it's the same
    } else {
      message.reactions[userId] = reaction; // Add or replace the reaction
    }

    final DatabaseReference messageRef = FirebaseDatabase.instance
        .reference()
        .child("GroupChat")
        .child(groupId)
        .child('messages')
        .child(message.id);

    // Update the reactions in the database
    messageRef.update({
      'reactions': message.reactions,
    });
  }

  Future<String> linkSize(String url) async {
    String? fileSize = "";
    try {
      http.Response response = await http.head(Uri.parse(url));
      fileSize = response.headers["content-length"];
      int bytes = int.parse(fileSize!);
      if (bytes <= 0) {
        fileSize = "0 B";
      }
      const suffixes = ["B", "KB", "MG", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (m.log(bytes) / m.log(1024)).floor();
      fileSize =
          '${(bytes / m.pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
    } catch (err) {
      fileSize = "0 B";
    }
    return fileSize!;
  }

  ImageMessageBubble({
    required this.message,
    required this.showImage,
    this.personalChat = false,
    required this.notificationToken,
    required this.notificationsList,
    required this.chatId,
  });
}
