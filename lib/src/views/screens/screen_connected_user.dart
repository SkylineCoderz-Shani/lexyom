import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/follow_controller.dart';
import '../layouts/item_connected_user.dart';

class ScreenConnectedUser extends StatelessWidget {
  const ScreenConnectedUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    followController.fetchConnectersList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Users"),
      ),
      body: Obx(() {
        return (followController.connectersList.isEmpty)
            ? Center(child: Text("No User Found"))
            : ListView.builder(
                itemCount: followController.connectersList.length,
                itemBuilder: (BuildContext context, int index) {
                  var user = followController.connectersList[index];
                  return ItemConnectedUser(user: user);
                  return ListTile();
                },
              );
      }),
    );
  }
}
