import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/controller_meta_mask.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_button_withShade.dart';
import '../CustomWidget/my_input_feild.dart';

class ScreenConnectMetamask extends StatelessWidget {
  const ScreenConnectMetamask({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerHome controllerHome = Get.put(ControllerHome());
    TextEditingController addressController = TextEditingController();
    controllerHome.fetchUserInfo();
    var walletController = Get.put(WalletController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connect to Metamask",
          style: title1,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 40.sp,
            left: 15.sp,
            right: 15.sp,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icons/metamask_logo.png").marginSymmetric(
                vertical: 5.h,
              ),
              Text(
                "Let's get started",
                style: title1,
              ).marginSymmetric(
                vertical: 5.h,
              ),
              Text(
                "Connect and get premium Subscriptions to all features",
                style: subtitle1,
              ).marginSymmetric(
                vertical: 5.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.w),
                margin: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(7.r)),
                child: MyInputField(
                  padding: EdgeInsets.only(
                    bottom: 8.0.sp,
                    left: 8.sp,
                  ),
                  controller: addressController,
                  hint: "Enter Wallet address",
                ).marginSymmetric(vertical: 7.h),
              ).marginSymmetric(
                vertical: 10.h,
              ),
              Obx(() {
                return CustomButtonShade(
                  loading: walletController.isLoading.value,
                  onTap: () {
                    if (addressController.text.isNotEmpty) {
                      walletController.checkNFT(addressController.text.trim());
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please Enter Wallet Address",
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    }
                  },
                  leadingIconAsset: "assets/images/metmask_icon.png",
                  text: "Connect",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                );
              }).marginSymmetric(
                vertical: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
