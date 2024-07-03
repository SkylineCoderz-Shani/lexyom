import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';
import 'item_message_audio.dart';

class ItemMedia extends StatelessWidget {
  Message message;
  String chatId;
  bool showImage;
  bool? personalChat;
  String notificationToken;
  List<String> notificationsList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset messageOffset = renderBox.localToGlobal(Offset.zero);
          Size messageSize = renderBox.size;
          showReactionPicker(context);
        },
        onTap: () {
          downloadMedia(context, message.fileMessage!.fileUrl,
              message.fileMessage!.fileName);
        },
        child: Align(
          alignment: message.senderId == FirebaseUtils.myId
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
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
                                width: 32.w,
                                height: 32.h,
                              ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            message.senderId == FirebaseUtils.myId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          if (personalChat == false && showImage)
                            Text(
                              message.senderName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                  fontFamily: "Inter"),
                            ).marginOnly(top: 4.0),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                decoration: BoxDecoration(
                                  color: message.senderId == FirebaseUtils.myId
                                      ? Colors.black
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        message.senderId == FirebaseUtils.myId
                                            ? 15.0
                                            : 2.0),
                                    topRight: Radius.circular(
                                        message.senderId == FirebaseUtils.myId
                                            ? 2.0
                                            : 15.0),
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 2),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 6.h),
                                      width: Get.width * 0.61,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.file_copy_rounded,
                                            color: Colors.white,
                                            size: 30.h,
                                          ).marginOnly(right: 10.w),
                                          Expanded(
                                            child: Text(
                                              message.fileMessage!.fileName,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
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
                                            .fold<Map<String, int>>({},
                                                (acc, entry) {
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                          if (message.senderId == FirebaseUtils.myId)
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
            ],
          ),
        ));
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

  void downloadMedia(context, String url, String name) async {
    // Use the download link to download the file
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.refFromURL(url);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File localFile =
        File('${appDocDir.path}/$name'); // Change the file name as needed

    try {
      await ref.writeToFile(localFile);
      print('File downloaded and saved to: ${localFile.path}');
      await OpenAppFile.open(
        localFile.path,
      ).catchError((error) {
        log(error.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No App to open this file")));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  ItemMedia({
    required this.message,
    required this.chatId,
    required this.showImage,
    this.personalChat = false,
    required this.notificationToken,
    required this.notificationsList,
  });
}
