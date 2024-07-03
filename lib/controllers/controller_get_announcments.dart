import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/createAnnouncementModel.dart';
import '../models/unseen_announcement.dart';

class AnnouncementGetController extends GetxController {
  int groupId;
  var isLoading = false.obs;
  var announcements = <Announcement>[].obs;
  var unSeenAnnouncements = <UnSeenAnnouncement>[].obs;

  AnnouncementGetController({required this.groupId});

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements(groupId);
    fetchUnSeenAnnouncements(groupId);
  }

  Future<void> fetchAnnouncements(int group_id) async {
    String? token = await LoginAPIService.getToken();

    isLoading(true);
    try {
      log('Fetching announcements with token: $token');
      final response = await http.get(
        Uri.parse(
            'https://skorpio.codergize.com/api/get-announcements?group_id=$group_id'),
        // Replace with your API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log('JSON response: $jsonResponse');

        final announcementModel = AnnouncementModel.fromJson(jsonResponse);
        announcements.assignAll(announcementModel.announcements);
      } else {
        log('Failed to load announcements. Status code: ${response.statusCode}');
        throw Exception('Failed to load announcements');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Failed to fetch announcements: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUnSeenAnnouncements(int group_id) async {
    String? token = await LoginAPIService.getToken();

    isLoading(true);
    try {
      log('Fetching unseen announcements with token: $token');
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-unseen-announcement'),
        // Replace with your API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'group_id': group_id}),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonResponse = jsonDecode(response.body);
        log('JSON response: $jsonResponse');

        final unSeenAnnouncementModel =
            UnSeenAnnouncementModel.fromJson(jsonResponse);
        unSeenAnnouncements.assignAll(unSeenAnnouncementModel.announcements);
      } else {
        unSeenAnnouncements.clear();
        log('Failed to load unseen announcements. Status code: ${response.statusCode}');
        if (response.body.isNotEmpty) {
          log('Error response body: ${response.body}');
        }
        throw Exception('Failed to load unseen announcements');
      }
    } catch (e) {
      unSeenAnnouncements.clear();
      log('Exception: $e');
      throw Exception('Failed to fetch unseen announcements: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUnseenAnnouncements(int group_id) async {
    String? token = await LoginAPIService.getToken();

    try {
      log('Updating unseen announcements with token: $token');
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/update-announcement'),
        // Replace with your API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'group_id': group_id}),
      );

      log('Update response status: ${response.statusCode}');
      log('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        log('Unseen announcements updated successfully.');
        fetchUnSeenAnnouncements(group_id);
      } else {
        log('Failed to update unseen announcements. Status code: ${response.statusCode}');
        if (response.body.isNotEmpty) {
          log('Error response body: ${response.body}');
        }
        throw Exception('Failed to update unseen announcements');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Failed to update unseen announcements: $e');
    }
  }
}
