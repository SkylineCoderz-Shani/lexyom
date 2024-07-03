import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/group_member.dart';

class GroupMemberController extends GetxController {
  int groupId;
  var isLoading = false.obs;
  var groupMembers = <GroupMember>[].obs;
  var topUsers = <TopUser>[].obs;
  var numberOfMembers = 0.obs;

  @override
  void onInit() {
    fetchGroupMembers(groupId);
    super.onInit();
  }

  Future<void> fetchGroupMembers(int groupId) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Failed to fetch token');
      }

      var body = json.encode({"group_id": groupId});
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-group-member'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: body,
      );

      // log("Group Member Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final groupMemberResponse = GroupMemberResponse.fromJson(jsonData);

        numberOfMembers.value = groupMemberResponse.numberOfMembers;
        topUsers.assignAll(groupMemberResponse.topUsers);
        groupMembers.assignAll(groupMemberResponse.groupMembers);
      } else {
        final jsonData = jsonDecode(response.body);
        final errorMessage = jsonData['data']['msg'] ?? 'Failed to load group members. Status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Failed to load group members: $e');
    } finally {
      isLoading(false);
    }
  }

  GroupMemberController({
    required this.groupId,
  });
}
