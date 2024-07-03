import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/follow_controller.dart';

class FollowUpdateUserContainer extends StatelessWidget {
  int id;

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    return InkWell(
      onTap: () {
        if (followController.followCheckStatusMessage.value == "Connect") {
          followController.requestFollow(id);
        } else if (followController.followCheckStatusMessage.value ==
            "Accept") {
          followController.acceptFollow(id);
        } else {
          followController.requestFollow(id);
        }
      },
      child: Container(
        height: 60.h,
        width: Get.width * 0.4,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Obx(() {
          return Center(
            child: followController.isLoading.value
                ? CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Text(
                    followController.followCheckStatusMessage.value,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
          );
        }),
      ),
    );
  }

  FollowUpdateUserContainer({
    required this.id,
  });
}
