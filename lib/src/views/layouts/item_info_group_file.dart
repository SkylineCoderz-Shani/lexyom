import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:open_app_file/open_app_file.dart';

import '../../../models/message.dart';

class ItemInfoGroupFile extends StatelessWidget {
Message message;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(
          horizontal: 4.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurStyle: BlurStyle.outer,
            spreadRadius: 1.0,
            blurRadius: 3.0,
            offset: Offset(1, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.file_copy_rounded,
            color: Colors.black,
            size: 30.h,
          ).marginOnly(right: 10.w),
          Expanded(
            child: Text(
              message.fileMessage!.fileName,
              style: TextStyle(
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  void downloadMedia(context, String url, String name) async {
    // Use the download link to download the file
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.refFromURL(url);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File localFile =
    File('${appDocDir.path}/$name'); // Change the file name as needed

    try {
      await ref.writeToFile(localFile);
      print('File downloaded and saved to: ${localFile.path}');
      await OpenAppFile.open(
        localFile.path,
      ).catchError((error) {
        log(error.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No App to open this file")));
      });
    } catch (e) {
      log(e.toString());
    }
  }

ItemInfoGroupFile({
    required this.message,
  });
}

