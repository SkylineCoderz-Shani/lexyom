import 'dart:convert';
import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../models/user.dart'; // Import your User model

class UserController {
  var user = Rxn<UserResponse>(); // Rxn is used to handle null values
  RxBool isLoading=false.obs;
  Future<Map<String,dynamic>?> getUserInfo(int userId) async {
    String? accessToken = await LoginAPIService.getToken();

    final response = await http.post(Uri.parse(AppEndPoint.getUserInfo),headers: {
      'Authorization': 'Bearer $accessToken',
    },
        body: {
          "user_id":"${userId}"
        }

    );
    // log(response.body);

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {

      // final user = User.fromJson(responseData['user']);
      // log(user.toString());
      return responseData['user']["information"];
    } else {
      // Handle the error response
      print('Failed to get user information: ${response.statusCode}');
      return responseData;
    }
  }
  Future<void> getUserDetailInfo(int userId) async {
    String? accessToken = await LoginAPIService.getToken();
    isLoading.value=true;

    final response = await http.post(Uri.parse(AppEndPoint.getUserInfo),headers: {
      'Authorization': 'Bearer $accessToken',
    },
        body: {
          "user_id":"${userId}"
        }

    );
    log(response.body);

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      log(data.toString());

      user.value = UserResponse.fromJson(data);
      isLoading.value=false;
    } else {
      isLoading.value=false;

      // Handle the error response
      print('Failed to get user information: ${response.statusCode}');

    }
    isLoading.value=false;

  }
  Future<UserResponse?> getUserDetailRoomInfo(int userId) async {
    String? accessToken = await LoginAPIService.getToken();

    final response = await http.post(Uri.parse(AppEndPoint.getUserInfo),headers: {
      'Authorization': 'Bearer $accessToken',
    },
        body: {
          "user_id":"${userId}"
        }

    );
    log(response.body);

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      log(data.toString());

      var user = UserResponse.fromJson(data);
      return user;
    } else {
      return null;

      // Handle the error response
      print('Failed to get user information: ${response.statusCode}');

    }

  }
}
