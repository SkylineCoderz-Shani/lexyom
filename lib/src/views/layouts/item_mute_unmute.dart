// lib/widgets/mute_unmute_container.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/controller_mute_unmute_group.dart';

class MuteUnmuteContainer extends StatelessWidget {
  final GroupMuteController groupMuteController = Get.put(
      GroupMuteController());
  final String groupId;

  MuteUnmuteContainer({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => groupMuteController.toggleGroupMuteStatus(groupId),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xff3A3A3A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: (groupMuteController.isLoading.value)?CircularProgressIndicator():Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                groupMuteController.isGroupMuted.value
                    ? CupertinoIcons.speaker
                    : CupertinoIcons.speaker_slash,
                color: Color(0xffE3FF00),
                size: 30.sp,
              ),
              Text(
                groupMuteController.isGroupMuted.value ? "Unmute" : "Mute",
                style: TextStyle(
                  color: Color(0xffE3FF00),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ).marginOnly(
                right: 6.sp,
              ),
            ],
          )
        ),
      );
    });
  }
}
