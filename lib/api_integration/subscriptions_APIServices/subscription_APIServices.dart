import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SubscriptionAPIServices {
  static const String baseUrl = 'https://your-api-url.com';

  static Future<void> subscribe(String package) async {
    final String apiUrl = '$baseUrl/subscribe';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {'package': package};

    try {
      final http.Response response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // Subscription successful
        Get.snackbar('Subscription', 'Subscription successful');
      } else {
        // Subscription failed
        Get.snackbar('Subscription', 'Unable to subscribe');
      }
    } catch (e) {
      // Handle any errors
      Get.snackbar('Subscription', 'Error subscribing: $e');
    }
  }
}
