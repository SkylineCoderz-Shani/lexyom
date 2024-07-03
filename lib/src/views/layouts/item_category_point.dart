import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/ApiEndPoint.dart';
import '../../../constants/colors.dart';
import '../../../models/category.dart';

class ItemCategoryPoint extends StatelessWidget {
Point point;
  @override
  Widget build(BuildContext context) {
    // log(message)
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ListTile(
        onTap: (){
          log(point.link);
          if (point.link!=null||point.link.isNotEmpty) {
            log(point.link);
            _launchUrl(point.link);
            log(point.link);
          }
        },
        title: Text(
          point.title,
          style: title4,
        ),
        subtitle: Text(
          point.text,
          style: subtitle5,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            "${AppEndPoint.categoryPointImageUrl}${point.img}"
          ),
        ),
      ),
    );
  }
Future<void> _launchUrl(String _url) async {
  if (_url.isEmpty || _url == null) {
    log('URL is empty or null');
    return;
  }

  final Uri uri = Uri.parse(_url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}
ItemCategoryPoint({
    required this.point,
  });
}
