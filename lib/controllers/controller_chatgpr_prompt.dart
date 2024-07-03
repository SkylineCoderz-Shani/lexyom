import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_integration/authentication_APIServices/login_api_service.dart';

class ControllerChatGPTPrompt extends GetxController {
  var isLoading = false.obs;
  var chatResponse = ''.obs;

  Future<void> getChatGPTPrompt(String message) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-chatgpt-prompt'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({'prompt': message}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        chatResponse.value = jsonData['data']['ChatPrompt'] ?? 'No response from ChatGPT';
      } else {
        throw Exception('Failed to load response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
