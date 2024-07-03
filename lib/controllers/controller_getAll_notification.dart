import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/get_all_Notifications_Model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notificationList = <Notification>[].obs;
  var hasUnseenNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationList();
  }

  Future<void> fetchNotificationList() async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse('https://skorpio.codergize.com/api/get-notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );
      log(response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final notificationResponse = NotificationResponse.fromJson(jsonData);
        notificationList.assignAll(notificationResponse.notifications);

        // Check for unseen notifications
        hasUnseenNotifications(notificationResponse.notifications
            .any((notification) => notification.seen == 0));
      } else {
        throw Exception(
            'Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Get.snackbar('Error', 'Failed to load notifications: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateNotifications() async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse('https://skorpio.codergize.com/api/update-notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );
      log(response.body);

      if (response.statusCode == 200) {
        // Optionally, you can refetch the notification list to get the updated statuses
        await fetchNotificationList();
        // Get.snackbar('Success', 'Notifications updated successfully.');
      } else {
        throw Exception(
            'Failed to update notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Get.snackbar('Error', 'Failed to update notifications: $e');
    } finally {
      isLoading(false);
    }
  }
}
