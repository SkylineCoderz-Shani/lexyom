import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../controllers/follow_controller.dart';
import '../../../models/follow_request.dart';

class ItemUserFollowRequest extends StatelessWidget {
  FollowRequest followRequest;
  RxBool loading = false.obs;
  RxBool rejectLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    FollowController followController = Get.put(FollowController());
    return Container(
      height: 70,
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
          Expanded(
            child: Text(
              followRequest.name,
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
                    await followController
                        .acceptFollow(followRequest.id)
                        .then((value) {
                      followController.fetchFollowRequests();
                    });
                    loading.value = false;
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Obx(() {
                      return (loading.value)
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.black,
                            ))
                          : Center(
                              child: Text(
                              'Accept',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ));
                    }),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    rejectLoading.value = true;
                    await followController
                        .rejectFollow(followRequest.id)
                        .then((value) {
                      followController.fetchFollowRequests();
                    });
                    rejectLoading.value = false;
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Center(child: Obx(() {
                      return (rejectLoading.value)
                          ? CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              'Decline',
                              style: TextStyle(fontWeight: FontWeight.bold),
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

  ItemUserFollowRequest({
    required this.followRequest,
  });
}
