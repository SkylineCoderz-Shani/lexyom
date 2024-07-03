import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';
import '../screen_full_videoPlayer.dart';
import 'item_message_audio.dart';

class VideoMessageBubble extends StatefulWidget {
  final Message message;
  String chatId;
  bool showImage;
  bool? personalChat;
  String notificationToken;
  List<String> notificationsList;

  @override
  _VideoMessageBubbleState createState() => _VideoMessageBubbleState();

  VideoMessageBubble({
    required this.message,
    required this.chatId,
    required this.showImage,
    this.personalChat = false,
    required this.notificationToken,
    required this.notificationsList,
  });
}

class _VideoMessageBubbleState extends State<VideoMessageBubble> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.message.videoMessage!.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(
          () {}); // Ensure the first frame is shown after the video is initialized
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
            videoUrl: widget.message.videoMessage!.videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.message.senderId == FirebaseUtils.myId;
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
                        width: 35.w,
                        height: 35.h,
                      ),
            Expanded(
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.showImage && widget.personalChat == false)
                    Text(
                      widget.message.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ).marginOnly(top: 4.0),
                  GestureDetector(
                    onTap: () => _navigateToFullScreen(context),
                    child: Container(
                      height: Get.height * .45,
                      width: Get.width * .7,
                      margin: EdgeInsets.only(top: 4.0),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Color(0xFF000000)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isCurrentUser ? 15.0 : 2.0),
                          topRight: Radius.circular(isCurrentUser ? 2.0 : 15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 64.0,
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
                    ),
                  ),
                  if (isCurrentUser)
                    Text(
                      widget.message.status,
                      style: TextStyle(
                        color: Colors.black,
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
