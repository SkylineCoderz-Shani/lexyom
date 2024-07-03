import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../constants/chat_constant.dart';
import '../../constants/firebase_utils.dart';
import '../../models/chat_group.dart';
import '../../src/HomeScreen/home_screen.dart';
import '../authentication_APIServices/login_api_service.dart';

class GroupService {
  Future<void> createGroup({
    required File? imgFile,
    required String title,
    required String description,
    required bool isPrivate,
    required int timeSensitive,
    required int groupId,
    required int userId,
    required String isAdmin,
    required String joined,
  }) async {
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null) {
        print('Token not found. Please log in.'); // Debug statement
        Get.snackbar(
          'Error',
          'Token not found. Please log in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String apiUrl = 'https://skorpio.codergize.com/api/create-group';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      if (imgFile != null) {
        request.files.add(await http.MultipartFile.fromPath('img', imgFile.path));
      }
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['is_private'] = isPrivate ? '1' : '0';
      request.fields['time_sensitive'] = timeSensitive.toString();
      request.fields['group_id'] = groupId.toString();
      request.fields['user_id'] = userId.toString();
      request.fields['is_admin'] = isAdmin;
      request.fields['joined'] = joined;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        // log('Group created successfully: ${responseData.body}');
        List<String> memberIds = [FirebaseUtils.myId]; // Add the current user to the member list
        final jsonResponse = jsonDecode(responseData.body);
        log(jsonResponse['data']['groups']["id"].toString());
         var groupId=jsonResponse['data']['groups']["id"].toString();
        // Parse the JSON response using your models
        // final group = Groups.fromJson(jsonResponse['data']['groups']);
        // log(group.id.toString());


        ChatGroup chatGroup = ChatGroup(id: groupId.toString(), eventId: groupId.toString(),
            memberIds: memberIds,
          messageCounters: {for (var memberId in memberIds) memberId: 0}, // Initialize counters
        );

        await chatGroupRef.child(groupId.toString()).set(chatGroup.toMap()).then((value) {
          print("Success add message Group");
          // Get.off(ScreenGroupChat(group: group,));
          Get.offAll(HomeScreen());
        }).catchError((error) {
          print(error);

        });
      } else {
        final responseData = await http.Response.fromStream(response);
        print('Failed to create group: ${responseData.body}');
      }
    } catch (error) {
      print('Error creating group: $error');
    }
  }
}
