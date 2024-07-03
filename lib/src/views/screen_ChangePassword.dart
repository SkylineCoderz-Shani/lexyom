import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_VerifyOtp.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_container.dart';
import 'package:http/http.dart' as http;

class ScreenEmailVerification extends StatelessWidget {
  UserResponse user;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(text: user.user.information.email);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Get.back(); }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyContainer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Confirm your email", style: title1,),
                Text("Enter the email associated with your account and\nwe’ll send an email with code to reset your password", style: subtitle2,),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                ).marginSymmetric(
                  vertical: 25.sp,
                ),
                CustomButton(
                  text: "Send Code",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: () async {
                    if (emailController.text.isEmpty) {
                      Get.snackbar('Email cannot be empty', 'Please enter your email');
                      return;
                    }
                    Get.dialog(
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                    );

                    try {
                      var response = await http.post(
                        Uri.parse('https://skorpio.codergize.com/api/forgot'),
                        body: {'email': emailController.text},
                      );
                      Get.back(); // Dismiss the loading indicator

                      if (response.statusCode == 200) {
                        Get.to(ScreenOtpCode(
                          email: emailController.text,
                        ));
                      } else {
                        Get.snackbar(
                          'Error',
                          'Failed to send email. Please try again later.',
                          backgroundColor: Colors.white,
                        );
                      }
                    } catch (e) {
                      // Dismiss the loading indicator
                      Get.back();
                      Get.snackbar(
                        'Error',
                        'Failed to send email: $e',
                        backgroundColor: Colors.white,
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

ScreenEmailVerification({
    required this.user,
  });
}
