import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/follow_controller.dart';

class ItemConnectBackFollow extends StatelessWidget {
  Map<String, dynamic> user;
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    return Container(
      height: 80,
      // padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      // margin: EdgeInsets.symmetric(vertical: 12.h),
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
        title: Text(user["accepted user"]),
        trailing: GestureDetector(
          onTap: () async {
            int id = user['accepted id'];
            log(id.toString());
            loading.value = true;
            await followController.requestFollow(id).then((value) {
              followController.fetchFollowRequests();
              followController.acceptedFollowsList
                  .removeWhere((element) => element['accepted id'] == id);
            });
            loading.value = false;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 7.h),
            width: 130.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
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
                      "Connect Back",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
            }),
          ),
        ),
      ),
    );
  }

  ItemConnectBackFollow({
    required this.user,
  });
}
