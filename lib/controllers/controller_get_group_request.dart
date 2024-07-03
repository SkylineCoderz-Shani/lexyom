import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/group_request.dart';

class GroupRequestController extends GetxController {
  var isLoading = false.obs;
  int groupId;

  @override
  void onInit() {
    fetchRequestGroupMembers(groupId);
    super.onInit();
  }

  var groupRequests = <GroupRequest>[].obs;

  Future<void> fetchRequestGroupMembers(int groupId) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-group-request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({"group_id": groupId}),
      );

      final jsonData = jsonDecode(response.body);
      log(jsonData.toString());
      final groupRequestResponse = GroupRequestResponse.fromJson(jsonData);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Response body: ${response.body}');
        final groupRequestResponse = GroupRequestResponse.fromJson(jsonData);

        groupRequests.assignAll(groupRequestResponse.groupRequests);
      } else {
        print('Failed to load group requests. Status code: ${response.body}');
        throw Exception(
            'Failed to load group requests. Status code: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load group requests: $e');
    } finally {
      isLoading(false);
    }
  }

  GroupRequestController({
    required this.groupId,
  });
}
