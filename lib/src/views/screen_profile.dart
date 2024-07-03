import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_ChangePassword.dart';
import 'package:lexyom/src/views/screen_profileImage_view.dart';
import 'package:lexyom/src/views/screen_subscrptionSimple.dart';
import 'package:lexyom/src/views/screen_update_hobby.dart';
import 'package:lexyom/src/views/screen_user_follow.dart';
import 'package:lexyom/src/views/screens/screen_connected_user.dart';
import 'package:lexyom/src/views/screens/screen_connecting_user.dart';
import 'package:lexyom/src/views/screens_social_media_accounts.dart';

import '../../api_integration/authentication_APIServices/login_api_service.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/follow_controller.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_button_withShade.dart';
import 'screen_EditProfile.dart';

class ScreenProfile extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    ControllerHome controllerHome = Get.put(ControllerHome());
    FollowController followController = Get.put(FollowController());
    followController.fetchFollowRequests();
    followController.fetchFollowCount();
    followController.fetchConnectersList();
    followController.fetchConnectingList();

    return Scaffold(
        body: RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        // Implement your refresh logic here
        controllerHome.fetchUserInfo();
        followController.fetchFollowRequests();
      },
      child: ListView(
        children: [
          Container(
            height: Get.height * .4,
            width: Get.width,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 136.sp,
                      width: 136.sp,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                          )),
                      child: Obx(() {
                        return InkWell(
                          onTap: () {
                            Get.to(ScreenProfileView(
                              imageUrl:
                                  "${AppEndPoint.userProfile}${controllerHome.user.value!.user.information.profile}",
                              title:
                                  "${controllerHome.user.value!.user.information.name}",
                            ));
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(controllerHome
                                        .user.value ==
                                    null
                                ? image_url
                                : "${AppEndPoint.userProfile}${controllerHome.user.value!.user.information.profile}"),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        controllerHome.user.value!.user.information.name,
                        style: title2,
                      );
                    }),
                    SizedBox(width: 10.sp),
                    Container(
                      height: 25.sp,
                      width: 75.sp,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.diamond_outlined,
                            color: Colors.purple,
                            size: 15.sp,
                          ),
                          SizedBox(width: 5.sp),
                          Obx(() {
                            return Text(
                              controllerHome.user.value!.user.information.points
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ScreenConnectedUser());
                        },
                        child: Container(
                          height: 50.sp,
                          decoration: BoxDecoration(
                            color: Color(0xffE3FF00),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                return Text(
                                  "${followController.connectersCount.value == 0 ? "0" : "${followController.connectersCount.value}"}   ",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                              Text(
                                "Connected",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ScreenConnectingUser());
                        },
                        child: Container(
                          height: 50.sp,
                          decoration: BoxDecoration(
                            color: appPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                return Text(
                                  "${followController.connectingCount.value == 0 ? "0" : "${followController.connectingCount.value}"}   ",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                              Text(
                                "Connecting",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ).marginSymmetric(horizontal: 20.w)
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ScreenEditProfile(
                user: controllerHome.user.value!,
              ));
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: appPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/pencil-line.svg",
                    ),
                  ),
                ),
                Text(
                  "Change Profile Details",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30.sp,
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
          Obx(() {
            return (controllerHome.user.value!.user.information.plan !=
                        "Golden" &&
                    controllerHome.user.value!.user.information.web3Plan != 1)
                ? InkWell(
                    onTap: () {
                      Get.to(ScreenSubscription());
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 45.sp,
                          padding: EdgeInsets.all(8.h),
                          width: 45.sp,
                          decoration: BoxDecoration(
                              color: appPrimaryColor,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              )),
                          child: Center(
                            child: Image.asset(
                              "assets/images/change-plan.png",
                            ),
                          ),
                        ),
                        Text(
                          "Change Subscription",
                          style: profileFontText,
                        ).marginSymmetric(
                          horizontal: 8.sp,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 30.sp,
                        )
                      ],
                    ).marginSymmetric(
                      vertical: 10.sp,
                      horizontal: 10.sp,
                    ),
                  )
                : SizedBox();
          }),
          InkWell(
            onTap: () {
              Get.to(ScreenUserFollow());
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: appPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: Image.asset(
                      "assets/images/tv.png",
                    ),
                  ),
                ),
                Text(
                  "Follow Requests",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Row(
                  children: [
                    Obx(() {
                      return (followController.followRequests.value.isEmpty)
                          ? SizedBox()
                          : CircleAvatar(
                              radius: 10.sp,
                              backgroundColor: Color(0xffE3FF00),
                              child: Text(
                                "${followController.followRequests.value.length}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            );
                    }),
                    SizedBox(
                      width: 10.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 30.sp,
                    ),
                  ],
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ScreenEmailVerification(
                user: controllerHome.user.value!,
              ));
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: appPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: Image.asset(
                      "assets/images/lock.png",
                    ),
                  ),
                ),
                Text(
                  "Change Password",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30.sp,
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ScreenUpdateHobby());
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: appPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: Icon(Icons.hotel_class),
                  ),
                ),
                Text(
                  "Change Hobbies & Brand",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30,
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ScreenSociaMediaAccounts());
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: appPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: Image.asset(
                      height: 25,
                      "assets/icons/social-media.png",
                    ),
                  ),
                ),
                Text(
                  "Social Media Accounts",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30.sp,
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return Container(
                    width: Get.width,
                    height: Get.height * .6,
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/logout_icon.png"),
                              Text("Are You Sure?", style: title1)
                                  .marginSymmetric(
                                vertical: 10.sp,
                              ),
                              Text(
                                  textAlign: TextAlign.center,
                                  "Are you sure you want to logout from this account?\nyou can log back in easily.",
                                  style: subtitle2),
                              CustomButton(
                                onTap: () {
                                  Get.back(
                                    result: true,
                                  );
                                },
                                text: "Cancel",
                                textColor: Colors.black,
                                buttonColor: buttonColor,
                              ).marginSymmetric(
                                vertical: 10.sp,
                              ),
                              CustomButtonShade(
                                onTap: () async {
                                  // print("Logout Successfully");
                                  Get.dialog(
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                        backgroundColor: Colors.transparent,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    barrierDismissible: false,
                                  );
                                  // await Future.delayed(Duration(
                                  //     seconds: 3 + (Random().nextInt(2))));
                                  await LoginAPIService.logout();
                                  Get.find<ControllerHome>().dispose();
                                },
                                text: 'Logout',
                                textColor: Colors.red,
                                buttonColor: Colors.white,
                              ),
                            ],
                          ).marginSymmetric(
                            horizontal: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                  child: Center(
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                  ),
                ),
                Text(
                  "Logout",
                  style: profileFontText,
                ).marginSymmetric(
                  horizontal: 8.sp,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30.sp,
                )
              ],
            ).marginSymmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
          ),
        ],
      ),
    ));
  }
}
