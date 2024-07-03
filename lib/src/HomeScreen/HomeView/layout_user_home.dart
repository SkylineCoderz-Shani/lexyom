import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/HomeScreen/HomeView/screen_leaderboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../controllers/controller_category.dart';
import '../../../controllers/controller_process.dart';
import '../../../controllers/home_controllers.dart';
import '../../CustomWidget/csutom_containerCourses.dart';
import '../../views/layouts/item_category.dart';
import '../../views/screen_Services.dart';
import '../../views/screen_askScorpio.dart';
import '../../views/screen_groupCreation.dart';
import '../../views/screen_projectCompleted.dart';

class LayoutUserHome extends StatelessWidget {
  LayoutUserHome({super.key});

  TextEditingController searchController = TextEditingController();
  ControllerHome controllerHome = Get.put(ControllerHome());
  CategoryController categoryController = Get.put(CategoryController());
  ProcessController processController = Get.put(ProcessController());
  var selectedIndex = (-1).obs; // For category items
  var selectedButtonIndex = (-1).obs;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    controllerHome.fetchUserInfo();
    categoryController.fetchCategories();
    processController.fetchProcessInfo();
    // controllerHome.updateLastSeen();
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            // Implement your refresh logic here
            controllerHome.fetchUserInfo();
            categoryController.fetchCategories();
            processController.fetchProcessInfo();
          },
          child: Padding(
            padding:
            EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 10.0.sp),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          return CircleAvatar(
                            radius: 25.sp,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(controllerHome
                                .user.value ==
                                null
                                ? image_url
                                : "${AppEndPoint.userProfile}${controllerHome.user.value!.user.information.profile}"),
                          );
                        }),
                        SizedBox(width: 10.sp),
                        Obx(() {
                          return Text(
                            'Hi ${controllerHome.user.value == null ? "No User" : controllerHome.user.value!.user.information.name}!',
                            style: homeUserFontText,
                          );
                        }),
                      ],
                    ).marginSymmetric(
                      vertical: 5.sp,
                    ),
                    Row(
                      children: [
                        Text(
                          'Your Points:',
                          style: homePointsFontText,
                        ),
                        SizedBox(width: 10.sp),
                        Icon(
                          Icons.diamond_outlined,
                          color: Colors.purple,
                          size: 15.sp,
                        ),
                        SizedBox(width: 5.sp),
                        Obx(() {
                          return Text(
                              "${controllerHome.user.value == null ? "0" : controllerHome.user.value!.user.information.points}");
                        })
                      ],
                    ).marginSymmetric(
                      vertical: 5.sp,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          ScreenCompletedProject(),
                          transition: Transition.leftToRight,
                        );
                      },
                      child: Container(
                        // height: 80.sp,
                        width: Get.width,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(.1),
                                offset: Offset(0, 3),
                                blurStyle: BlurStyle.outer,
                              )
                            ]),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/task.svg",
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Completed Tasks",
                                        style: categoryFontText.copyWith(
                                            color: Colors.white),
                                      ),
                                      Spacer(),
                                      Obx(() {
                                        return RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text:
                                                "${processController.process.value == null ? "0" : processController.process.value!.data.process.completedPoints}/",
                                                style: categoryFontText.copyWith(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text:
                                                "${processController.process.value == null ? "0" : processController.process.value!.data.process.totalPoints}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ]));
                                      }),
                                    ],
                                  ),
                                  Obx(() {
                                    return Text(
                                      "${processController.process.value == null ? "0" : processController.process.value!.data.process.completionPercentage.round()}%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.sp,
                                      ),
                                    );
                                  }).marginSymmetric(
                                    vertical: 3.sp,
                                  ),
                                  Obx(() {
                                    return SizedBox(
                                      width: Get.width * .7,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Color(0xFFB4B4B4),
                                        color: Colors.green,
                                        minHeight: 8.h,
                                        borderRadius:
                                        BorderRadius.circular(30.r),
                                        value:
                                        processController.process.value ==
                                            null
                                            ? 0.0
                                            : processController
                                            .process
                                            .value!
                                            .data
                                            .process
                                            .completionPercentage /
                                            100,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ).marginSymmetric(
                          horizontal: 15.sp,
                        ),
                      ),
                    ).marginSymmetric(
                      vertical: 5.sp,
                    ),
                    Obx(() {
                      return (categoryController.isLoading.value)
                          ? Center(child: CircularProgressIndicator())
                          : categoryController.categories.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        categoryController.categories.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder:
                            (BuildContext context, int index) {
                          var category =
                          categoryController.categories[index];
                          return GestureDetector(
                            onTap: () {
                              selectedIndex.value = index;
                              selectedButtonIndex.value = -1;
                              Get.to(ScreenServices(
                                category: category,
                              ));
                            },
                            child: Obx(() {
                              return ItemCategory(
                                category: category,
                                isSelected:
                                selectedIndex.value == index,
                              );
                            }),
                          );
                        },
                      )
                          : Center(child: Text("No Category added yet"))
                          .marginSymmetric(vertical: 20.h);
                    }),
                    InkWell(
                      onTap: () {
                        selectedIndex.value = -1;
                        selectedButtonIndex.value =
                        0; // Update the selected button index

                        Get.to(
                          ScreenAskScorpio(),
                          transition: Transition.leftToRight,
                        );
                      },
                      child: Obx(() {
                        return CustomContainer(
                          text: "Ask Lex",
                          imagePath: "assets/icons/ask_scorpio.png",
                          isSelected: selectedButtonIndex == 0,
                        );
                      }),
                    ).marginSymmetric(
                      vertical: 5.sp,
                    ),
                    InkWell(
                      onTap: () async {
                        selectedIndex.value = -1;
                        selectedButtonIndex.value = 1;
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.setBool('first_time', false);
                        controllerHome.currentIndex.value = 2;
                      },
                      child: Obx(() {
                        return CustomContainer(
                          text: "Community",
                          imagePath: "assets/icons/community_icon.png",
                          isSelected: selectedButtonIndex == 1,
                        );
                      }).marginSymmetric(
                        vertical: 5.sp,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedIndex.value = -1;
                        selectedButtonIndex.value = 2;
                        Get.to(
                          ScreenLeaderboard(),
                          transition: Transition.leftToRight,
                        );
                      },
                      child: Obx(() {
                        return CustomContainer(
                          text: "Leaderboard",
                          imagePath: "assets/icons/leaderboard_icon.png",
                          isSelected: selectedButtonIndex == 2,
                        );
                      }),
                    ).marginSymmetric(
                      vertical: 5.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(() => controllerHome.user.value == null
          ? SizedBox()
          : controllerHome.user.value!.user.information.usertype == "1"
          ? FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: buttonColor,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          _showBottomSheet(context);
        },
      )
          : SizedBox()),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: Get.height * .45,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Get.back();
                  Get.to(ScreenCreateGroup());
                },
                child: Container(
                  height: 50,
                  width: Get.width * .4,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Text(
                      "New Group",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              GestureDetector(
                onTap: () {
                  Get.back(result: true);
                },
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
