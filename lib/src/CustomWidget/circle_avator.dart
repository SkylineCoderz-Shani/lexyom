import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCircleAvator extends StatelessWidget {
  MyCircleAvator({super.key,this.redius1,this.redius2,this.backgroundColor,this.myWidget});
  double? redius1;
  double? redius2;
  Color? backgroundColor;
  Widget? myWidget;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: redius1!,
      backgroundColor: Color(0xFFE3FF00),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(120),
        child: CircleAvatar(
          radius: redius2!,
          backgroundColor: backgroundColor!,
          child: myWidget!,
        ),
      ),
    );
  }
}
