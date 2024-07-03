import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../controllers/follow_controller.dart';
import '../../../models/connecting.dart';
import '../screen_userProfileInfo.dart';

class ItemConnectingUser extends StatelessWidget {
  Connecting user;
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
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
        trailing: GestureDetector(
          onTap: () async {
            int id = user.id;

            loading.value = true;
            await followController.unfollow(id).then((value) {});
            loading.value = false;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 7.h),
            width: 80.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20.r),
              ),
            ),
            child: Obx(() {
              return (loading.value)
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    ))
                  : Center(
                      child: Text(
                      "Unfollow",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
            }),
          ),
        ),
      ),
    );
  }

  ItemConnectingUser({
    required this.user,
  });
}
