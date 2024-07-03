import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../controllers/controller_getAll_notification.dart';

class LayoutNotification extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*1;
    final width = MediaQuery.of(context).size.width*1;
    final notificationController = Get.put(NotificationController());
    // Initialize the controller
    notificationController.fetchNotificationList().then((value) {
      if (notificationController.notificationList.isNotEmpty &&
          notificationController.hasUnseenNotifications.value) {
        notificationController.updateNotifications();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Notifications',
            style: title1,
          ),
        ),
        body: RefreshIndicator.adaptive(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            // Implement your refresh logic here
            notificationController.fetchNotificationList().then((onValue) {
              if (notificationController.notificationList.isNotEmpty &&
                  notificationController.hasUnseenNotifications.value) {
                notificationController.updateNotifications();
              }
            });
          },
          child: Obx(() {
            if (notificationController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (notificationController.notificationList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: height*.2.sp,
                      fit: BoxFit.fill,
                        "assets/images/notification.png"),
                    Text(
                      "         There’s No\nNotifications to Read!",
                      style: title1,
                    ),
                    Text(
                      "Explore Skorpio and all of your notifications will be\nshown here.",
                      style: subtitle2,
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("assets/images/notification.png"),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationController.notificationList.length,
                      itemBuilder: (context, index) {
                        final notification =
                            notificationController.notificationList[index];
                        return ListTile(
                          title: Text(
                            '${notification.title ?? ''}',
                            style: subtitle3,
                          ),
                          leading: Container(
                            height: 60.sp,
                            width: 60.sp,
                            decoration: BoxDecoration(
                              color: Color(0xffE3FF00),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 4.sp,
                                color: Colors.white,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.bell_fill,
                                color: Colors.black,
                                size: 27.sp,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            "${notification.body ?? ''}",
                            style: subtitle2,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
