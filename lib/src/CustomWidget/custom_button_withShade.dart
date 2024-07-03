import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../constants/colors.dart';

class CustomButtonShade extends StatelessWidget {
  String text;
  double? fontSize;
  Callback? onTap;
  bool? isRound;
  double? width;
  double? height;
  EdgeInsetsGeometry? margin;
  Color? buttonColor;
  Color? textColor;
  bool? loading;
  String? leadingIconAsset; // Updated property to accept asset path

  CustomButtonShade({
    required this.text,
    this.fontSize,
    this.onTap,
    this.isRound,
    this.width,
    this.height,
    this.margin,
    this.buttonColor,
    this.textColor,
    this.loading = false,
    this.leadingIconAsset, // Updated constructor to accept asset path
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 58.sp,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2),
          //     offset: Offset(0, 3),
          //     blurRadius: 1,
          //     spreadRadius: 2,
          //     blurStyle: BlurStyle.outer,
          //   )
          // ],
          borderRadius: isRound == true
              ? BorderRadius.circular(30)
              : BorderRadius.circular(10),
          color: buttonColor ?? backgroundColor,
        ),
        child: loading == true
            ? CircularProgressIndicator(
                color: Colors.black,
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIconAsset != null)
                      Image.asset(
                        leadingIconAsset!,
                        height: 24,
                        width: 24,
                      ),
                    SizedBox(width: leadingIconAsset != null ? 8 : 0),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize ?? 16,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w700,
                        color: textColor ?? Colors.black,
                      ),
                    ),
                  ],
                ).marginOnly(
                  top: 10.sp,
                ),
              ),
      ),
    );
  }
}
