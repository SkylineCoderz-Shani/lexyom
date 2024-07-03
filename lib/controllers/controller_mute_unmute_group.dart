import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_integration/authentication_APIServices/login_api_service.dart';

class GroupMuteController extends GetxController {
  var isLoading = false.obs;
  var isGroupMuted = false.obs;

  Future<void> toggleGroupMuteStatus(String groupId) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/mute-unmute-group'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'group_id': groupId}),
      );

      if (response.statusCode == 200) {
        log(response.body);
        final jsonData = jsonDecode(response.body);
        final status = jsonData['data']['status'];
        final message = jsonData['data']['msg'];
        isGroupMuted(status);
        Get.snackbar(
          colorText: Colors.black,
            backgroundColor: Colors.white,
            'Success', message);
      } else {
        throw Exception('Failed to toggle mute status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to toggle mute status: $e');
    } finally {
      isLoading(false);
    }
  }
}
