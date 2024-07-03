import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../CustomWidget/custom_button.dart';
import '../HomeScreen/HomeView/layout_community_groups.dart';

class ScreenCommunity extends StatefulWidget {
  const ScreenCommunity({Key? key});

  @override
  State<ScreenCommunity> createState() => _ScreenCommunityState();
}

class _ScreenCommunityState extends State<ScreenCommunity> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstRun(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final isFirstRun = snapshot.data ?? true;
          if (isFirstRun) {
            return _buildFirstRunScreen();
          } else {
            return LayoutCommunityGroups();
          }
        }
      },
    );
  }

  Future<bool> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstRun') ?? true;
  }

  Widget _buildFirstRunScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/background_image.png",
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: Get.width,
              height: Get.height * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 6,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 40.sp),
                  Text(
                    "Enjoy the new experience of\ncommunicating.",
                    textAlign: TextAlign.center,
                    style: communityFontTitle,
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    "Connecting with people just got easier",
                    textAlign: TextAlign.center,
                    style: subtitle1,
                  ),
                  Spacer(),
                  CustomButton(
                    text: "Get Started",
                    buttonColor: buttonColor,
                    textColor: Colors.black,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirstRun', false);
                      await _checkFirstRun();
                      setState(() {});

                      // Get.to(ScreenCommunityGroups());
                    },
                  ).marginSymmetric(
                    horizontal: 20.sp,
                  ),
                ],
              ).marginSymmetric(
                vertical: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
