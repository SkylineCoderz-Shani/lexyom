import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class CustomSelectContainerSubscription extends StatelessWidget {
  final int index;
  final Color color;
  final bool isSelected;
  final Function onTap;
  final List<Widget> columns;

  CustomSelectContainerSubscription({
    required this.index,
    required this.color,
    this.isSelected = true,
    required this.onTap,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: Get.width,
        height: Get.height*.19,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected? buttonColor : Colors.grey.withOpacity(.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? buttonColor : Colors.transparent,
                border: !isSelected ? Border.all(color: Colors.grey, width: 2.0) : null,
              ),
              child: Icon(Icons.check, color: isSelected ? Colors.black : Colors.transparent),
            ).marginOnly(
              bottom: 40.sp,
            ),
            SizedBox(width: 10),
            Stack(
              children: columns,
            )
          ],
        ),
      ),
    );
  }
}

