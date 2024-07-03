import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_profileImage_view.dart';
import 'package:lexyom/src/views/screen_userChat.dart';
import 'package:sign_button/sign_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_user.dart';
import '../../controllers/follow_controller.dart';
import '../../models/user.dart';
import '../CustomWidget/custom_containerFollowUpdates.dart';

class ScreenUserProfileInfo extends StatefulWidget {
  final int id;

  @override
  _ScreenUserProfileInfoState createState() => _ScreenUserProfileInfoState();

  ScreenUserProfileInfo({
    required this.id,
  });
}

class _ScreenUserProfileInfoState extends State<ScreenUserProfileInfo> {
  bool isSecondContainerVisible = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UserController userController = Get.put(UserController());
  FollowController followController = Get.put(FollowController());

  @override
  void initState() {
    userController.getUserDetailInfo(widget.id);
    followController.checkFollowStatus(widget.id);
    log(userController.user.value.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {});
          await userController.getUserDetailInfo(widget.id);
          await followController.checkFollowStatus(widget.id);
        },
        child: SafeArea(
          child: Obx(() => userController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : userController.user.value == null
                  ? Center(
                      child: Text("No User Found"),
                    )
                  : ListView(
                      children: <Widget>[
                        Container(
                          height: Get.height * .45,
                          width: Get.width,
                          decoration: BoxDecoration(color: Colors.black),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        height: 130.sp,
                                        width: 130.sp,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                              color: Colors.white,
                                            )),
                                        child: Obx(() {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(ScreenProfileView(
                                                  imageUrl:
                                                      "${AppEndPoint.userProfile}${userController.user.value!.user.information.profile}",
                                                  title:
                                                      "${userController.user.value!.user.information.name}"));
                                            },
                                            child: CircleAvatar(
                                              radius: 60.r,
                                              backgroundImage: NetworkImage(
                                                  "${AppEndPoint.userProfile}${userController.user.value!.user.information.profile}"),
                                            ),
                                          );
                                        }),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userController
                                        .user.value!.user.information.name,
                                    style: title2,
                                  ),
                                  SizedBox(width: 10.sp),
                                  Container(
                                    height: 25.sp,
                                    width: 75.sp,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.diamond_outlined,
                                          color: Colors.purple,
                                          size: 15.sp,
                                        ),
                                        SizedBox(width: 5.sp),
                                        Text(
                                          userController.user.value!.user
                                              .information.points,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FollowUpdateUserContainer(id: widget.id),
                                    if (followController
                                            .followCheckStatusMessage.value ==
                                        "Accept")
                                      GestureDetector(
                                        onTap: () {
                                          followController.rejectFollow(
                                            widget.id,
                                          );
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: Get.width * 0.4,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ).marginSymmetric(
                                          vertical: 10.sp,
                                          horizontal: 10.sp,
                                        ),
                                      ),
                                    if (followController.canChat.value ==
                                        " yes")
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(ScreenUserChat(
                                            user: userController.user.value!,
                                          ));
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: Get.width * 0.4,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE3FF00),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Message",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ).marginSymmetric(
                                          vertical: 10.sp,
                                          horizontal: 10.sp,
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userController
                                        .user.value!.user.information.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Icon(
                                    size: 25.sp,
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: .03.sh,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userController.user.value!.user.information
                                        .occupation,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Icon(
                                    size: 25.sp,
                                    CupertinoIcons.pencil_circle_fill,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: .03.sh,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      userController
                                          .user.value!.user.information.email,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    size: 25.sp,
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: .03.sh,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      userController.user.value!.user
                                          .information.location,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    size: 25.sp,
                                    CupertinoIcons.location_circle_fill,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: .03.sh,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userController
                                        .user.value!.user.information.company,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Icon(
                                    size: 25.sp,
                                    Icons.local_activity,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              SocialMediaButtons(
                                  socials:
                                      userController.user.value!.user.socials),
                            ],
                          ),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}

class SocialMediaButtons extends StatelessWidget {
  final Socials socials;

  SocialMediaButtons({required this.socials});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: _buildSocialButtons([
        {'type': ButtonType.instagram, 'username': socials.instagram},
        {'type': ButtonType.facebook, 'username': socials.facebook},
        {'type': ButtonType.tumblr, 'username': socials.tiktok},
        {'type': ButtonType.linkedin, 'username': socials.linkedin},
        {'type': ButtonType.twitter, 'username': socials.twitter},
        {'type': ButtonType.reddit, 'username': socials.threads},
        {'type': ButtonType.google, 'username': socials.warpcast},
        {'type': ButtonType.youtube, 'username': socials.youtube},
      ]),
    ).marginOnly(
      top: 15.sp,
    );
  }

  List<Widget> _buildSocialButtons(List<Map<String, dynamic>> buttons) {
    List<Widget> socialButtons = [];
    for (var button in buttons) {
      if (button['username'] != null) {
        socialButtons.add(SignInButton.mini(
          buttonSize: ButtonSize.small,
          buttonType: button['type'],
          onPressed: () {
            _openProfile(button['type'], button['username']);
          },
        ));
      }
    }
    return socialButtons;
  }

  void _openProfile(ButtonType type, String username) {
    String url;
    switch (type) {
      case ButtonType.instagram:
        url = 'https://www.instagram.com/$username';
        break;
      case ButtonType.facebook:
        url = 'https://www.facebook.com/$username';
        break;
      case ButtonType.custom:
        url = 'https://www.tiktok.com/@$username';
        break;
      case ButtonType.linkedin:
        url = 'https://www.linkedin.com/in/$username';
        break;
      case ButtonType.twitter:
        url = 'https://twitter.com/$username';
        break;
      case ButtonType.google:
        url = 'https://warpcast.com/$username';
        break;
      case ButtonType.youtube:
        url = 'https://www.youtube.com/$username';
        break;
      default:
        url = '';
    }
    _launchUrl(url);
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Alert", "No Url Exists",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
