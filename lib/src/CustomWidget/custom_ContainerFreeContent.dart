import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomContainerFreeContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;


  const CustomContainerFreeContent({
    required this.title,
    required this.subtitle,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.10,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.8),
            blurStyle: BlurStyle.outer,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(1, 3),
          )
        ]
      ),
      child: ListTile(
        title: Text(
          title,
          style: title5,
        ),
        subtitle: Text(
          subtitle,
          style: subtitle6,
        ),
        leading: leading,
      ),
    );
  }
}
