import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/non_member.dart';
import '../models/search_user.dart';
import 'package:http/http.dart' as http;

class ControllerSearchSubscriber extends GetxController {
  var isLoading = false.obs;
  var userList = <NonGroupMember>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUserList(int value) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      var body = json.encode({"group_id": value});

      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-non-group-member'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // log('Response status code: ${response.statusCode}');
      // log('Response body noto: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userResponse = NonGroupMembersResponse.fromJson(jsonData);
        userList.assignAll(userResponse.nonGroupMembers);
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}