import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../models/connecters.dart';
import '../models/connecting.dart';
import '../models/follow_request.dart';

class FollowController extends GetxController {
  var followRequests =
      <FollowRequest>[].obs; // Observable list of follow requests
  var isLoading = false.obs;
  var isFollowRequestLoading = false.obs;
  var isFollowAcceptLoading = false.obs;
  var isFollowRejectLoading = false.obs;
  var followCheckStatusMessage = ''.obs;
  var canChat = ''.obs;

  var connectersList = <Connecter>[].obs;
  var connectingList = <Connecting>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowRequests();
    fetchConnectingList();
    fetchConnectersList();
    fetchFollowCount();
    // fetchFollowRequests();
  }

  RxBool hasRequestNotification = false.obs;

  Future<void> fetchFollowRequests() async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isFollowRequestLoading(true);
      final response = await http.get(
        Uri.parse(AppEndPoint.getFriendsFollowRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Log the entire response body as a string
      log("Test ${response.body}");

      // Cast the decoded JSON to a Map<String, dynamic>
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;

      // Additional logging for debugging
      log(data.toString());

      if (response.statusCode == 200) {
        if (data['data'] != null &&
            data['data']['status'] != null &&
            data['data']['status']) {
          var followerData = data['data']['follower'];

          // Check if followerData is a List or a single object and handle accordingly
          if (followerData is List) {
            followRequests.value = List<FollowRequest>.from(followerData
                .map((x) => FollowRequest.fromJson(x as Map<String, dynamic>)));
          } else if (followerData is Map) {
            followRequests.value = [
              FollowRequest.fromJson(followerData as Map<String, dynamic>)
            ];
          }
          hasRequestNotification.value = followRequests.value.isNotEmpty;
        } else {
          followRequests.value = [];
          // Handle the case where status is false or data is null
        }
      } else {
        followRequests.value = [];

        log('Failed to load follow requests: ${data['data']['msg']}');
      }
    } catch (e) {
      followRequests.value = [];

      log('Exception: $e');
    } finally {
      isFollowRequestLoading(false);
    }
  }

  Future<void> requestBackFollow(int followId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.requestFollow),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'follow_id': followId,
        }),
      );
      final data = json.decode(response.body);
      log(data);
      if (response.statusCode == 200 && data['data']['status']) {
        checkFollowStatus(followId);
      } else {
        log(data['data']['msg']);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> requestFollow(int followId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.requestFollow),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'follow_id': followId}),
      );
      final data = json.decode(response.body);
      log(response.body.toString());
      if (response.statusCode == 200 && data['data']['status']) {
        checkFollowStatus(followId);
      } else {
        log(data['data']['msg']);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  RxList<Map<String, dynamic>> acceptedFollowsList =
      <Map<String, dynamic>>[].obs;

  Future<void> acceptFollow(int followId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isFollowAcceptLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.updateFollow),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {'followid': followId.toString(), 'status': '1'},
      );
      log(response.body);
      final data = json.decode(response.body);
      log(data.toString());
      if (response.statusCode == 200) {
        checkFollowStatus(followId).then((value) {
          if (canChat.value == "no") {
            acceptedFollowsList.add(data['data']);
          } else {
            checkFollowStatus(followId);
          }
        });
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isFollowAcceptLoading(false);
    }
  }

  Future<void> rejectFollow(int followId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isFollowRejectLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.updateFollow),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {'followid': followId.toString(), 'status': '0'},
      );
      final data = json.decode(response.body);
      log(data.toString());
      if (response.statusCode == 200) {
        followCheckStatusMessage.value = data['data']['msg'];
        checkFollowStatus(followId);
      } else {
        log(data['data']['msg']);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isFollowRejectLoading(false);
    }
  }

  Future<void> checkFollowStatus(int userId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.followStatus),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'followid': userId}),
      );
      final data = json.decode(response.body);
      log("Date $data");
      if (response.statusCode == 200) {
        followCheckStatusMessage.value = data['data']['msg'];
        canChat.value = data['data']['can_chat'];
        log(canChat.value);
      } else {
        log(data['data']['msg']);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // New methods for additional API endpoints
  RxInt connectersCount = 0.obs;
  RxInt connectingCount = 0.obs;

  Future<void> fetchFollowCount() async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(AppEndPoint.followCount),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final data = json.decode(response.body);
      log("Follow Count: $data");
      if (response.statusCode == 200) {
        connectersCount.value = data['data']['Connecters'];
        connectingCount.value = data['data']['Connecting'];
        // Handle success
        log('Follow count fetched successfully');
      } else {
        log('Failed to fetch follow count: ${data['msg']}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchConnectersList() async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(AppEndPoint.followList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final data = json.decode(response.body);
      log("Connecters List: $data");
      if (response.statusCode == 200) {
        if (data['data']['status'] == true) {
          var connecterData = data['data']['connecters'];
          connectersList.value = List<Connecter>.from(
              connecterData.map((x) => Connecter.fromJson(x)));
        }
        log('Connecters list fetched successfully');
      } else {
        log('Failed to fetch connecters list: ${data['msg']}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchConnectingList() async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(AppEndPoint.followingList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final data = json.decode(response.body);
      log("Connecting List: $data");
      if (response.statusCode == 200) {
        if (data['data']['status'] == true) {
          var connectingData = data['data']['connecting'];
          connectingList.value = List<Connecting>.from(
              connectingData.map((x) => Connecting.fromJson(x)));
        }
        log('Connecting list fetched successfully');
      } else {
        log('Failed to fetch connecting list: ${data['msg']}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> unfollow(int unfollowId) async {
    String? accessToken = await LoginAPIService.getToken();

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(AppEndPoint.unfollowUser),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'unfollow_id': unfollowId}),
      );

      final data = json.decode(response.body);
      log("Unfollow: $data");
      if (response.statusCode == 200) {
        log('Unfollowed successfully');
        // Optionally, refresh lists after unfollowing
        fetchFollowRequests();
        fetchFollowCount();
        fetchConnectersList();
        fetchConnectingList();
      } else {
        log('Failed to unfollow: ${data['data']['msg']}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
