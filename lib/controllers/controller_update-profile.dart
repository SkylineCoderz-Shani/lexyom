import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/user.dart';
import 'home_controllers.dart';

class ControllerUpdateProfile {
  Future<Map<String, dynamic>> updateUserProfile({
    required String profile,
    required String phone,
    required String gender,
    required String location,
    required String dob,
    required String occupation,
    required String company,
    required String hobbies,
    required String brand,
    required String instagram,
    required String facebook,
    required String tiktok,
    required String linkedin,
    required String twitter,
    required String threads,
    required String warpcast,
    required String youtube,
    File? profileImage,
  }) async {
    isLoading.value = true;

    String? token = await LoginAPIService.getToken();
    var uri = Uri.parse('https://skorpio.codergize.com/api/update-profile');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['profile'] = profile;
    request.fields['phone'] = phone;
    request.fields['gender'] = gender;
    request.fields['location'] = location;
    request.fields['dob'] = dob;
    request.fields['occupation'] = occupation;
    request.fields['company'] = company;
    request.fields['hobbies'] = hobbies;
    request.fields['brand'] = brand;
    request.fields['instagram'] = instagram;
    request.fields['facebook'] = facebook;
    request.fields['tiktok'] = tiktok;
    request.fields['linkedin'] = linkedin;
    request.fields['twitter'] = twitter;
    request.fields['threads'] = threads;
    request.fields['warpcast'] = warpcast;
    request.fields['youtube'] = youtube;

    if (profileImage != null) {
      var mimeTypeData = lookupMimeType(profileImage.path)!.split('/');
      var imageFile = await http.MultipartFile.fromPath(
        'profile',
        profileImage.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      );
      request.files.add(imageFile);
    }
    var response = await request.send();
    log(response.toString());
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      isLoading.value = false;
      return {'status': true, 'message': 'Profile updated successfully'};

    } else {
      isLoading.value = false;
      log(response.statusCode.toString());
      print(token);
      return {'status': false, 'message': 'Failed to update profile'};
    }

  }



  Future<void> updateProfileSection( Map<String,dynamic> data) async {
    isLoading.value = true;
    String? token = await LoginAPIService.getToken();

    final response = await http.post(
      Uri.parse('https://skorpio.codergize.com/api/update-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        // 'Content-Type': 'application/json',
      },
      body: data,
    );
log(response.body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      log(responseData.toString());
      if (responseData["status"]) {
        Get.snackbar(
          'Success',
          ' updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.find<ControllerHome>().fetchUserInfo();
      } else {
        Get.snackbar(
          'Alert',
          responseData['msg'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Failed to update : ${response.statusCode}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }
  RxBool isLoading=false.obs;

}
