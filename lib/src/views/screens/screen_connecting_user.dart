import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/follow_controller.dart';
import '../layouts/item_connecting_user.dart';

class ScreenConnectingUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    followController.fetchConnectingList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Connecting Users"),
      ),
      body: Obx(() {
        return (followController.connectingList.isEmpty)
            ? Center(child: Text("No User Found"))
            : ListView.builder(
                itemCount: followController.connectingList.length,
                itemBuilder: (BuildContext context, int index) {
                  var user = followController.connectingList[index];
                  return ItemConnectingUser(user: user);
                },
              );
      }),
    );
  }
}
