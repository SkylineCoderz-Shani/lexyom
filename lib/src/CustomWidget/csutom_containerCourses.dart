import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(.1),
              // spreadRadius: 5.r,
              offset: Offset(0, 3),
              // blurRadius:5.r,
              blurStyle: BlurStyle.outer,
            )
          ]),
      child: Row(
        children: [
          SizedBox(width: 15),
          CircleAvatar(
            child: Image.asset(
              imagePath,
              color: isSelected ? Colors.black : Colors.white,
            ),
            radius: 25,
            backgroundColor: isSelected ? buttonColor : Colors.black,
          ),
          SizedBox(width: 10),
          Text(text, style: categoryFontText.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  const CustomContainer({
    required this.text,
    required this.imagePath,
    required this.isSelected,
  });
}
