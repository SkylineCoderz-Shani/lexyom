import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/follow_controller.dart';
import '../CustomWidget/custom_listview_builder.dart';
import 'layouts/item_connect_back_follow.dart';
import 'layouts/item_user_follow_request.dart';

class ScreenUserFollow extends StatelessWidget {
  final FollowController followController = Get.put(FollowController());

  @override
  Widget build(BuildContext context) {
    followController.fetchFollowRequests();
    log(followController.acceptedFollowsList.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Follow Requests",
          style: title1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (followController.isFollowRequestLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (followController.followRequests.isEmpty) {
                return Center(child: Text("No Request"),);
              }

              return CustomListviewBuilder(
                itemCount: followController.followRequests.length,
                itemBuilder: (BuildContext context, int index) {
                  var request = followController.followRequests[index];
                  log(request.id.toString());
                  return ItemUserFollowRequest(followRequest: request);
                },
                scrollDirection: CustomDirection.vertical,
              );
            }),
            Obx(() {
              return CustomListviewBuilder(
                itemCount: followController.acceptedFollowsList.length,
                itemBuilder: (BuildContext context, int index) {
                  var user = followController.acceptedFollowsList[index];
                  return ItemConnectBackFollow(user: user);
                },
                scrollDirection: CustomDirection.vertical,
              );
            }),
          ],
        ),
      ),
    );
  }
}
