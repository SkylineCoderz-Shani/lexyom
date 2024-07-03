import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../../constants/ApiEndPoint.dart';
import '../../controllers/controller_get_announcments.dart';

class CustomSidebar extends StatelessWidget {
  final Function(int) onMenuItemClicked;
  final Groups group;

  const CustomSidebar(
      {Key? key, required this.onMenuItemClicked, required this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnnouncementGetController announcementController =
        Get.put(AnnouncementGetController(groupId: group.id));
    announcementController.fetchAnnouncements(group.id);
    announcementController.updateUnseenAnnouncements(group.id);
    return Drawer(
      child: Container(
        width: Get.width * .2,
        color: Colors.grey[200],
        child: Padding(
          padding: EdgeInsets.only(
            top: 50.sp,
            left: 20.sp,
            right: 20.sp,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Get.back(
                      result: true,
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  // height: 50.sp,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.13),
                            spreadRadius: 1,
                            offset: Offset(1, 3),
                            blurStyle: BlurStyle.outer),
                      ]),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        // backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "${AppEndPoint.groupProfile}${group.img}"),
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Expanded(
                        child: Text(
                          group.title,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ).marginSymmetric(
                    horizontal: 10.sp,
                  ),
                ).marginOnly(top: 30.h, bottom: 10.h),
                Obx(() {
                  return (announcementController.isLoading.value)
                      ? SizedBox(
                          height: Get.height * .2,
                          child: Center(child: CircularProgressIndicator()))
                      : ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            var announcement = announcementController
                                .announcements.value[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.chat_bubble_text_fill,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Expanded(
                                  child: Text(
                                    announcement.title,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ).marginOnly(bottom: 20.h);
                          },
                          itemCount:
                              announcementController.announcements.value.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        );
                }),
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Text(
                        "Back to community",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
