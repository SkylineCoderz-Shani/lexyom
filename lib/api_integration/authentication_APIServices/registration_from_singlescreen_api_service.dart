import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String location,
    required String dob,
    required String occupation,
    required String company,
  }) async {
    final Uri url = Uri.parse('https://skorpio.codergize.com/api/register');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'f_name': firstName,
      'l_name': lastName,
      'phone': phone,
      'gender': gender,
      'location': location,
      'dob': dob,
      'occupation': occupation,
      'company': company,
      'email': email,
      'password': password,
      'verpassword': confirmPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);
      log(responseBody.toString());

      if (response.statusCode == 200 && responseBody['data']['status'] == true) {
        var token = responseBody['data']['user']['token'];
        var userId = responseBody['data']['user']['information']['id'];

        // Log userId for debugging
        log('User ID: $userId');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('id', userId);
        print("User registered successfully");
        return {
          'status': true,
          'data': responseBody['data'],
        };
      } else {
        return {
          'status': false,
          'message': responseBody['data']['msg'] ?? 'Unknown error occurred',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to register user: $e',
      };
    }
  }
}
