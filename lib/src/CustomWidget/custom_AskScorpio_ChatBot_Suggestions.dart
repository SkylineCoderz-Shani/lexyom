import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class CustomAskScorpioChatBot extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  bool isRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 12.h,vertical: 8.h),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: isRight==true?Alignment.centerRight:Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: "Arial",
                  fontWeight: FontWeight.w800,
                  color: buttonColor,
                ),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAskScorpioChatBot({
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.isRight,
  });
}
