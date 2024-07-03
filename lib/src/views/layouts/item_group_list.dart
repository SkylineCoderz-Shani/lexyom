import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/chat_constant.dart';
import '../../../constants/colors.dart';
import '../../../constants/firebase_utils.dart';
import '../../../controllers/controller_get_announcments.dart';
import '../../../controllers/controller_get_group.dart';
import '../../../controllers/controller_get_group_request.dart';
import '../../../controllers/controller_group.dart';
import '../../../controllers/home_controllers.dart';
import '../../HomeScreen/HomeView/screen_group_chat.dart';

class ItemGroupList extends StatelessWidget {
  final Groups group;

  RxString status = "Join".obs;
  var isUserInGroup = false.obs;
  var loading = false.obs;
  var userJoinStatus = "".obs;

  void checkUserInGroup(Groups group, int userId) {
    // log(group.id.toString());
    for (var member in group.members) {
      if (member.userId == userId) {
        isUserInGroup.value = true;
        if (member.canJoin == 0) {
          status.value = "Requested";
        } else {
          status.value = "Joined";
        }
        // userJoinStatus.value = member.canJoin == 1 ? "Joined" : "Requested";
        return;
      } else {
        isUserInGroup.value = false;
        status.value = "Join";
        // log(isUserInGroup.value.toString());
      }
    }
  }

  GroupController groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    var userId = Get.find<ControllerHome>().user.value!.user.information.id;
    checkUserInGroup(group, userId);
    GroupRequestController groupRequestController =
        Get.put(GroupRequestController(groupId: group.id));
    var adminMember =
        group.members.where((element) => element.isAdmin == 1).toList();
    bool isCurrentUserAdmin = adminMember
        .any((element) => element.userId.toString() == FirebaseUtils.myId);
    AnnouncementGetController announcementController =
        Get.put(AnnouncementGetController(groupId: group.id));
    // announcementController.fetchAnnouncements();
    announcementController.fetchUnSeenAnnouncements(group.id);

    return GestureDetector(
      onTap: () async {
        // ChatGroup chatGroup = ChatGroup(id: group.members.first.groupId.toString(), eventId: group.members.first.groupId.toString(), memberIds: [FirebaseUtils.myId]);
        //
        // await chatGroupRef.child(group.members.first.groupId.toString()).set(chatGroup.toMap()).then((value) {
        //   print("Success add messaeGroup");
        //   Get.to(ScreenGroupChat(group: group,));
        // }).catchError((error) {
        //   print(error);
        //
        // });

        if (isUserInGroup.value == true && status.value == "Joined") {
          Get.to(() => ScreenGroupChat(
                group: group,
              ));
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
            width: Get.width,
            margin: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: Get.height * 0.14,
                    width: Get.width * 0.37,
                    // color: Colors.red,
                    child: Stack(
                      children: [
                        if (group.profile.length > 0)
                          Positioned(
                            //top
                            left: 38.w,
                            right: 38.w,
                            top: 8.h,
                            bottom: 68.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  "${AppEndPoint.userProfile}${group.profile[0]}"),
                            ),
                          ),
                        if (group.profile.length > 1)
                          Positioned(
                            left: 8.w,
                            right: 68.w,
                            top: 38.h,
                            bottom: 38.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  "https://skorpio.codergize.com/user/${group.profile[1]}"),
                            ),
                          ),
                        Positioned(
                          //number
                          left: 38.w,
                          right: 38.w,
                          top: 38.h,
                          bottom: 38.h,
                          child: CircleAvatar(
                            // radius: 17.r,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              "+${group.numberOfMembers}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        if (group.profile.length > 2)
                          Positioned(
                            left: 38.w,
                            right: 38.w,
                            top: 68.h,
                            bottom: 8.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  "https://skorpio.codergize.com/user/${group.profile[2]}"),
                            ),
                          ),
                        if (group.profile.length > 3)
                          Positioned(
                            left: 68.w,
                            right: 8.w,
                            top: 38.h,
                            bottom: 38.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  "https://skorpio.codergize.com/user/${group.profile[3]}"),
                            ),
                          ),
                      ],
                    )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.title,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold) // Ensure 'title2' is defined
                        ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundColor: Color(0xff02FF9E),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          '${group.activeUsers} online',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFFAAB2B7),
                              fontWeight: FontWeight
                                  .w500), // Ensure 'subtitle2' is defined
                        ),
                      ],
                    ).marginSymmetric(vertical: 7.h),
                    Text(
                      group.description,
                      maxLines: 2,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFAAB2B7)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isUserInGroup.value == false) {
                          loading.value = true;
                          await groupController
                              .joinGroup(group.id)
                              .then((value) {
                            loading.value = false;
                            if (group.isPrivate != 1) {
                              groupController.addMemberToGroup(
                                group.id.toString(),
                                FirebaseUtils.myId,
                              );
                            }
                            Get.find<ControllerGetGroup>().fetchGroupList();
                          });

                          status.value = "Join";
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20.h),
                        height: 40.h,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(
                          color: status.value == "Join"
                              ? buttonColor
                              : status.value == "Requested"
                                  ? Colors.orange
                                  : Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Obx(() {
                            return (loading.value)
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    status.value,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  );
                          }),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ).marginSymmetric(
              horizontal: 5.sp,
            ),
          ),
          Positioned(
            top: 10.h,
            right: 30.w,
            child: StreamBuilder<int>(
              stream:
                  messageCounterStream(group.id.toString(), FirebaseUtils.myId),
              builder: (context, snapshot) {
                // Check the connection state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }

                // Initialize counts
                int messageCount = 0;
                int unSeenAnnouncementsCount =
                    announcementController.unSeenAnnouncements.value.length;
                log("unsee$unSeenAnnouncementsCount");
                int groupRequestsCount = isCurrentUserAdmin
                    ? groupRequestController.groupRequests.value.length
                    : 0;
                log("groupReq$groupRequestsCount");

                // Check if the snapshot has data
                if (snapshot.hasData) {
                  messageCount = snapshot.data!;
                }
                log(messageCount.toString());

                // Calculate the combined count
                int combinedCount = messageCount +
                    unSeenAnnouncementsCount +
                    groupRequestsCount;

                // If the combined count is zero, return a SizedBox
                if (combinedCount == 0) {
                  return SizedBox();
                }

                // Return the CircleAvatar with the combined count
                return CircleAvatar(
                  radius: 10.sp,
                  backgroundColor: buttonColor,
                  child: Text(
                    combinedCount.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ItemGroupList({
    required this.group,
  });

  Stream<int> messageCounterStream(String groupId, String userId) {
    return chatGroupRef
        .child(groupId)
        .child('messageCounters')
        .child(userId)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        return event.snapshot.value as int;
      } else {
        return 0;
      }
    });
  }
}
