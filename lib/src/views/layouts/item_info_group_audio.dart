import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';

class ItemInfoGroupAudio extends StatefulWidget {
  final Message message;
  final Function(bool isPlaying)? isPlaying;
  final bool? disabled;
  @override
  State<ItemInfoGroupAudio> createState() => _ItemInfoGroupAudioState();

  const ItemInfoGroupAudio({
    required this.message,
    this.isPlaying,
    this.disabled,
  });
}

class _ItemInfoGroupAudioState extends State<ItemInfoGroupAudio> {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool loading = false;
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(
          horizontal: 4.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurStyle: BlurStyle.outer,
            spreadRadius: 1.0,
            blurRadius: 3.0,
            offset: Offset(1, 2),
          )
        ],
      ),
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
                      widget.message.audioMessage!=null?widget.message.audioMessage!.audioUrl:widget.message.voiceMessage!.voiceUrl);
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
                     buttonColor,
                ),
              )
                  : (!loading && isPlaying)
                  ? Icon(
                Icons.pause,
                color:  Colors.blue,
              )
                  : Icon(
                Icons.play_arrow,
                color: buttonColor,
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
                          enabledThumbRadius:
                          6),
                    ),
                    child: Slider(
                      activeColor: buttonColor,
                      inactiveColor: buttonColor,
                      min: 0,
                      max: duration.inMilliseconds
                          .toDouble(),
                      value: position
                          .inMilliseconds
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
                Text(
                  duration.toString().split(".")[0],
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 10.sp),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
