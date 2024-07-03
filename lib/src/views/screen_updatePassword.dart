import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../api_integration/authentication_APIServices/update_password_usingOTP.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_container.dart';
import '../SignupScreen/login_screen.dart';

class ScreenUpdatePassword extends StatelessWidget {
  final ChangePasswordWithOTP? apiService;
  final String? email;

  ScreenUpdatePassword({Key? key, this.apiService, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyContainer(),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Create new password", style: title1,),
                  Text("Welcome back! Please enter your new password", style: subtitle2,),
                  CustomTextField(
                    controller: newPasswordController,
                    label: 'Create new password',
                    isPasswordField: true,
                  ).marginSymmetric(
                    vertical: 25.sp,
                  ),
                  CustomTextField(
                    controller: confirmPasswordController,
                    label: 'Confirm password',
                    isPasswordField: true,
                  ),
                  SizedBox(
                    height: 40.sp,
                  ),
                  CustomButton(
                    text: "Update",
                    buttonColor: buttonColor,
                    textColor: Colors.black,
                    onTap: () async {
                      print("email: $email");
                      print("New Password: ${newPasswordController.text}");
                      print("Confirm Password: ${confirmPasswordController.text}");
                      if (email == null || email!.isEmpty || newPasswordController.text.isEmpty) {
                        Get.snackbar(
                          'Email or New Password is empty',
                          'Please enter your email and new password',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                        return;
                      }
                      Get.dialog(
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        barrierDismissible: false,
                        barrierColor: Colors.black.withOpacity(0.5),
                      );
                      try {
                        print("email $email");
                        print("newPassword ${newPasswordController.text}");
                        print("confirmPassword ${confirmPasswordController.text}");
                        bool isPasswordUpdated = await ChangePasswordWithOTP().updatePassword(email!, newPasswordController.text, confirmPasswordController.text);
                        Get.back();
                        if (isPasswordUpdated) {
                          Get.snackbar(
                            'Password Updated',
                            'Your password has been updated successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                          );
                          Get.offAll(LoginScreen());
                        } else {
                          Get.snackbar(
                            'Password Update Failed',
                            'Failed to update your password',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                          );
                        }
                      } catch (e) {
                        Get.back();
                        Get.snackbar(
                          'Error',
                          'Failed to update password: $e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                      }
                    },
                  ).marginSymmetric(
                    vertical: 6.sp,
                  ),
                ]
            ).marginSymmetric(
              horizontal: 16.sp,
              vertical: 10.sp,
            ),
          ],
        ),
      ),
    );
  }
}
