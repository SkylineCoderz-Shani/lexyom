import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../constants/ApiEndPoint.dart';
import '../models/search_group.dart';

class ControllerSearchGroups extends GetxController {
  var isLoading = false.obs;
  var groupList = <Groups>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchGroupList(String value) async {
    log("Search value: $value");
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      var body = json.encode({"search": value});
      log("Request body: $body");

      final response = await http.post(
        Uri.parse(AppEndPoint.searchGroup),
        headers: {'Authorization': 'Bearer $token'},
        body: {"search": value},
      );

      log("Response status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        log("Decoded JSON data: $jsonData");

        final groupResponse = GroupResponse.fromJson(jsonData["data"]);
        log("Parsed GroupResponse: $groupResponse");

        log("Groups list before assigning: ${groupResponse.groups}");
        groupList.assignAll(groupResponse.groups);
        log("Groups list after assigning: ${groupList.value}");
      } else {
        groupList.value = [];
        log('Failed to load groups. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log("Error: ${e.toString()}");
      groupList.value = [];
    } finally {
      isLoading(false);
    }
  }
}
