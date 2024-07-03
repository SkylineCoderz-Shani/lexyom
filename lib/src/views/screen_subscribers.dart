import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/extensions/time_ago.dart';
import 'package:lexyom/src/views/screen_add_subscribers.dart';
import 'package:lexyom/src/views/screen_userProfileInfo.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_get_group_member.dart';
import '../../controllers/controller_group.dart';
import '../../models/group_info.dart';

class ScreenSubcribers extends StatelessWidget {
  GroupInfoResponse group;
  bool isAdmin;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<
      RefreshIndicatorState>();


  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.put(GroupController());

    GroupMemberController controller = Get.put(
        GroupMemberController(groupId: group.groupInfo!.id!));
    controller.fetchGroupMembers(group.groupInfo!.id!);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Obx(() {
          return Text(
            "${controller.groupMembers.value.length} Members", style: title1,);
        })
        ,
        // actions: [
        //   IconButton(
        //       onPressed: () {}, icon: Icon(Icons.search, color: Colors.black,)),
        //   IconButton(onPressed: () {},
        //       icon: Icon(CupertinoIcons.pen, color: Colors.black,)),
        //
        // ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await controller.fetchGroupMembers(group.groupInfo!.id!);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(isAdmin)GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ScreenAddSubscribers(group: group);
                      }));
                },
                child: Container(
                  height: Get.height * .07,
                  width: Get.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.add, color: buttonColor,),
                      SizedBox(width: 6.sp,),
                      Text("Add subscriber ", style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: buttonColor,
                      ),),
                    ],
                  ).marginSymmetric(
                    horizontal: 20.sp,
                    vertical: 15.sp,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "TOP ${controller.topUsers.length} MEMBERS OF THIS COMMUNITY",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),),
              ).marginSymmetric(
                horizontal: 20.sp,
                vertical: 10.sp,
              ),
              Obx(() {
                return (controller.topUsers.isEmpty) ? Center(
                  child: Text("No Top Users"),) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(controller.topUsers.length, (index) =>
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 25.sp,
                            backgroundImage: NetworkImage(
                                "${AppEndPoint.userProfile}${controller
                                    .topUsers[index].profile}"),
                          ),
                          Text(
                            controller.topUsers[index].name, style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),).marginSymmetric(
                            vertical: 6.sp,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.diamond_outlined,
                                color: Colors.purple,
                                size: 15.sp,
                              ),
                              SizedBox(width: 5.sp),
                              Obx(() {
                                return Text(
                                    "${controller.topUsers[index]
                                        .totalPoints}");
                              })
                            ],
                          ).marginSymmetric(
                            vertical: 5.sp,
                          ),
                        ],
                      )),
                );
              }).marginSymmetric(
                vertical: 10.sp,
              ),
              Text("CONTACTS IN THIS CHANNEL", style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),).paddingOnly(
                right: 120.sp,
                bottom: 10.sp,
              ),
              Container(
                  height: Get.height * .5,
                  width: Get.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView.builder(
                    itemCount: controller.groupMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      var member = controller.groupMembers[index];
                      log(member.lastSeen ?? "0");
                      DateTime dateTime = DateTime.parse(
                          member.lastSeen ?? "2024-05-29 09:17:25");

                      return Column(children: [
                        ListTile(
                          onTap: () {
                            Get.to(ScreenUserProfileInfo(id: member.id,));
                          },
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text("${controller.groupMembers[index].name}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                SizedBox(width: 8.0.sp),
                                Container(
                                  // padding: EdgeInsets.all(6.0),
                                  constraints: BoxConstraints(
                                    minWidth: 45.sp,
                                    minHeight: 20.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(15.sp),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.diamond_outlined,
                                        color: Colors.purple,
                                        size: 15.sp,
                                      ),
                                      // SizedBox(width: 5.sp),
                                      Obx(() {
                                        return Text(
                                          "${controller.groupMembers[index]
                                              .totalPoints == null
                                              ? 0
                                              : controller.groupMembers[index]
                                              .totalPoints}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      })
                                    ],
                                  ).marginSymmetric(
                                    // vertical: 5.sp,
                                      horizontal: 5.sp
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            "last seen ${dateTime.toRelativeTime}",
                            style: subtitle1,),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "${AppEndPoint.userProfile}${member.profile}"
                            ),
                          ),
                          trailing: (isAdmin) ? PopupMenuButton(
                            icon: Icon(Icons.more_vert, color: Colors.white,),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(child: Text("Make Admin"),
                                  value: "Make Admin",),
                                PopupMenuItem(
                                  child: Text("Remove"), value: "Remove",),
                              ];
                            },
                            onSelected: (value) {
                              if (value == "Make Admin") {
                                log(value.toString());
                                groupController.addGroupAdmin(
                                    group.groupInfo!.id!, member.id).then((
                                    vvalue) {
                                  groupController.fetchGroupInfo(
                                      group.groupInfo!.id!);
                                });
                              }
                              else if (value == "Remove") {
                                log(value.toString());
                                groupController.removeUser(
                                    group.groupInfo!.id!, member.id).then((
                                    vvalue) {
                                  groupController.fetchGroupInfo(
                                      group.groupInfo!.id!);
                                });
                              }
                            },
                          ) : SizedBox(),
                        ),
                        Divider(
                          indent: 69.sp,
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ],);
                    },)
              ),
            ],
          ).marginOnly(
            top: 30.sp,
          ),
        ),
      ),
    );
  }

  ScreenSubcribers({
    required this.group,
    required this.isAdmin,

  });
}
