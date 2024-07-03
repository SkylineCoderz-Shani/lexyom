import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_subscrptionSimple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_button.dart';
import 'screen_askScorpio_chatBot.dart';

class ScreenAskScorpio extends StatelessWidget {
  const ScreenAskScorpio({Key? key});

  @override
  Widget build(BuildContext context) {
    ControllerHome controllerHome = Get.find<ControllerHome>();
    return FutureBuilder<bool>(
      future: _shouldShowScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.data!) {
          return (controllerHome.user.value!.user.information.plan == "free")
              ? ScreenSubscription()
              : ScreenAskScorpioChatBot();
        }
        return Scaffold(
          body: Obx(() {
            return (controllerHome.user.value!.user.information.plan == "free")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/robot_logo.png"),
                      Text(
                        "Welcome to Ask Lex You are using free plan",
                        style: skorpioChatGpt1stScrFontTitle,
                      ).marginSymmetric(
                        vertical: 15.sp,
                      ),
                      CustomButton(
                        text: "Subscribe To Plan",
                        buttonColor: buttonColor,
                        textColor: Colors.black,
                        onTap: () {
                          if (controllerHome
                                  .user.value!.user.information.plan ==
                              "free") {
                            Get.off(ScreenSubscription());
                          } else {
                            Get.off(ScreenAskScorpioChatBot());
                          }
                        },
                      ).marginSymmetric(
                        vertical: 6.sp,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/robot_logo.png"),
                      Text(
                        "Welcome to Ask Scorpio",
                        style: skorpioChatGpt1stScrFontTitle,
                      ).marginSymmetric(
                        vertical: 15.sp,
                      ),
                      CustomButton(
                        text: "Start Chat",
                        buttonColor: buttonColor,
                        textColor: Colors.black,
                        onTap: () {
                          if (controllerHome
                                  .user.value!.user.information.plan ==
                              "free") {
                            Get.off(ScreenSubscription());
                          } else {
                            Get.off(ScreenAskScorpioChatBot());
                          }
                        },
                      ).marginSymmetric(
                        vertical: 6.sp,
                      ),
                    ],
                  );
          }).marginSymmetric(
            horizontal: 20.sp,
          ),
        );
      },
    );
  }

  Future<bool> _shouldShowScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? shouldShow = prefs.getBool('shouldShowScreen');
    if (shouldShow == null || shouldShow) {
      prefs.setBool('shouldShowScreen', false);
      return true;
    } else {
      return false;
    }
  }
}
