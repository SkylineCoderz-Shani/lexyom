import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/models/category.dart';

import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';

class ItemCategory extends StatelessWidget {
  Category category;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(.6),
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
            child: Image.network(
              "${AppEndPoint.categoryImageUrl}${category.icon}",
              color: isSelected ? Colors.black : Colors.white,
            ),
            radius: 25,
            backgroundColor: isSelected ? buttonColor : Colors.transparent,
          ),
          SizedBox(width: 10),
          Text(
            category.name,
            style: categoryFontText.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  ItemCategory({
    required this.category,
    required this.isSelected,
  });
}
