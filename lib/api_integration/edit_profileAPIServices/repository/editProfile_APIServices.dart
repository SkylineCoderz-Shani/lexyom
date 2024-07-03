import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../model/editProfile_model.dart';

class UserProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final occupationController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> updateProfile() async {
    final url =
        'https://your-api-endpoint.com/update-profile'; // api's ed point
    final userProfile = UserProfile(
      name: nameController.text,
      email: emailController.text,
      location: locationController.text,
      occupation: occupationController.text,
      password: passwordController.text,
    );

    try {
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(userProfile));

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar(
            'Error', 'Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating profile');
    }
  }
}
