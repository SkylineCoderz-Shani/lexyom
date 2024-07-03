////
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_full_image_preview.dart';
import 'package:lexyom/src/views/screen_full_videoPlayer.dart';
import 'package:lexyom/src/views/screen_newFollowers_requests.dart';
import 'package:lexyom/src/views/screen_profileImage_view.dart';
import 'package:lexyom/src/views/screen_subscribers.dart';
import 'package:lexyom/src/views/screen_update_group.dart';
import 'package:lexyom/src/views/screen_view_group_admin.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../constants/fcm.dart';
import '../../constants/firebase_utils.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/controller_create_announecment.dart';
import '../../controllers/controller_get_group.dart';
import '../../controllers/controller_get_group_member.dart';
import '../../controllers/controller_get_group_request.dart';
import '../../controllers/controller_group.dart';
import '../../models/message.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_button_withShade.dart';
import 'layouts/item_info_group_audio.dart';
import 'layouts/item_info_group_file.dart';
import 'layouts/item_mute_unmute.dart';

class ScreenGroupInfo extends StatefulWidget {
  int groupId;
  List<Message> messagesList;
  List<String> tokens;

  @override
  State<ScreenGroupInfo> createState() => _ScreenGroupInfoState();

  ScreenGroupInfo({
    required this.groupId,
    required this.messagesList,
    required this.tokens,
  });
}

class _ScreenGroupInfoState extends State<ScreenGroupInfo> {
  RxDouble _currentValue = 0.0.obs;
  RxBool loadingTime = false.obs;
  RxList<double> _values =
      <double>[0, 30, 60, 300, 900, 1800, 3600, 86400, 9999999].obs;

  RxMap<double, String> _labels = <double, String>{
    0: 'Off',
    30: '30s',
    60: '1m',
    300: '5m',
    900: '15m',
    1800: '30m',
    3600: '1h',
    86400: '24h',
    9999999: 'Never'
  }.obs;

  String _getLabelFromValue(double value) {
    return _labels[value] ?? '';
  }

  double _getNearestValue(double value) {
    double nearestValue = _values.first;
    double minDifference = double.infinity;

    for (double v in _values) {
      double difference = (v - value).abs();
      if (difference < minDifference) {
        minDifference = difference;
        nearestValue = v;
      }
    }

    return nearestValue;
  }

  int index = 0;
  RxDouble nearValue = 0.0.obs;
  GroupController groupController = Get.find<GroupController>();

  @override
  void initState() {
    var group = groupController.groupInfo.value.groupInfo!;
    index = _values.indexOf(group.timeSensitive!.toDouble());
    if (index == -1) {
      _currentValue.value =
          _values.first; // Default to the first value if not found
    } else {
      _currentValue.value = index.toDouble();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categorizedMessages =
        MessageCategorizer(widget.messagesList).categorizeMessages();
    AnnouncementController announcementController =
        Get.put(AnnouncementController(groupId: widget.groupId));
    GroupRequestController groupRequestController =
        Get.put(GroupRequestController(groupId: widget.groupId));
    GroupMemberController groupMemberController =
        Get.put(GroupMemberController(groupId: widget.groupId));

    bool isCurrentUserAdmin = groupController.groupInfo.value.admins!
        .any((element) => element.id.toString() == FirebaseUtils.myId);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height * .44,
                width: Get.width,
                decoration: BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              dev.log("message");
                              // Get.back();
                              Navigator.pop(context);
                            },
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30.sp,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Obx(() {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  ScreenProfileView(
                                    imageUrl:
                                        "${AppEndPoint.groupProfile}${groupController.groupInfo.value.groupInfo!.image}",
                                    title:
                                        "${groupController.groupInfo.value.groupInfo!.title}",
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 60.sp,
                                backgroundColor: appPrimaryColor,
                                backgroundImage: NetworkImage(
                                    "${AppEndPoint.groupProfile}${groupController.groupInfo.value.groupInfo!.image}"),
                                // child: Image.asset("assets/icons/group_icon.png",
                              ),
                            );
                          }),
                        ),
                        Expanded(
                          flex: 1,
                          child: (isCurrentUserAdmin == true)
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(ScreenUpdateGroup(
                                        group: groupController.groupInfo.value,
                                      ));
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        CupertinoIcons.pencil,
                                        color: Colors.white,
                                        size: 30.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        )
                      ],
                    ).marginSymmetric(
                      horizontal: 20.sp,
                    ),
                    Obx(() {
                      return Text(
                        groupController.groupInfo.value.groupInfo!.title!,
                        style: title2,
                      );
                    }).marginSymmetric(vertical: 5.h),
                    Obx(() {
                      return Text(
                        "${groupController.groupInfo.value.groupInfo!.numberOfMembers} Members",
                        style: subtitle1,
                      );
                    }).marginSymmetric(
                      vertical: 5.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                "assets/images/logout_icon.png"),
                                            Text("Are You Sure to Leave Group?",
                                                    style: title1)
                                                .marginSymmetric(
                                              vertical: 10.sp,
                                            ),
                                            Text(
                                                textAlign: TextAlign.center,
                                                "Are you sure you want to Leave this group?\nyou can join back easily.",
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
                                                Get.dialog(
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blue,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  ),
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  barrierDismissible: false,
                                                );
                                                await Future.delayed(Duration(
                                                    seconds: 3 +
                                                        (Random().nextInt(2))));
                                                groupController
                                                    .leaveGroup(widget.groupId)
                                                    .then((value) {
                                                  ControllerGetGroup
                                                      controllerGetGroup =
                                                      Get.put(
                                                          ControllerGetGroup());
                                                  controllerGetGroup
                                                      .fetchGroupList();
                                                });
                                              },
                                              text: 'Leave Group',
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
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xff3A3A3A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xffE3FF00),
                                  size: 30.sp,
                                ),
                                Text(
                                  "Leave",
                                  style: TextStyle(
                                    color: Color(0xffE3FF00),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).marginOnly(
                                  right: 6.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        MuteUnmuteContainer(groupId: widget.groupId.toString())
                            .marginSymmetric(
                          horizontal: 10.sp,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xff3A3A3A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_outlined,
                                  color: Color(0xffE3FF00),
                                  size: 30.sp,
                                ),
                                Text(
                                  "Discuss",
                                  style: TextStyle(
                                    color: Color(0xffE3FF00),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).marginOnly(
                                  right: 6.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).marginSymmetric(vertical: 7.h)
                  ],
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: title1,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() {
                      return ReadMoreText(
                        "${groupController.groupInfo.value.groupInfo!.description}  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        trimLines: 1,
                        trimLength: 115,
                        colorClickableText: buttonColor,
                        moreStyle: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                        lessStyle: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      );
                    }).marginSymmetric(
                      horizontal: 20.sp,
                    ),
                  ).marginSymmetric(
                    vertical: 10.sp,
                  ),
                  Container(
                    // height: Get.height * .29,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 13.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(ScreenViewGroupAdmin(
                              adminList:
                                  groupController.groupInfo.value.admins!,
                            ));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15.sp,
                                backgroundColor: Color(0xff24B143),
                                child: Image.asset(
                                    "assets/icons/administrator_icon.png"),
                              ),
                              SizedBox(
                                width: 6.sp,
                              ),
                              Text(
                                "Administrators",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Obx(() {
                                return Text(
                                  "${groupController.groupInfo.value.admins!.length}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                );
                              }),
                              SizedBox(
                                width: 6.sp,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 15.sp,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          indent: 35.sp,
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ScreenSubcribers(
                                group: groupController.groupInfo.value,
                                isAdmin: isCurrentUserAdmin,
                              );
                            }));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15.sp,
                                backgroundColor: Color(0xff26A1D5),
                                child: Image.asset(
                                    "assets/icons/subcribers_icon.png"),
                              ),
                              SizedBox(
                                width: 6.sp,
                              ),
                              Text(
                                "Subscribers",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Obx(() {
                                return Text(
                                  groupMemberController.groupMembers.length
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                );
                              }),
                              SizedBox(
                                width: 6.sp,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 15.sp,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          indent: 35.sp,
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        if (isCurrentUserAdmin == true)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(ScreenNewFollowers(
                                    group: groupController.groupInfo.value,
                                  ));
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.sp,
                                      backgroundColor: Color(0xffF89800),
                                      child: Icon(
                                        Icons.person_add_alt_1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.sp,
                                    ),
                                    Text(
                                      "Join Requests",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Obx(() {
                                      return (groupRequestController
                                              .groupRequests.isEmpty)
                                          ? SizedBox()
                                          : CircleAvatar(
                                              radius: 10.sp,
                                              backgroundColor:
                                                  Color(0xffE3FF00),
                                              child: Text(
                                                "${groupRequestController.groupRequests.length}",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                    }),
                                    SizedBox(
                                      width: 6.sp,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 15.sp,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 35.sp,
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        if (isCurrentUserAdmin == true)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.defaultDialog(
                                    title: "Create Announcement",
                                    content: Column(
                                      children: [
                                        TextFormField(
                                          maxLines: 5,
                                          controller: announcementController
                                              .titleController,
                                          decoration: InputDecoration(
                                              hintText: "Write announcement",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: buttonColor))),
                                        ).marginOnly(bottom: 30.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: CustomButton(
                                              height: 36.h,
                                              fontSize: 12.sp,
                                              onTap: () {
                                                Get.back();
                                              },
                                              text: 'Cancel',
                                            )),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Expanded(child: Obx(() {
                                              return CustomButton(
                                                height: 36.h,
                                                loading: announcementController
                                                    .isLoading.value,
                                                fontSize: 12.sp,
                                                buttonColor: buttonColor,
                                                textColor: Colors.black,
                                                onTap: () async {
                                                  await announcementController
                                                      .createAnnouncement();
                                                  FCM.sendMessageMulti(
                                                      "New Message",
                                                      announcementController
                                                          .titleController.text,
                                                      widget.tokens);

                                                  Get.back();
                                                  announcementController
                                                      .titleController
                                                      .clear();
                                                },
                                                text: 'Submit',
                                              );
                                            })),
                                          ],
                                        ).marginSymmetric(horizontal: 30.w)
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.sp,
                                      backgroundColor: Color(0xffF89800),
                                      child: Icon(
                                        Icons.person_add_alt_1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.sp,
                                    ),
                                    Text(
                                      "Create Announcement",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: 6.sp,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 15.sp,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 35.sp,
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        (isCurrentUserAdmin == true)
                            ? Obx(() {
                                return ExpansionTile(
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  tilePadding: EdgeInsets.zero,
                                  children: [
                                    Row(
                                      children: _values.map((value) {
                                        return Expanded(
                                          child: Text(
                                            _labels[value] ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                        );
                                      }).toList(),
                                    ).marginOnly(right: 20.w, left: 15.w),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.blue,
                                        inactiveTrackColor: Colors.grey,
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 12.0),
                                        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        // valueIndicatorTextStyle: TextStyle(color: Colors.white, fontSize: 9),
                                        // showValueIndicator: ShowValueIndicator.always,
                                      ),
                                      child: Slider(
                                        value: _currentValue.value,
                                        min: 0,
                                        max: (_values.length - 1).toDouble(),
                                        divisions: _values.length - 1,
                                        // label: _getLabelFromValue(_currentValue.value),
                                        onChanged: (value) async {
                                          int index = value.round();
                                          if (index >= 0 &&
                                              index < _values.length) {
                                            nearValue.value = _values[index];
                                            _currentValue.value =
                                                index.toDouble();
                                          } else {
                                            dev.log('Invalid index: $index');
                                          }
                                        },
                                      ),
                                    ),
                                    Obx(() {
                                      return CustomButton(
                                        loading: loadingTime.value,
                                        margin: EdgeInsets.zero,
                                        buttonColor: appPrimaryColor,
                                        text: "Save",
                                        onTap: () async {
                                          loadingTime.value = true;
                                          await Get.find<ChatController>()
                                              .updateTimeSensitive(
                                                  groupController.groupInfo
                                                      .value.groupInfo!.id!,
                                                  nearValue.value.toInt())
                                              .then((value) {
                                            groupController
                                                .fetchGroupInfo(widget.groupId);
                                          });
                                          loadingTime.value = false;
                                        },
                                        textColor: Colors.black,
                                        fontSize: 12.sp,
                                        height: 25.h,
                                        width: 48.w,
                                      );
                                    })
                                  ],
                                  leading: CircleAvatar(
                                    radius: 15.sp,
                                    backgroundColor: Color(0xff5855D6),
                                    child: Icon(
                                      Icons.settings,
                                      color: buttonColor,
                                    ),
                                  ),
                                  title: Text(
                                    "Time Complexity",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Obx(() {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (groupController.groupInfo.value
                                                    .groupInfo!.timeSensitive ==
                                                9999999)
                                            ? Text(
                                                "Never",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "${groupController.groupInfo.value.groupInfo!.timeSensitive! >= 60 ? "${(groupController.groupInfo.value.groupInfo!.timeSensitive! / 60).round()} min" : "${groupController.groupInfo.value.groupInfo!.timeSensitive!.round()} sec"}",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        SizedBox(
                                          width: 6.sp,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 15.sp,
                                        )
                                      ],
                                    );
                                  }),
                                );
                              })
                            : InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.sp,
                                      backgroundColor: Color(0xff5855D6),
                                      child: Icon(
                                        Icons.settings,
                                        color: buttonColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.sp,
                                    ),
                                    Text(
                                      "Time Complexity",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Obx(() {
                                      return (groupController.groupInfo.value
                                                  .groupInfo!.timeSensitive! ==
                                              9999999)
                                          ? Text(
                                              "Never",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : (groupController
                                                      .groupInfo
                                                      .value
                                                      .groupInfo!
                                                      .timeSensitive! ==
                                                  0)
                                              ? Text(
                                                  "Off",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  "${groupController.groupInfo.value.groupInfo!.timeSensitive! >= 60 ? "${(groupController.groupInfo.value.groupInfo!.timeSensitive! / 60).round()} min" : "${groupController.groupInfo.value.groupInfo!.timeSensitive!.round()} sec"}",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                    })
                                  ],
                                ),
                              ),
                        Divider(
                          indent: 35.sp,
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                      ],
                    ).marginSymmetric(
                      horizontal: 20.sp,
                    ),
                  ),
                ],
              ).marginSymmetric(
                horizontal: 20.sp,
              ),
              SizedBox(
                height: 10.sp,
              ),
              Container(
                height: Get.height * 0.44,
                width: Get.width,
                decoration: BoxDecoration(color: Colors.black),
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.blue,
                        labelColor: Colors.blue,
                        tabs: [
                          Tab(text: 'Media'),
                          Tab(text: 'Files'),
                          Tab(text: 'Voice'),
                          Tab(text: 'Links'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.0),
                              color: Colors.white,
                              width: Get.width,
                              child: categorizedMessages["media"]!.isEmpty
                                  ? Center(child: Text("No Media"))
                                  : GridView.builder(
                                      itemCount:
                                          categorizedMessages["media"]!.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // Number of columns
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final message = categorizedMessages[
                                            "media"]![index];
                                        return message.type == MessageType.image
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(ScreenFullImagePreview(
                                                      imageUrl: message
                                                          .imageMessage!
                                                          .imageUrl));
                                                },
                                                child: Image.network(
                                                  message
                                                      .imageMessage!.imageUrl,
                                                  height: Get.height,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenVideoPlayer(
                                                              videoUrl: message
                                                                  .videoMessage!
                                                                  .videoUrl),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(6.0),
                                                  height: Get.height * .45,
                                                  width: Get.width * .7,
                                                  margin:
                                                      EdgeInsets.only(top: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio:
                                                            VideoPlayerController
                                                                    .network(message
                                                                        .content)
                                                                .value
                                                                .aspectRatio,
                                                        child: VideoPlayer(
                                                            VideoPlayerController
                                                                .network(message
                                                                    .content)),
                                                      ),
                                                      Center(
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_outline,
                                                          color: Colors.white,
                                                          size: 64.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 8.5.sp,
                              ),
                              color: Colors.white,
                              child: Center(
                                child: categorizedMessages["files"]!.isEmpty
                                    ? Text("No File")
                                    : ListView.builder(
                                        // shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: categorizedMessages["files"]!
                                            .length,
                                        itemBuilder: (context, index) {
                                          dev.log(categorizedMessages["files"]![
                                                  index]
                                              .toString());
                                          var message = categorizedMessages[
                                              "files"]![index];
                                          return ItemInfoGroupFile(
                                            message: message,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Center(
                                child: categorizedMessages["voice"]!.isEmpty
                                    ? Text("No Voice")
                                    : ListView.builder(
                                        itemCount: categorizedMessages["voice"]!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return ItemInfoGroupAudio(
                                            message: categorizedMessages[
                                                "voice"]![index],
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Center(
                                child: categorizedMessages["links"]!.isEmpty
                                    ? Text("No Link")
                                    : ListView(
                                        children: categorizedMessages["links"]!
                                            .map((message) {
                                          dev.log(message.content.toString());
                                          String url =
                                              extractUrl(message.content);
                                          dev.log(url);

                                          return Container(
                                            padding: EdgeInsets.all(6.0),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: ListTile(
                                              title: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: message.content
                                                          .replaceAll(url, ''),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    TextSpan(
                                                      text: url,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () =>
                                                  _launchUrl(message.content),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String content) async {
    final urlPattern = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+', // Simple URL regex
      caseSensitive: false,
    );

    final match = urlPattern.firstMatch(content);
    if (match != null) {
      final url = match.group(0);
      if (url != null && await canLaunch(url)) {
        await launch(url.startsWith('http') ? url : 'http://$url');
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'No URL found in content';
    }
  }

  String extractUrl(String content) {
    final urlPattern = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+', // Simple URL regex
      caseSensitive: false,
    );
    final match = urlPattern.firstMatch(content);
    return match?.group(0) ?? '';
  }
}

class MessageCategorizer {
  final List<Message> messagesList;

  MessageCategorizer(this.messagesList);

  Map<String, List<Message>> categorizeMessages() {
    List<Message> mediaMessages = [];
    List<Message> fileMessages = [];
    List<Message> voiceMessages = [];
    List<Message> linkMessages = [];

    final urlPattern = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+', // Simple URL regex
      caseSensitive: false,
    );

    for (var message in messagesList) {
      if (message.type == MessageType.text &&
          urlPattern.hasMatch(message.content)) {
        linkMessages.add(message);
      } else {
        switch (message.type) {
          case MessageType.image:
          case MessageType.video:
            mediaMessages.add(message);
            break;
          case MessageType.file:
            fileMessages.add(message);
            break;
          case MessageType.audio:
          case MessageType.voice:
            voiceMessages.add(message);
            break;
          default:
            break;
        }
      }
    }

    return {
      "media": mediaMessages,
      "files": fileMessages,
      "voice": voiceMessages,
      "links": linkMessages,
    };
  }
}
