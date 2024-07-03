import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../models/get_member_token.dart';

class ControllerGetGroupMemberToken extends GetxController {
  var isLoading = false.obs;
  RxList<String> memberTokens = RxList([]);


  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchGroupMemberToken(int groupId) async {
    isLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      var body = json.encode({"group_id": groupId});

      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-group-member-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // log('Response status code: ${response.statusCode}');
      // log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final groupMemberTokenResponse = GroupMemberTokenResponse.fromJson(jsonData);
        memberTokens.assignAll(groupMemberTokenResponse.memberToken);
      } else {
        memberTokens.value=[];
        throw Exception('Failed to load member tokens. Status code: ${response.statusCode}');
      }
    } catch (e) {

      memberTokens.value=[];
      log(e.toString());
      // Get.snackbar('Error', 'Failed to load member tokens: $e');
    } finally {
      isLoading(false);
    }
  }
}
