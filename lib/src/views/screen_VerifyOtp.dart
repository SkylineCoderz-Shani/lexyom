import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api_integration/authentication_APIServices/update_password_usingOTP.dart';
import '../../constants/colors.dart';
import '../../custom_package/pin_put.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/my_container.dart';
import 'screen_updatePassword.dart';

class ScreenOtpCode extends StatelessWidget {
  final ChangePasswordWithOTP? apiService;
  final String? email;

  ScreenOtpCode({Key? key, this.apiService, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyContainer(),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify OTP",
                    style: title1,
                  ),
                  Text(
                    "Enter your OTP which has been sent to your email\nand complete verify your account",
                    style: subtitle2,
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Center(
                    child: PinPut(
                      followingFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 5,
                              spreadRadius: 4,
                              // offset: Offset(0,1)
                            )
                          ]),
                      eachFieldHeight: 65,
                      eachFieldWidth: 65,
                      submittedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 5,
                              spreadRadius: 4,
                              // offset: Offset(0,1)
                            )
                          ]),
                      selectedFieldDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 5,
                              spreadRadius: 4,
                              // offset: Offset(0,1)
                            )
                          ]),
                      cursorColor: Colors.red,
                      controller: otpController,
                      onChanged: (String otp) async {
                        bool isOtpVerified = await ChangePasswordWithOTP()
                            .verifyOTP(email!, otp);
                        if (isOtpVerified) {
                          Get.to(ScreenUpdatePassword(email: email!));
                        } else {
                          Get.snackbar(
                            'OTP Verification Failed',
                            'Incorrect OTP',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                          );
                        }
                      },
                      fieldsCount: 4,
                    ),
                  ),
                  SizedBox(
                    height: 17.sp,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "A code has been sent to your email",
                        style: subtitle1,
                      )),
                  SizedBox(
                    height: 7.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Resend in ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.black),
                      ),
                      Countdown(
                        seconds: 60,
                        build: (BuildContext context, double time) => Text(
                          time.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 27.sp,
                  ),
                  CustomButton(
                    text: "Continue",
                    buttonColor: buttonColor,
                    textColor: Colors.black,
                    onTap: () async {
                      print("Button Tapped");
                      print("email: $email");
                      if (email == null ||
                          email!.isEmpty ||
                          otpController.text.isEmpty) {
                        Get.snackbar(
                          'Email or OTP is empty',
                          'Please enter your email and OTP',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                        return;
                      }
                      String otp = otpController.text;
                      Get.dialog(
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        barrierDismissible: false,
                        barrierColor: Colors.black.withOpacity(0.5),
                      );
                      try {
                        bool isOtpVerified =
                            await apiService!.verifyOTP(email!, otp);
                        Get.back();
                        if (isOtpVerified) {
                          Get.to(() => ScreenUpdatePassword(email: email));
                        } else {
                          return;
                        }
                      } catch (e) {
                        return;
                      }
                    },
                  ).marginSymmetric(
                    vertical: 6.sp,
                  ),
                ]).marginSymmetric(
              horizontal: 16.sp,
              vertical: 10.sp,
            ),
          ],
        ),
      ),
    );
  }
}
