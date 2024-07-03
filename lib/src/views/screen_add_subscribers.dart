import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_group.dart';
import '../../controllers/controller_search_subscriber.dart';
import '../../controllers/controller_search_users.dart';
import '../../models/group_info.dart';
import '../../models/non_member.dart';

class ScreenAddSubscribers extends StatelessWidget {
  GroupInfoResponse group;

  @override
  Widget build(BuildContext context) {
    ControllerSearchSubscriber controllerSearchUsers =
    Get.put(ControllerSearchSubscriber());
    GroupController groupController = Get.put(GroupController());
    controllerSearchUsers.fetchUserList(group.groupInfo!.id!);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Subscribers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 45.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.withOpacity(.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: TextFormField(
                onChanged: (value) {
                },
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  hintText: "Search Users",
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return controllerSearchUsers.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : controllerSearchUsers.userList.value.isEmpty
                  ? Center(
                child: Text("No User"),
              )
                  : ListView.builder(
                itemCount: controllerSearchUsers.userList.length,
                itemBuilder: (context, index) {
                  final user = controllerSearchUsers.userList[index];
                  return ItemAddSubscriber(user: user, group: group);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  ScreenAddSubscribers({
    required this.group,
  });
}

class ItemAddSubscriber extends StatelessWidget {
  NonGroupMember user;
  GroupInfoResponse group;
  var groupController = Get.put(GroupController());
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text('${user.name} '),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            "${AppEndPoint.userProfile}${user.profile}"),
      ),
      trailing: GestureDetector(
        onTap: () async {
          loading.value = true;

          await groupController.addSubscriber(group.groupInfo!.id!, user.id).then((value){
           Get.find<ControllerSearchSubscriber>().fetchUserList(group.groupInfo!.id!);
           Get.find<GroupController>().fetchGroupInfo(group.groupInfo!.id!);
           loading.value = false;

         }).catchError((onError){
           loading.value = false;

         });
          loading.value = false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: buttonColor,
          ),
          child: Obx(() {
            return loading.value?SizedBox(
                height: 15.h,
                width: 15.w,
                child: CircularProgressIndicator(color: Colors.black,)):Text("Add", style: TextStyle(color: Colors.black),);
          }),
        ),
      ),
    );
  }

  ItemAddSubscriber({
    required this.user,
    required this.group,
  });
}
