import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/leaderborad_Model.dart';

Future<List<UserLeader>> fetchUsers() async {
  final url = 'https://skorpio.codergize.com/api/get-gem-leaderboard';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  final requestBody = jsonEncode({'token': token});

  try {
    final response = await fetchData(requestBody);
    final List<UserLeader> users = [];
    for (var userData in response) {
      users.add(UserLeader.fromJson(userData));
    }
    return users;
  } catch (e) {
    print('Error fetching data: $e');
    throw Exception('Failed to fetch users');
  }
}

Future<List<Map<String, dynamic>>> fetchData(String requestBody) async {
  final url = 'https://skorpio.codergize.com/api/get-gem-leaderboard';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';

  final response = await http.post(
    Uri.parse(url),
    body: requestBody,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    try {
      final jsonData = jsonDecode(response.body);
      if (jsonData['remainingTopUsers'] is Map) {
        return List<Map<String, dynamic>>.from(
            jsonData['remainingTopUsers'].values);
      } else {
        return [];
      }
    } catch (e) {
      print('Error parsing data: $e');
      throw Exception('Failed to parse data');
    }
  } else {
    print('Failed to load data. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load data. Status code: ${response.statusCode}');
  }
}

