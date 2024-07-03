import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../api_integration/authentication_APIServices/login_api_service.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_container.dart';
import '../HomeScreen/home_screen.dart';
import '../views/screenForgotPassword_login.dart';
import '../views/screen_subscrptionSimple.dart';
import 'Signup_Screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Secure Storage method is missing for token generation
  /// Hence using API call
  /// and also for logout method which can only logout using token
  Future<void> _login() async {
    String email = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      if (email.isEmpty) {
        Get.snackbar('Error', 'Please enter your email', backgroundColor: Colors.white);
        return;
      }
      if (!GetUtils.isEmail(email)) {
        Get.snackbar('Error', 'Please enter a valid email', backgroundColor: Colors.white);
        return;
      }
      if (password.isEmpty || password.length < 6) {
        Get.snackbar('Error', 'Please enter a password with at least 6 characters', backgroundColor: Colors.white);
        return;
      }

      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: false,
      );

      Map<String, dynamic> response = await LoginAPIService.login(email, password);
      log(response.toString());

      if (response['data']['status'] == true) {
        Get.back();
        String userType = response['data']['user']['information']['usertype'].toString();
        String isSubscribed = response['data']['user']['information']['subscribed'];
        log("Logfjdjf$isSubscribed");

        if (isSubscribed == "1") {
          if (userType == '1') {
            Get.offAll(HomeScreen());
            log("admin");
          } else {
            Get.offAll(HomeScreen());
            log("User");
          }
        } else {
          log("Sun");
          Get.offAll(ScreenSubscription());
        }
      } else {
        Get.back();
        Get.snackbar('Error', response["data"]['msg'], backgroundColor: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Login failed: $e', backgroundColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyContainer(),
            Column(
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to your Account',
                    style: title5,
                  ),
                ).marginSymmetric(
                  vertical: 15.sp,
                ),
                CustomTextField(
                  controller: _usernameController,
                  label: 'Email',
                ).marginSymmetric(
                  vertical: 17.sp,
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  isPasswordField: true,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(ScreenForgetPasswordLogin());
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: "Sign in",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: _login,
                ).marginSymmetric(
                  vertical: 6.sp,
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Text(
                  "New to our app?",
                  style: TextStyle(color: Colors.grey.shade600),
                ).marginOnly(
                  top: 15.sp,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Text(
                    'Sign up here',
                    style: TextStyle(
                        color: Color(0xFFFF3131),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFF3131),
                        decorationThickness: 2),
                  ),
                ),
              ],
            ).marginSymmetric(
              horizontal: 10.sp,
            ),
          ],
        ),
      ),
    );
  }
}
