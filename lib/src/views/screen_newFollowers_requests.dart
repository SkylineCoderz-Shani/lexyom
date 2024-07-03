import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/controller_get_group_request.dart';
import '../../controllers/controller_user.dart';
import '../../models/group_info.dart';
import '../CustomWidget/custom_followContainer.dart';
import 'layouts/item_group_request.dart';

class ScreenNewFollowers extends StatefulWidget {
  GroupInfoResponse group;

  @override
  State<ScreenNewFollowers> createState() => _ScreenNewFollowersState();

  ScreenNewFollowers({
    required this.group,
  });
}

class _ScreenNewFollowersState extends State<ScreenNewFollowers> {
  bool isDeclineVisible = true;

  void _hideDeclineButton() {
    setState(() {
      isDeclineVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    GroupRequestController controller = Get.put(GroupRequestController(groupId: widget.group.groupInfo!.id!));
    controller.fetchRequestGroupMembers(widget.group.groupInfo!.id!);
    UserController userController = Get.put(UserController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(
              result: true,
            );
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'New Request',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Obx(() {
        return (controller.isLoading.value)
            ? Center(child: CircularProgressIndicator())
            : controller.groupRequests.value.isEmpty
                ? Center(child: Text("No  Request "))
                : ListView.builder(
                    itemCount: controller.groupRequests.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      var member = controller.groupRequests.value[index];
                      return FutureBuilder<Map<String, dynamic>?>(
                          future: userController.getUserInfo(member.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height: 100.h,
                                  child: Center(child: CircularProgressIndicator()));
                            }
                            final user = snapshot.data;

                            return ItemGroupRequest(user: user, group: member,);
                          });
                    },
                  );
      }).marginSymmetric(horizontal: 10),
    );
  }
}
