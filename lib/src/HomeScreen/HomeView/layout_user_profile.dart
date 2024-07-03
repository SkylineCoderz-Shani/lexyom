import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../constants/colors.dart';
import '../../../controllers/home_controllers.dart';
import '../../CustomWidget/custom_LineChart.dart';
import '../../CustomWidget/custom_sliderWidget.dart';
import '../../CustomWidget/gfa_container.dart';
import '../../views/screen_EditProfile.dart';
import '../../views/screen_profile.dart';
import '../../views/screen_statistics.dart';


class LayoutUserProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ControllerHome controllerHome = Get.put(ControllerHome());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() {
              return Text(
                  'Hi ${controllerHome.user.value!.user.information.name}!',
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.bold));
            }),
            Text('Nice to meet you!',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),

          ],
        ),
        actions: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xFFE3FF00),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Icon(Icons.diamond, size: 18, color: Colors.purple,),
                    Obx(() {
                      return Text(
                          controllerHome.user.value!.user.information.points.toString());
                    })
                  ],
                ),
              )
          ).marginOnly(right: 10.w)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: ListView(
          children: [
            GFAContainer(
              color: Color(0xFF000000),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 130,
              MyBorderRadious: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(ScreenProfile());
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: NetworkImage(
                            controllerHome.user.value == null ? image_url : controllerHome
                                .user.value!.user.information.profile!
                        ),
                        // child: Image.asset('assets/images/avator2.png'),
                      ),
                      title: Obx(() {
                        return Text(controllerHome.user.value!.user.information.name, style: TextStyle(color: Color(
                            0xFFE3FF00),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),);
                      }),
                      subtitle: Row(
                        children: [
                          Image.asset('assets/images/trad.png', width: 20,),
                          SizedBox(width: 6),
                          Text('1 Course', style: TextStyle(
                              color: Colors.white, fontSize: 12),),
                          SizedBox(width: 6),
                          Text('#', style: TextStyle(
                              fontSize: 18, color: Color(0xFFE3FF00)),),
                          SizedBox(width: 5),
                          Text('12 Conreibuters', style: TextStyle(
                              color: Colors.white, fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.white, height: 3,),
                  GestureDetector(
                    onTap: () {
                      Get.to(ScreenEditProfile(user: controllerHome.user.value!,));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFE3FF00),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 4, bottom: 4),
                            child: Text(
                                'Edit your profile?'
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text('Statistic',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                .marginOnly(
              top: 10.sp,
              bottom: 8.sp,
            ),
            InkWell(
              onTap: () {
                Get.to(ScreenStatistics());
              },
              child: Container(
                height: Get.height * .4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Mar 19, 2024 - Apr 5, 2024", style: title2,),
                    SizedBox(
                      height: 40.h,
                    ),
                    LineChartSample2(),
                  ],
                ).marginAll(8.0),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ongoing Course',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Text('View all', style: TextStyle(color: Color(0xFFFF3131),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFFF3131)),),
              ],
            ).marginOnly(
              top: 30.sp,
              bottom: 8,
            ),
            GFAContainer(
              height: 80,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              MyBorderRadious: 20,
              color: Color(0xFF000000),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Image.asset("assets/images/courses_icon.png"),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Row(
                            children: [
                              Text("Trading", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),),
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "8/",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "12",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ]
                              )).marginOnly(
                                  left: 90.sp
                              )
                            ],
                          ),
                        ),
                        SliderWidget(
                          sliderWidth: Get.width * .6,
                          activeColor: buttonColor,
                          inactiveColor: Colors.grey,
                          minValue: 0.0,
                          maxValue: 100.0,
                          value: 50.0,
                          onChanged: (value) {
                            print('Slider value: $value');
                          },
                        ).marginOnly(
                          top: 30.sp,
                        ),
                      ],
                    ),
                  ],
                ).marginSymmetric(
                  horizontal: 10.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

