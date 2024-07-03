import 'package:flutter/material.dart';

class GFAContainer extends StatelessWidget {
  GFAContainer({super.key,this.child,this.height,this.width,this.MyBorderRadious,this.myPadding,this.color});
  Widget? child;
  double? height;
  double? width;
  double? MyBorderRadious;
  Color?  color = Colors.white;
  EdgeInsetsGeometry? myPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: myPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyBorderRadious!),
        color: color!,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 4,),
          ),
        ],
      ),
      child: child,
    );
  }
}
