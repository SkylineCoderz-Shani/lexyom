import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../CustomWidget/custom_LineChart.dart';

class ScreenStatistics extends StatelessWidget {
  const ScreenStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Statistics", style: title1,),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.sp,
          ),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text("OVERVIEW", style: title1,),
             Text("Mar 29, 2024 - Apr 5, 2024", style: TextStyle(
               fontWeight: FontWeight.w400,
               fontSize: 12.sp,
               color: Colors.grey,
             ),),
           ],
         ).marginSymmetric(
           horizontal: 25.sp,
           vertical: 10.sp,
         ),
          Container(
            height: Get.height*.22,
            width: Get.width*.9,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20)
            ),
            child:  Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("7.4K", style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text("Followers", style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                      ],
                    ),
                    Text("-49 (0.65%)", style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("66.73%", style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text("Enabled Notifications", style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1.4K", style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text("Views Per Post", style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                      ],
                    ),
                    Text("-49 (0.65%)", style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("0", style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text("Shares Per Post", style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                      ],
                    ),
                  ],
                ).marginSymmetric(
                  vertical: 10.sp,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("16", style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text("Reactions Per Post", style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                      ],
                    ),
                    Text("+49 (0.65%)", style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),),
                  ],
                ),
              ],
            ).marginSymmetric(
              horizontal: 20.sp,
              vertical: 15.sp,
            ),
          ),
          SizedBox(
            height: 30.sp,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child:
            Text("GROWTH", style: title1,),
          ).marginSymmetric(
            horizontal: 25.sp,
            vertical: 10.sp,
          ),
          Container(
            height: Get.height*.4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text("Mar 19, 2024 - Apr 5, 2024",style: title2,),
                SizedBox(
                  height: 40.h,
                ),
                LineChartSample2(),
              ],
            ).marginAll(8.0),
          ).marginSymmetric(
            horizontal: 20.sp,
          )
        ],
      ),
    );
  }
}
