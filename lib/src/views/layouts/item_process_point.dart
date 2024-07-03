import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../../controllers/controller_process.dart';
import '../../../models/process.dart';

class ItemProcessPoint extends StatelessWidget {
Point point;
RxBool isLoading=false.obs;
  @override
  Widget build(BuildContext context) {
    ProcessController processController=Get.put(ProcessController());
    return  Container(
      // height: MediaQuery.of(context)/.size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: Offset(0, 3),
              blurStyle: BlurStyle.outer,
            )
          ]),
      child: ListTile(
        onTap: () async {
          log(point.link.toString());

          if (point.link!=null) {
            _launchUrl(point.link!);
          }
          },
        title: Text(
          point.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Text(
          point.description,
        ),
        leading:Obx(() => (isLoading.value)?CircularProgressIndicator(): CircleAvatar(
          backgroundColor: point.completed=="0"?Colors.grey:Colors.green,
          child: IconButton(icon:Icon(Icons.check, color: Colors.white),onPressed: () async {

            if(point.completed=="0") {
              isLoading.value = true;
              await processController.completeProcess(point.id);
              isLoading.value = false;
            }
          },),
        ),)
      ).marginSymmetric(vertical: 6.sp),
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


ItemProcessPoint({
    required this.point,
  });
}
