import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../controllers/controller_category.dart';
import '../../models/category.dart';
import '../CustomWidget/custom_Container_ServicesDetails.dart';
import '../HomeScreen/home_screen.dart';
import 'layouts/item_category_point.dart';

class ScreenServices extends StatelessWidget {
  Category category;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          Get.put(CategoryController()).fetchCategories();
          // Implement your refresh logic here

        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.description,
              style: subtitle2,
            ).marginSymmetric(vertical: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: category.points.length,
                itemBuilder: (BuildContext context, int index) {
                  var point = category.points[index];
                  log(point.link.toString());
                  return ItemCategoryPoint(point: point);
                },
              ),
            )
          ],
        ).marginSymmetric(horizontal: 20.w),
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


  ScreenServices({
    required this.category,
  });
}
