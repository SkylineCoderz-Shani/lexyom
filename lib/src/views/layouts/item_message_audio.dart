import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/chat_constant.dart';
import '../../../constants/colors.dart';
import '../../../constants/fcm.dart';
import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';

class ItemMessageAudio extends StatefulWidget {
  final Message message;
  String chatId;
  final Function(bool isPlaying)? isPlaying;
  final bool? disabled;
  bool showImage;
  bool? personalChat;
  String notificationToken;
  List<String> notificationsList;

  @override
  _ItemMessageAudioState createState() => _ItemMessageAudioState();

  ItemMessageAudio({
    required this.message,
    required this.chatId,
    this.isPlaying,
    this.disabled,
    required this.showImage,
    this.personalChat = false,
    required this.notificationToken,
    required this.notificationsList,
  });
}

class _ItemMessageAudioState extends State<ItemMessageAudio> {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool loading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
        if (widget.isPlaying != null) {
          widget.isPlaying!(isPlaying);
        }
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition ?? Duration.zero;
      });
    });
    _startUpdatingSlider();
  }

  @override
  void dispose() {
    _stopUpdatingSlider();
    audioPlayer.dispose();
    super.dispose();
  }

  void _startUpdatingSlider() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (_) async {
      position = (await audioPlayer.getCurrentPosition()) ?? Duration.zero;
      setState(() {});
    });
  }

  void _stopUpdatingSlider() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      key: widget.key,
      alignment: widget.message.senderId == FirebaseUtils.myId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset messageOffset = renderBox.localToGlobal(Offset.zero);
          Size messageSize = renderBox.size;
          showReactionPicker(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.personalChat == true
                      ? SizedBox()
                      : (widget.message.senderId != FirebaseUtils.myId &&
                              widget.showImage)
                          ? Container(
                              width: 35.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${widget.message.senderProfileImage}"))),
                            )
                          : SizedBox(
                              width: 32.w,
                              height: 32.h,
                            ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          widget.message.senderId == FirebaseUtils.myId
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        if (widget.personalChat == false && widget.showImage)
                          Text(
                            widget.message.senderName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ).marginOnly(top: 4.0),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: widget.message.senderId ==
                                        FirebaseUtils.myId
                                    ? Colors.black
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      widget.message.senderId ==
                                              FirebaseUtils.myId
                                          ? 15.0
                                          : 2.0),
                                  topRight: Radius.circular(
                                      widget.message.senderId ==
                                              FirebaseUtils.myId
                                          ? 2.0
                                          : 15.0),
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 2),
                                width: Get.width * 0.61,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (widget.disabled != null &&
                                              widget.disabled! &&
                                              !isPlaying) {
                                            Get.snackbar("Alert",
                                                "Please pause another playing audio first",
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                            return;
                                          }

                                          if (!isPlaying) {
                                            setState(() {
                                              loading = true;
                                            });
                                            await audioPlayer.setSourceUrl(
                                                widget.message.voiceMessage!
                                                    .voiceUrl);
                                            await audioPlayer.audioCache;
                                            await audioPlayer.resume();
                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            await audioPlayer.pause();
                                          }
                                        },
                                        icon: loading
                                            ? SizedBox(
                                                height: 10.sp,
                                                width: 10.sp,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color:
                                                      widget.message.senderId ==
                                                              FirebaseUtils.myId
                                                          ? Colors.white
                                                          : buttonColor,
                                                ),
                                              )
                                            : (!loading && isPlaying)
                                                ? Icon(
                                                    Icons.pause,
                                                    color: widget.message
                                                                .senderId ==
                                                            FirebaseUtils.myId
                                                        ? Colors.white
                                                        : Colors.blue,
                                                  )
                                                : Icon(
                                                    Icons.play_arrow,
                                                    color: widget.message
                                                                .senderId ==
                                                            FirebaseUtils.myId
                                                        ? Colors.white
                                                        : buttonColor,
                                                  )),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10.sp,
                                            child: SliderTheme(
                                              data: SliderThemeData(
                                                trackHeight: 3,
                                                thumbColor: Colors.green,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius: 6),
                                              ),
                                              child: Slider(
                                                activeColor:
                                                    widget.message.senderId ==
                                                            FirebaseUtils.myId
                                                        ? Colors.white
                                                        : buttonColor,
                                                inactiveColor:
                                                    widget.message.senderId ==
                                                            FirebaseUtils.myId
                                                        ? Colors.white
                                                        : buttonColor,
                                                min: 0,
                                                max: duration.inMilliseconds
                                                    .toDouble(),
                                                value: position.inMilliseconds
                                                    .toDouble(),
                                                onChanged: (value) {
                                                  final position = Duration(
                                                      milliseconds:
                                                          value.toInt());
                                                  audioPlayer.seek(
                                                      position); // Assuming this is an asynchronous operation
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.message.reactions.isNotEmpty)
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
                                      children: widget.message.reactions.entries
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
                                                    widget.chatId.toString(),
                                                    widget.message,
                                                    entry.key,
                                                    widget.personalChat!,
                                                    widget.notificationsList,
                                                    widget.notificationToken);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                        if (widget.message.senderId == FirebaseUtils.myId)
                          Text(
                            widget.message.status,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                  widget.personalChat == true
                      ? SizedBox()
                      : (widget.message.senderId == FirebaseUtils.myId &&
                              widget.showImage)
                          ? Container(
                              width: 35.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${widget.message.senderProfileImage}"))),
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
      ),
    );
  }

  String formatDuration(Duration duration, String formatPattern) {
    final formatter = DateFormat(formatPattern);
    return formatter.format(DateTime(0, 0, 0, duration.inHours,
        duration.inMinutes % 60, duration.inSeconds % 60));
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
                                  widget.chatId.toString(),
                                  widget.message,
                                  emoji.emoji,
                                  widget.personalChat!,
                                  widget.notificationsList,
                                  widget.notificationToken);
                            }

                            // Open the emoji picker here
                            // Implement your emoji picker logic
                          } else {
                            addReactionToMessage(
                                widget.chatId.toString(),
                                widget.message,
                                reaction,
                                widget.personalChat!,
                                widget.notificationsList,
                                widget.notificationToken);
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
}

Future<void> addReactionToMessage(
    String groupId,
    Message message,
    String reaction,
    bool personalChat,
    List<String> tokens,
    String token) async {
  final String userId = FirebaseUtils.myId;
  if (message.reactions[userId] == reaction) {
    message.reactions.remove(userId); // Remove the reaction if it's the same
  } else {
    message.reactions[userId] = reaction; // Add or replace the reaction
  }
  if (personalChat == true) {
    final DatabaseReference messageRef =
        chatref.child(groupId).child(message.id);

    // Update the reactions in the database
    messageRef.update({
      'reactions': message.reactions,
    });
    await FCM.sendMessageSingle("New Message",
        "${FirebaseUtils.myName} is reacted with {}$reaction", token, {});
  } else {
    final DatabaseReference messageRef =
        chatGroupRef.child(groupId).child('messages').child(message.id);

    // Update the reactions in the database
    messageRef.update({
      'reactions': message.reactions,
    });
    await FCM.sendMessageMulti("Group Message",
        "${FirebaseUtils.myName} is reacted with $reaction", tokens);
  }
}

// void removeReactionToMessage(String groupId, Message message, String reaction) {
//   final String userId = FirebaseUtils.myId;
//   if (message.reactions[userId] == reaction) {
//     message.reactions.remove(userId); // Remove the reaction if it's the same
//   } else {
//     message.reactions[userId] = reaction; // Add or replace the reaction
//   }
//
//   final DatabaseReference messageRef = FirebaseDatabase.instance
//       .reference()
//       .child("GroupChat")
//       .child(groupId)
//       .child('messages')
//       .child(message.id);
//
//   // Update the reactions in the database
//   messageRef.update({
//     'reactions': message.reactions,
//   });
// }

class FirebaseStorageUtils {
  static Future<String?> uploadImage(
      File file, String path, String name) async {
    try {
      // Create a reference to the location you want to upload to
      var ref = FirebaseStorage.instance.ref().child("$path/$name");

      // Optionally, you can set metadata for the file
      final metadata = SettableMetadata(
        contentType: 'image/jpeg/png/gif/webp/tiff/bmp/pdf/svg',
        customMetadata: {'uploaded-by': 'Skorpio'},
      );

      // Upload the file to Firebase Storage
      await ref.putFile(file, metadata);

      // Get and return the download URL
      var url = await ref.getDownloadURL();
      return url;
    } catch (error) {
      // Log any errors encountered during the upload process
      print("Error uploading image: $error");
      return null;
    }
  }
}
