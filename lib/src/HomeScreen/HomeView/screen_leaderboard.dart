import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../controllers/controller_leaderboard.dart';
import '../../../controllers/controller_user.dart';
import '../../../custom_package/date_picker/src/views/custom_month_picker.dart';
import '../../CustomWidget/custom_listview_builder.dart';
import '../../CustomWidget/gfa_container.dart';

class ScreenLeaderboard extends StatelessWidget {
  ScreenLeaderboard({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UserController controllerUser = Get.put(UserController());
  ControllerLeaderBoard controllerLeaderBoard =
      Get.put(ControllerLeaderBoard());
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await controllerLeaderBoard.getLeaderBoardList(
              selectedDate.value.month, selectedDate.value.year);
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top contributors',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    showMonthPicker(context, onSelected: (month, year) async {
                      controllerLeaderBoard.getLeaderBoardList(month, year);
                      selectedDate.value = DateTime(year, month, 1);
                      log(selectedDate.toString());

                      log('Selected month: $month, year: $year');
                    },
                        initialSelectedMonth: DateTime.now().month,
                        initialSelectedYear: DateTime.now().year,
                        firstYear: 2000,
                        lastYear: DateTime.now().year,
                        firstEnabledMonth: 3,
                        lastEnabledMonth: 10,
                        selectButtonText: 'OK',
                        cancelButtonText: 'Cancel',
                        highlightColor: appPrimaryColor,
                        textColor: Colors.black,
                        contentBackgroundColor: Colors.white,
                        dialogBackgroundColor: Colors.grey[200]);
                  },
                  child: Obx(() {
                    return Text(
                      '${DateFormat('MMM yyyy').format(selectedDate.value)}',
                      style: TextStyle(
                          color: Color(0xFFFF3131),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFF3131)),
                    );
                  }).paddingSymmetric(horizontal: 10.dm),
                )
              ],
            ).marginSymmetric(horizontal: 20.w, vertical: 10.h),
            Expanded(
              child: Obx(() {
                return controllerLeaderBoard.isLoading.value
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: controllerLeaderBoard
                                          .topThree.value?.isNotEmpty ??
                                      false
                                  ? CustomListviewBuilder(
                                      scrollDirection:
                                          CustomDirection.horizontal,
                                      itemCount: controllerLeaderBoard
                                          .topThree.value!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var top = controllerLeaderBoard
                                            .topThree.value![index];
                                        return FutureBuilder<
                                            Map<String, dynamic>?>(
                                          future: controllerUser
                                              .getUserInfo(top.userId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              log(snapshot.error.toString());
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (snapshot.hasData) {
                                              final user = snapshot.data;
                                              if (user != null) {
                                                return Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 40,
                                                      backgroundColor:
                                                          buttonColor,
                                                      backgroundImage: NetworkImage(
                                                          "${AppEndPoint.userProfile}${user["profile"]}"),
                                                    ),
                                                    Text(
                                                      "${user["name"]}",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.diamond,
                                                            color:
                                                                Colors.purple,
                                                            size: 15),
                                                        SizedBox(width: 4),
                                                        Text(
                                                            '${top.totalPoints}'),
                                                      ],
                                                    ),
                                                  ],
                                                ).marginOnly(right: 10.sp);
                                              } else {
                                                return Center(
                                                    child: Text(
                                                        'User data not found'));
                                              }
                                            } else {
                                              return Center(
                                                  child: Text('No data'));
                                            }
                                          },
                                        );
                                      },
                                    ).marginSymmetric(
                                      horizontal: 10.sp,
                                    )
                                  : Text("No Top User"),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Leaderboard members',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ).marginOnly(top: 10.h),
                          Expanded(
                            child: GFAContainer(
                              myPadding: EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xFF000000),
                              MyBorderRadious: 30,
                              child: controllerLeaderBoard.remainingLeaderBoard
                                          .value?.isNotEmpty ??
                                      false
                                  ? ListView.builder(
                                      itemCount: controllerLeaderBoard
                                          .remainingLeaderBoard.value!.length,
                                      itemBuilder: (context, index) {
                                        final remainingUser =
                                            controllerLeaderBoard
                                                .remainingLeaderBoard
                                                .value!
                                                .values
                                                .elementAt(index);
                                        return FutureBuilder<
                                            Map<String, dynamic>?>(
                                          future: controllerUser.getUserInfo(
                                              remainingUser.userId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              log(snapshot.error.toString());
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (snapshot.hasData) {
                                              final user = snapshot.data;
                                              if (user != null) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          remainingUser.rank
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80),
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(user[
                                                                      "profile"]),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          user["name"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ).marginOnly(
                                                            left: 10.w),
                                                        Spacer(), // Adjusted spacing here
                                                        Text(
                                                          remainingUser
                                                              .totalPoints
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFE3FF00),
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ).marginSymmetric(
                                                      vertical: 15,
                                                      horizontal: 20,
                                                    ),
                                                    Divider(
                                                        color: Colors.white,
                                                        height: 3),
                                                  ],
                                                );
                                              } else {
                                                return Center(
                                                    child: Text(
                                                        'User data not found'));
                                              }
                                            } else {
                                              return Center(
                                                  child: Text('No data'));
                                            }
                                          },
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                      "No Member Yet",
                                      style: TextStyle(
                                          fontSize: 20.sp, color: Colors.white),
                                    )),
                            ).marginOnly(top: 10.h, bottom: 40.h),
                          ),
                        ],
                      );
              }).marginSymmetric(
                horizontal: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
