import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_integration/authentication_APIServices/login_api_service.dart';
class AnnouncementController extends GetxController {
  int groupId;
  var isLoading = false.obs;
  TextEditingController titleController=TextEditingController();

  AnnouncementController({
    required this.groupId,
  });

  Future<void> createAnnouncement() async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Failed to fetch token');
      }

      var body = json.encode({
        "title": titleController.text.trim(),
        "group_id": groupId,
      });
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/create-announcement'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: body,
      );

      log("Create Announcement Response: ${response.body}");

      if (response.statusCode == 200) {
        log(response.body.toString());
       } else {
        final jsonData = jsonDecode(response.body);
        final errorMessage = jsonData['msg'] ?? 'Failed to create announcement. Status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Failed to create announcement: $e');
    } finally {
      isLoading(false);
    }
  }
}