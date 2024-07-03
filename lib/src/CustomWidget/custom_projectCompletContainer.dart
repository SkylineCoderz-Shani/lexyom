import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSocialMediaContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;

  CustomSocialMediaContainer({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context)/.size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 5.r,
              spreadRadius: 5.r,
              // offset: Offset(1, 1),
            )
          ]
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Text(
          subtitle,
        ),
        leading: CircleAvatar(
          backgroundColor: iconBackgroundColor,
          child: Icon(icon, color: Colors.white),
        ),
      ).marginSymmetric(vertical: 6.sp),
    );
  }
}
