// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_utils/get_utils.dart';
// import '../../constants/colors.dart';
// import '../CustomWidget/custom_switchButton.dart';
// import '../CustomWidget/my_container.dart';
// import '../views/screen_subscriptionAdmin.dart';
//
// class SetPersonalization extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//
//   bool isSwitch = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MyContainer(),
//             Column(
//               children: [
//                 SizedBox(height: 10.sp,),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                       'Set Personalization',
//                       style: title1,
//                     ),
//                 ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'This would help the AI to know you better',
//                       style: subtitle1,
//                     ),
//                   ).marginOnly(
//                     bottom: 10.sp,
//                   ),
//                 Container(
//                   alignment: Alignment.topLeft,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         blurStyle: BlurStyle.outer,
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 8.0,
//                       )
//                     ],
//                   ),
//                   child: TextField(
//                     maxLines: 4,
//                     maxLength: 500,
//                     decoration: InputDecoration(
//                       counterStyle: TextStyle(
//                         fontSize: 13.0, // Customize the font size
//                         color: Colors.grey, // Customize the text color
//                         // Add padding to the counter text
//                         height: 7.0, // Adjust the line height
//                       ),
//                       hintText: 'Tell me more about you',
//                       hintStyle: TextStyle(color: Colors.grey.shade500),
//                       border: OutlineInputBorder(
//                           borderSide: BorderSide.none
//                       ),
//                     ),
//                   ),
//                 ).marginSymmetric(
//                   vertical: 10.sp,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Enable for new chats',style: TextStyle(fontWeight: FontWeight.w600),),
//                     CustomSwitch(),
//                   ],
//                 ).marginSymmetric(vertical: 12.sp,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CupertinoButton(
//                         color: Color(0xFF000000),
//                         padding: EdgeInsets.only(left: 55,right: 55),
//                         child: Text('Skip',style: TextStyle(color: Color(0xFFE3FF00),fontWeight: FontWeight.bold ),),
//                         onPressed: (){
//                         }
//                     ),
//                     CupertinoButton(
//                         color: Color(0xFFE3FF00),
//                         padding: EdgeInsets.only(left: 55,right: 55),
//                         child: Text('Save',style: TextStyle(color: Color(0xFF000000)),),
//                         onPressed: (){
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => ScreenSubscription()),
//                           );
//                         }
//                     )
//                   ],
//                 ).marginSymmetric(vertical: 26.sp,
//                 ),
//               ],
//             ).marginSymmetric(
//               horizontal: 15.sp,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
