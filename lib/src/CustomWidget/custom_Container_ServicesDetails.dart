import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomMarketDataContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;


  const CustomMarketDataContainer({
    required this.title,
    required this.subtitle,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      // height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Text(
          title,
          style: title4,
        ),
        subtitle: Text(
          subtitle,
          style: subtitle5,
        ),
        leading: leading,
      ),
    );
  }
}
