import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/HomeScreen/home_screen.dart';
import 'package:lexyom/src/SignupScreen/login_screen.dart';
import 'package:lexyom/src/views/screen_subscrptionSimple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/home_controllers.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    const animationDuration = Duration(milliseconds: 6000);
    _timer = Timer(animationDuration, checkLoginStatus);
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showConnectivityError();
    } else {
      checkLoginStatus();
    }
  }

  void showConnectivityError() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startAnimation();
            },
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? usertype = prefs.getInt('usertype');
    if (token != null) {
      ControllerHome controllerHome = Get.put(ControllerHome());
      controllerHome.fetchUserInfo().then((value) {
        if (controllerHome.user.value != null) {
          log(controllerHome.user.value!.user.information.toString());
          var user = controllerHome.user.value!.user.information;
          if (user.subscribed == "1") {
            Get.offAll(HomeScreen());
          } else {
            Get.offAll(ScreenSubscription());
          }
        } else {
          showConnectivityError();
        }
      }).catchError((error) {
        showConnectivityError();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
        }),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: ExtendedImage.asset(
              'assets/images/lexyom_splash_screen.gif',
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return CircularProgressIndicator();
                  case LoadState.completed:
                    return state.completedWidget;
                  case LoadState.failed:
                    return Text('Failed to load image');
                  default:
                    return Text('Failed to load image');
                }
              },
            ),
          ),
          Positioned.fill(
            bottom: 30.sp,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Powered by",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      "CoderGize",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
