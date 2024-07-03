import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../controllers/follow_controller.dart';
import '../../../models/connecters.dart';
import '../screen_userProfileInfo.dart';

class ItemConnectedUser extends StatelessWidget {
  Connecter user;
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: Offset(0, 3),
              blurStyle: BlurStyle.outer,
            )
          ]),
      child: ListTile(
        onTap: () {
          Get.to(ScreenUserProfileInfo(id: user.id));
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(AppEndPoint.userProfile + user.profile),
        ),
        title: Text("${user.firstName} ${user.lastName}"),
      ),
    );
  }

  ItemConnectedUser({
    required this.user,
  });
}
