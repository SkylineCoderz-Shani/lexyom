import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../controllers/controller_get_group_request.dart';
import '../../../controllers/controller_group.dart';
import '../../../models/group_request.dart';

class ItemGroupRequest extends StatelessWidget {
  var user;
  GroupRequest group;
  RxBool loading = false.obs;
  RxBool rejectLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.put(GroupController());
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "${AppEndPoint.userProfile}${user!["profile"]}"),
          ),
          SizedBox(
            width: 6.sp,
          ),
          Expanded(
            child: Text(
              user["name"],
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    loading.value = true;
                    await groupController.acceptGroupRequest(
                        group.groupId, group.userId).then((value) {
                      groupController.addMemberToGroup(
                          group.id.toString(), group.userId.toString(), );

                      Get.find<GroupRequestController>()
                          .fetchRequestGroupMembers(group.groupId);
                    });
                    loading.value = false;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Obx(() {
                      return (loading.value) ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,)) : Center(
                          child: Text(
                            'Accept',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ));
                    }),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    rejectLoading.value = true;
                    await groupController.rejectGroupRequest(
                        group.groupId, group.userId).then((value) {
                      // groupController.addMemberToGroup(
                      //     group.id.toString(), group.userId.toString(), );

                      Get.find<GroupRequestController>()
                          .fetchRequestGroupMembers(group.groupId);
                    });
                    rejectLoading.value = false;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Center(
                        child: Obx(() {
                          return (rejectLoading.value)?CircularProgressIndicator(color: Colors.black,):Text(
                            'Decline',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          );
                        })),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ItemGroupRequest({
    required this.user,
    required this.group,
  });
}
