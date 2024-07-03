import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
MaterialColor appPrimaryColor = MaterialColor(
  0xFFE3FF00,
  const <int, Color>{
    50: const Color(0xff39D27F),
    100: const Color(0xff39D27F),
    200: const Color(0xff39D27F),
    300: const Color(0xff39D27F),
    400: const Color(0xff39D27F),
    500: const Color(0xff39D27F),
    600: const Color(0xff39D27F),
    700: const Color(0xff39D27F),
    800: const Color(0xff39D27F),
    900: const Color(0xff39D27F),
  },
);

Color appColor = Colors.red;
Color backgroundColor = Colors.white;
Color buttonColor = Color(0xff39D27F);
Color blackButtonTextColor = Color(0xff39D27F);
Color textColor = Colors.black;

TextStyle categoryFontText = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w400,
  fontFamily: "Inter",
);

TextStyle profileFontText = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(14),
  fontWeight: FontWeight.w400,
  fontFamily: "Arial",
);

TextStyle title1 = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(18),
  fontWeight: FontWeight.w400,
  fontFamily: "Inter",
);

TextStyle communityFontTitle = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w600,
  fontFamily: "Arial",
);

TextStyle subscriptionTitleFont = TextStyle(
  color: Colors.grey,
  fontSize: ScreenUtil().setSp(14),
  fontWeight: FontWeight.w400,
  fontFamily: "Arial",
);

TextStyle subscriptionSubtitleFont = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(26),
  fontWeight: FontWeight.w400,
  fontFamily: "Arial",
);

TextStyle title4 = TextStyle(
  color: Colors.white,
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w600,
  fontFamily: "Inter",
);

TextStyle title5 = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(18),
  fontWeight: FontWeight.w600,
);

TextStyle homeUserFontText = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w600,
  fontFamily: "Arial",
);

TextStyle homePointsFontText = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(16),
  fontWeight: FontWeight.w400,
  fontFamily: "Arial",
);

TextStyle title2 = TextStyle(
  color: Colors.white,
  fontSize: 12.sp,
  fontWeight: FontWeight.w500,
  fontFamily: "Arial",
);

TextStyle title3 = TextStyle(
  color: Colors.black,
  fontSize: ScreenUtil().setSp(26),
  fontWeight: FontWeight.w600,
  fontFamily: "Arial",
);

TextStyle subtitle1 = TextStyle(
  color: Colors.grey.shade500,
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(10),
  fontFamily: "Inter",
);

TextStyle subtitle2 = TextStyle(
  color: Colors.grey.shade500,
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(12),
  fontFamily: "Arial",
);

TextStyle subtitle5 = TextStyle(
  color: Color(0xff808080),
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(10),
  fontFamily: "Arial",
);

TextStyle subtitle6 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: ScreenUtil().setSp(10),
  fontFamily: "Arial",
);

TextStyle skorpioChatGpt1stScrFontTitle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: ScreenUtil().setSp(24),
  fontFamily: "Arial",
);

TextStyle subtitle3 = TextStyle(
  fontSize: ScreenUtil().setSp(12),
  fontWeight: FontWeight.w600,
  fontFamily: "Arial",
);

TextStyle adminTitle4 = TextStyle(
  fontSize: ScreenUtil().setSp(18),
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontFamily: "Arial",
);

Decoration roundedDec = BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: appColor,
);

BoxShadow myShadow = BoxShadow(color: Colors.red);
List<BoxShadow> appBoxShadow = [
  BoxShadow(blurRadius: 1, color: Colors.grey.shade300),
];
String image_url =
    "https://phito.be/wp-content/uploads/2020/01/placeholder.png";