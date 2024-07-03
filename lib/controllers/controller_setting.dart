import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/settings.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;
  var setting = Rxn<Setting>();

  Future<void> fetchSettings() async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken(); // Assuming you have a method to get the token
      final response = await http.get(
        Uri.parse('https://skorpio.codergize.com/api/get-settings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        SettingsResponse settingsResponse = SettingsResponse.fromJson(jsonData);
        setting.value = settingsResponse.setting;
        log(setting.value!.nftWebsite.toString());
      } else {
        throw Exception('Failed to load settings. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
  @override
  void onInit() {
    fetchSettings();
    super.onInit();
  }
}
