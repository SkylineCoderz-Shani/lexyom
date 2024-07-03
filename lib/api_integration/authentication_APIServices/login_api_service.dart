import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/SignupScreen/login_screen.dart';

class LoginAPIService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    String apiUrl = 'https://skorpio.codergize.com/api/login';
    var body = jsonEncode({'email': email, 'password': password});

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var token = responseData['data']['user']['token'];
      var id = responseData['data']['user']['information']['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('id', id);
      return responseData;
    } else {
      return responseData;
    }
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // print('Retrieved Token: $token');
    return token;
  }

  static Future<int?> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    return id;
  }

  static Future<int?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userType = prefs.getInt('userType');
    return userType;
  }
  static Future<void> logout() async {
    try {
      String? token = await LoginAPIService.getToken();
      final response = await http.post(
        Uri.parse('https://skorpio.codergize.com/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log("Logout successfully: ${response.body}");
        Get.snackbar(
          'Successfully',
          'Logged out successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('userType');
        String? clearedToken = prefs.getString('token');
        if (clearedToken == null) {
          log("Token cleared successfully.");
        } else {
          log("Failed to clear token.");
        }
        Get.offAll(() => LoginScreen());
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      log('Error logging out: $e');
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }
}
