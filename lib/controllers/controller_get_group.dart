import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../constants/firebase_utils.dart';

class ControllerGetGroup extends GetxController {
  var isLoading = false.obs;
  var groupList = <Groups>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupList();
  }

  Future<void> fetchGroupList() async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      final response = await http.get(
        Uri.parse('https://skorpio.codergize.com/api/get-group'),
        headers: {'Authorization': 'Bearer $token'},
      );
      // log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        log(jsonData['data']['groups'].toString());

        // Deserialize the JSON data
        GroupResponse groupResponse = GroupResponse.fromJson(jsonData['data']);
        List<Groups> sortedGroups = groupResponse.groups;

        // Update the group list
        groupList.assignAll(sortedGroups);
        sortGroupList(FirebaseUtils.myIntId);
      } else {
        log('Failed to load groups');
      }
    } catch (e) {
      log('Error fetching group list: $e');
    } finally {
      isLoading(false);
    }
  }

  String getStatus(Groups group, int userId) {
    for (var member in group.members) {
      if (member.userId == userId) {
        if (member.canJoin == 0) {
          return "Requested";
        } else {
          return "Joined";
        }
      }
    }
    return "Join";
  }

  void sortGroupList(int userId) {
    groupList.sort((a, b) {
      // Check user status in group A
      String statusA = "Join";
      for (var member in a.members) {
        if (member.userId == userId) {
          statusA = member.canJoin == 0 ? "Requested" : "Joined";
          break;
        }
      }

      // Check user status in group B
      String statusB = "Join";
      for (var member in b.members) {
        if (member.userId == userId) {
          statusB = member.canJoin == 0 ? "Requested" : "Joined";
          break;
        }
      }

      // Custom sorting logic: Requested first, then Joined, then Join
      if (statusA == "Requested" && statusB != "Requested") {
        return -1;
      } else if (statusA != "Requested" && statusB == "Requested") {
        return 1;
      } else if (statusA == "Joined" && statusB != "Joined") {
        return -1;
      } else if (statusA != "Joined" && statusB == "Joined") {
        return 1;
      } else {
        return 0; // No change in order
      }
    });
  }

  List<Groups> sortGroups(List<Groups> groups) {
    return groups
      ..sort((a, b) {
        bool aJoined =
            a.members.any((member) => member.userId == FirebaseUtils.myId);
        bool bJoined =
            b.members.any((member) => member.userId == FirebaseUtils.myId);
        return aJoined == bJoined ? 0 : (aJoined ? -1 : 1);
      });
  }
}
