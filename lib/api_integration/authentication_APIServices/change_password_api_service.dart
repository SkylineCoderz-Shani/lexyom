import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePassAPIService {
  Future<void> changePassword(
      String email, String otp, String newPassword) async {
    try {
      final otpResponse = await http.post(
        Uri.parse("https://skorpio.codergize.com/api/change_password"),
        body: jsonEncode({'email': email, 'password': otp, 'verpassword': newPassword}),
        headers: {'Content-Type': 'application/json'},
      );
      if (otpResponse.statusCode == 200) {
        final changePasswordResponse = await http.post(
          Uri.parse("https://skorpio.codergize.com/api/login"),
          body: jsonEncode({'email': email, 'newPassword': newPassword}),
          headers: {'Content-Type': 'application/json'},
        );

        if (changePasswordResponse.statusCode == 200) {
          Get.snackbar(
            'Success',
            'Password updated successfully',
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.black,
          );
        } else {
          // Show an error message based on the response
          Get.snackbar(
            'Error',
            'Failed to change password',
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.black,
          );
        }
      } else {
        // OTP verification failed
        // Show an error message to the user
        Get.snackbar(
          'Error',
          'Failed to verify OTP',
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      // Exception occurred during OTP verification or password change
      // Show an error message to the user
      Get.snackbar(
        'Error',
        'Exception during password change: $e',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
      );
    }
  }
}
