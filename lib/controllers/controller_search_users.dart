import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../api_integration/leaderboard_APIServices/model/leaderborad_Model.dart';
import '../models/search_user.dart';  // Ensure this import is necessary

class ControllerSearchUsers extends GetxController {
  var isLoading = false.obs;
  var userList = <SearchUser>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUserList(String value) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      var body = json.encode({"search": value});

      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/search-user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userResponse = UserResponse.fromJson(jsonData);
        userList.assignAll(userResponse.users);
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
