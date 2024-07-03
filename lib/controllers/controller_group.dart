import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../constants/chat_constant.dart';
import '../models/chat_group.dart';
import '../models/group_info.dart';
import '../models/group_message.dart';
import 'controller_get_group_member.dart';

class GroupController extends GetxController {
  var isLoading = false.obs;
  var groupMessage = ''.obs;

  Future<void> createGroup({
    required String img,
    required String title,
    required String description,
    required bool isPrivate,
    required int timeSensitive,
  }) async {
    final url = '${AppEndPoint.baseUrl}/create-group';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'img': img,
          'title': title,
          'description': description,
          'is_private': isPrivate ? 1 : 0,
          'time_sensitive': timeSensitive,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group created successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to create group';
      }
    } catch (e) {
      groupMessage.value = 'Failed to create group: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> joinGroup(int groupId) async {
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.joinGroup),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'group_id': groupId,
        }),
      );

      final data = json.decode(response.body);
      log(data.toString());
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group join request sent successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to join group';
      }
    } catch (e) {
      groupMessage.value = 'Failed to join group: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> addGroupAdmin(int groupId, int memberId) async {
    final url = '${AppEndPoint.baseUrl}/add-group-admin';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId, 'member_id': memberId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Member added as admin successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to add admin';
      }
    } catch (e) {
      groupMessage.value = 'Failed to add admin: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> removeUser(int groupId, int memberId) async {
    final url = '${AppEndPoint.baseUrl}/remove-group-member';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId, 'member_id': memberId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Member remove successfully';
        var controller = Get.put(GroupMemberController(groupId: groupId));
        controller.fetchGroupMembers(groupId);
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to remove';
      }
    } catch (e) {
      groupMessage.value = 'Failed to remove: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> addSubscriber(int groupId, int memberId) async {
    final url = '${AppEndPoint.baseUrl}/add-subscriber';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId, 'user_id': memberId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        await addMemberToGroup(groupId.toString(), memberId.toString())
            .then((onValue) {
          groupMessage.value = 'Subscriber added  successfully';
          Get.snackbar("Success", groupMessage.value);
        });
        groupMessage.value = 'Subscriber added  successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to add Subscriber';
      }
    } catch (e) {
      groupMessage.value = 'Failed to add Subscriber: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> acceptGroupRequest(int groupId, int memberId) async {
    final url = '${AppEndPoint.baseUrl}/accept-group-request';
    String? token = await LoginAPIService.getToken();

    try {
      // isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId, 'member_id': memberId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group request accepted successfully';
      } else {
        groupMessage.value =
            data['data']['msg'] ?? 'Failed to accept group request';
      }
    } catch (e) {
      groupMessage.value = 'Failed to accept group request: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> rejectGroupRequest(int groupId, int memberId) async {
    final url = '${AppEndPoint.baseUrl}/reject-group-request';
    String? token = await LoginAPIService.getToken();

    try {
      // isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId, 'member_id': memberId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group request accepted successfully';
      } else {
        groupMessage.value =
            data['data']['msg'] ?? 'Failed to accept group request';
      }
    } catch (e) {
      groupMessage.value = 'Failed to accept group request: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> muteUnmuteGroup(int groupId) async {
    final url = '${AppEndPoint.baseUrl}/mute-unmute-group';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = data['data']['msg'];
      } else {
        groupMessage.value =
            data['data']['msg'] ?? 'Failed to mute/unmute group';
      }
    } catch (e) {
      groupMessage.value = 'Failed to mute/unmute group: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> getGroupActivity(int groupId,
      {String? startDay, String? endDay}) async {
    final url = '${AppEndPoint.baseUrl}/get-group-activity';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'group_id': groupId,
          if (startDay != null) 'start_day': startDay,
          if (endDay != null) 'end_day': endDay,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        // Handle the data accordingly
        log(data.toString());
      } else {
        groupMessage.value =
            data['data']['msg'] ?? 'Failed to get group activity';
      }
    } catch (e) {
      groupMessage.value = 'Failed to get group activity: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> leaveGroup(int groupId) async {
    final url = '${AppEndPoint.baseUrl}/group/leave';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'group_id': groupId,
        }),
      );
      log(response.body);

      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Get.back();
        Get.back();

        groupMessage.value = 'Left group successfully';

        Get.snackbar('Status', groupMessage.value);
      } else {
        final data = json.decode(response.body);

        log(data['data']['msg']);
        // groupMessage.value = data['data']['msg'] ?? 'Failed to leave group';
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteGroup(int groupId) async {
    final url = '${AppEndPoint.baseUrl}/delete-group';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group deleted successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to delete group';
      }
    } catch (e) {
      groupMessage.value = 'Failed to delete group: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> updateGroup({
    required int groupId,
    String? img,
    String? title,
    String? description,
    bool? isPrivate,
    int? timeSensitive,
  }) async {
    final url = '${AppEndPoint.baseUrl}/update-group';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'group_id': groupId,
          if (img != null) 'img': img,
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (isPrivate != null) 'is_private': isPrivate ? 1 : 0,
          if (timeSensitive != null) 'time_sensitive': timeSensitive,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['data']['status']) {
        groupMessage.value = 'Group updated successfully';
      } else {
        groupMessage.value = data['data']['msg'] ?? 'Failed to update group';
      }
    } catch (e) {
      groupMessage.value = 'Failed to update group: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  var groupMessages = <Message>[].obs; // Use the Message model class

  Future<void> getGroupMessages(int groupId) async {
    final url = '${AppEndPoint.baseUrl}/get-group-message';
    String? token = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'group_id': groupId}),
      );

      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data']['status']) {
          GroupMessagesResponse groupMessagesResponse =
              GroupMessagesResponse.fromJson(data);
          groupMessages.value = groupMessagesResponse.messages;
          groupMessage.value = 'Messages retrieved successfully';
        } else {
          groupMessage.value =
              'Failed to retrieve messages: ${data['data']['message']}';
        }
      } else {
        groupMessage.value =
            'Failed to retrieve messages: ${response.statusCode}';
      }
    } catch (e) {
      log('Error: $e');
      groupMessage.value = 'Failed to retrieve messages: $e';
    } finally {
      isLoading(false);
      Get.snackbar('Status', groupMessage.value);
    }
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    log("addMemberToGroup called with groupId: $groupId, userId: $userId");

    try {
      // Get the current group data
      DataSnapshot groupSnapshot = await chatGroupRef.child(groupId).get();
      log("Group data fetched.");

      if (groupSnapshot.exists) {
        ChatGroup chatGroup = ChatGroup.fromSnapshot(groupSnapshot);
        List<String> memberIds = chatGroup.memberIds;

        // Log current members
        log("Current members: $memberIds");

        // Add the new member to the list if not already present
        if (!memberIds.contains(userId)) {
          memberIds.add(userId);
          log("Updated member IDs: $memberIds");

          // Prepare updates for memberIds and messageCounters
          Map<String, Object> updates = {
            'memberIds': memberIds,
            'messageCounters/$userId': 0,
          };

          // Perform the update
          await chatGroupRef.child(groupId).update(updates);
          log("New member added and message counter initialized.");
        } else {
          log("User already in the group.");
        }
      } else {
        log("Group does not exist.");
      }
    } catch (error) {
      log("Error joining group: $error");
    }
  }

  var groupInfo = GroupInfoResponse(
    status: false,
    code: 0,
    groupInfo: GroupInfo(
      id: 0,
      image: '',
      title: '',
      description: '',
      createdAt: '',
      timeSensitive: 0,
      numberOfMembers: 0,
    ),
    admins: [],
    members: [],
  ).obs;

  var isInfoLoading = false.obs;

  Future<void> fetchGroupInfo(int groupId) async {
    isInfoLoading(true);
    try {
      String? token = await LoginAPIService.getToken();
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/get-group-info'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'group_id': groupId,
        }),
      );

      log(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        log("json Data ${jsonData.toString()}");
        GroupInfoResponse groupInfoResponse =
            GroupInfoResponse.fromJson(jsonData['data']);
        groupInfo.value = groupInfoResponse;
      } else {
        log('Failed to load group info');
      }
    } catch (e) {
      log('Error fetching group info: $e');
    } finally {
      isInfoLoading(false);
    }
  }
}
