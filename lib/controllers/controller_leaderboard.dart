import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/ApiEndPoint.dart';
import '../models/leaderboard.dart';

class ControllerLeaderBoard extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getLeaderBoardList(DateTime.now().month, DateTime.now().year);
  }

  var isLoading = true.obs; // Observable variable to track loading state
  var topThree =
      Rxn<List<RemainingTopUser>>(); // Rxn is used to handle null values
  var remainingLeaderBoard =
      Rxn<Map<String, RemainingTopUser>>(); // Rxn is used to handle null values

  Future<void> getLeaderBoardList(int month, int year) async {
    isLoading.value = true; // Set loading state to true while fetching data

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final requestBody = jsonEncode({'month': month, 'year': year});

    final response = await http.post(Uri.parse(AppEndPoint.getLeaderBoard),
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });

    log(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final LeaderBoard leaderBoard = LeaderBoard.fromJson(data);
      log(leaderBoard.toString());

      topThree.value = leaderBoard.topThree;
      remainingLeaderBoard.value = leaderBoard.remainingTopUsers;
    } else {
      topThree.value = [];
      remainingLeaderBoard.value = {};
    }

    isLoading.value = false; // Set loading state to false after data is fetched
  }
}
