import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final bool hasNotification;
  final bool hasRequestNotification;
  final bool hasChatNotification;
  final Function(int) onItemTapped;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;

  // final Color?iconColor;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.hasChatNotification,
    required this.hasRequestNotification,
    required this.hasNotification,
    required this.onItemTapped,
    this.selectedColor,
    // this.iconColor = Colors.white,
    this.unselectedColor,
    this.backgroundColor,
  });

  Widget _buildBottomNavigationItem({
    required String icon,
    required int index,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/icons/$icon.svg",
                color: currentIndex == index ? selectedColor : unselectedColor,
              )),
          if (hasNotification)
            Positioned(
              top: 4.5.sp,
              right: 8.sp,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: MediaQuery.sizeOf(context).height * .075.sp,
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomNavigationItem(
            icon: "home",
            index: 0,
          ),
          _buildBottomNavigationItem(
            icon: "notification",
            index: 1,
            hasNotification: hasNotification,
          ),
          _buildBottomNavigationItem(
            icon: "community",
            index: 2,
          ),
          _buildBottomNavigationItem(
            icon: "svg_stat",
            hasNotification: hasChatNotification,
            index: 3,
          ),
          _buildBottomNavigationItem(
              icon: "svg_profile",
              index: 4,
              hasNotification: hasRequestNotification),
        ],
      ),
    );
  }
}
