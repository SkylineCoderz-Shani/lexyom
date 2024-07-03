import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../constants/fcm.dart';
import '../models/user.dart';

class ControllerHome extends GetxController {
  RxInt currentIndex = 0.obs;
  var user = Rxn<UserResponse>(); // Rxn is used to handle null values
  Future<void> updateToken() async {
    var token = (await FCM.generateToken()) ?? "";
    log(token);
    String? accessToken = await LoginAPIService.getToken();
    log(accessToken.toString());

    // API endpoint
    const String endpoint = "https://skorpio.codergize.com/api/update-device-token";

    // Create the payload
    Map<String, String> payload = {
      'device_token': token,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: payload,
      );
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body.toString());
        log('Token updated successfully');
      } else {
        log('Failed to update token: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating token: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
    updateToken();
  }

  Future<void> fetchUserInfo() async {
    try {
      String? accessToken = await LoginAPIService.getToken();
      int? id = await LoginAPIService.getUid();
      log(id.toString());


      final response = await http.post(Uri.parse(AppEndPoint.getUserInfo),
          headers: {
        'Authorization': 'Bearer $accessToken',
      },
        body: {
        "user_id":"${id}"
        }

      );
      if (response.statusCode == 200) {

        final data = json.decode(response.body);
        log(data.toString());

        user.value = UserResponse.fromJson(data);
        log(user.value.toString());
      } else {
        log(response.body.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
