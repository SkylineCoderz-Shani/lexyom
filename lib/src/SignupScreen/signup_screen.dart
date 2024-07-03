import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_container.dart';
import '../HomeScreen/home_screen.dart';
import '../views/screen_personal_information.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            MyContainer(),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create your Account',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).marginSymmetric(
                  vertical: 15.sp,
                ),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: _emailValidator,
                ),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPasswordField: true,
                  validator: _passwordValidator,
                ).marginSymmetric(
                  vertical: 17.sp,
                ),
                CustomTextField(
                  isPasswordField: true,
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  validator: _confirmPasswordValidator,
                ).marginOnly(
                  bottom: 17.sp,
                ),
                CustomButton(
                  text: "Sign up",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenPersonalInformation(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                              onSignUp: () {
                                Get.to(HomeScreen());
                              },
                            ),
                          ),
                        );
                  },
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Login here',
                    style: TextStyle(
                        color: Color(0xFFFF3131),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFF3131),
                        decorationThickness: 2),
                  ),
                ),
              ],
            ).marginSymmetric(
              horizontal: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
