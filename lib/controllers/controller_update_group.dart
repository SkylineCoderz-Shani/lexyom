import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';

class UpdateGroupController extends GetxController {
  Future<void> updateGroup({
    required int groupId,
    File? imgFile,
    required String title,
    required String description,
    required bool isPrivate,
    required int timeSensitive,
  }) async {
    log('Time Sensitive: $timeSensitive');
    log('Group ID: $groupId');
    log('Title: $title');
    log('Description: $description');
    log('Time Sensitive: $timeSensitive');
    log('Is Private: $isPrivate');
    log('is Private: $isPrivate');
    log('Imag path: $imgFile');
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Token not found. Please log in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String apiUrl = 'https://skorpio.codergize.com/api/update-group';
      String? base64Image;
      if (imgFile != null) {
        List<int> imageBytes = await imgFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      Map<String, dynamic> data = {
        'groupId': groupId,
        'title': title,
        'description': description,
        'is_private': isPrivate ? '1' : '0',
        'time_sensitive': timeSensitive,
        'img': base64Image,
      };

      log('Request Body: ${jsonEncode(data)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log('Response JSON: $jsonResponse');
        Get.snackbar(
          'Success',
          'Group updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final jsonResponse = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          'Failed to update group: ${jsonResponse['message'] ?? response.body}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error updating group: $error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
