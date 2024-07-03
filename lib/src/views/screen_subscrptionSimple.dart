import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lexyom/src/views/screen_connect_Metamask.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api_integration/payment_method_APIServices/controller_get_plans.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_meta_mask.dart';
import '../../controllers/controller_payment.dart';
import '../../controllers/controller_setting.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_Selectable_Container_Subscription.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_button_withShade.dart';

class ScreenSubscription extends StatefulWidget {
  @override
  State<ScreenSubscription> createState() => _ScreenSubscriptionState();
}

class _ScreenSubscriptionState extends State<ScreenSubscription> {
  int selectedContainerIndex = -1;
  bool isBottomSheetOpen = false;

  get isSelected => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isBottomSheetOpen) {
      Navigator.of(context).pop();
      isBottomSheetOpen = false;
    }
  }

  RxString planType = "Monthly".obs;
  RxString interval = "".obs;
  ControllerHome controllerHome = Get.put(ControllerHome());
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controllerHome.fetchUserInfo();
    ControllerGetPlans controllerGetPlans = Get.put(ControllerGetPlans());
    // controllerGetPlans.fetchPlans();
    SettingsController settingsController = Get.put(SettingsController());
    WalletController walletController = Get.put(WalletController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Subscription",
          style: homeUserFontText,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Text(
            "Subscribe for the chance to get exclusive offers and the latest news on our courses directly in the application.",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              fontFamily: "Inter",
            ),
            textAlign: TextAlign.center,
          ).marginSymmetric(
            horizontal: 10.w,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          // top: 33.sp,
          left: 20.sp,
          right: 20.sp,
        ),
        child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 6.w),
            //   margin: EdgeInsets.symmetric(vertical: 10.h),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.07),
            //           spreadRadius: 5,
            //           blurRadius: 7,
            //         ),
            //       ],
            //       borderRadius: BorderRadius.circular(7.r)),
            //   child: MyInputField(
            //     controller: addressController,
            //     hint: "Enter Wallet address",
            //   ).marginSymmetric(vertical: 7.h),
            // ),
            CustomButtonShade(
              onTap: () {
                Get.to(ScreenConnectMetamask());
              },
              leadingIconAsset: "assets/images/metmask_icon.png",
              text: "Connect with Metamask",
            ).marginSymmetric(
              vertical: 5.h,
            ),
            SizedBox(
              height: 20.sp,
            ),
            Expanded(
              child: Obx(() {
                if (controllerGetPlans.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controllerGetPlans.plans.isEmpty) {
                  return Center(child: Text('No plans available'));
                } else {
                  return ListView.builder(
                    itemCount: controllerGetPlans.plans.length,
                    itemBuilder: (context, index) {
                      final plan = controllerGetPlans.plans[index];
                      return CustomSelectContainerSubscription(
                        index: index,
                        color: Colors.white,
                        isSelected: selectedContainerIndex == index,
                        onTap: () {
                          isBottomSheetOpen = true;
                          setState(() {
                            selectedContainerIndex = index;
                          });
                          controllerGetPlans.amount.value = plan.monthlyPrice;

                          log(plan.toString());
                          controllerGetPlans.planId.value =
                              plan.monthlyStripePlan ?? "";
                          controllerGetPlans.productId.value =
                              plan.monthlyStripePlan ?? '';
                          if (plan.name == "Free") {
                            interval.value = "one_time";
                          } else if (plan.name == "Golden") {
                            interval.value = "one_time";
                          }
                        },
                        columns: [
                          Text(
                            plan.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: selectedContainerIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ).marginOnly(
                            top: 3.9.sp,
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          Row(
                            children: [
                              Text(
                                "\$${plan.monthlyPrice}",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: selectedContainerIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              if (plan.monthlyPrice != null &&
                                  plan.monthlyPrice != "0")
                                Text(
                                  "${plan.name == "Golden" ? " / Life Time" : " / Monthly"}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: selectedContainerIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )
                            ],
                          ).marginOnly(
                            top: 50.sp,
                          ),
                        ],
                      ).marginOnly(
                        top: 10.sp,
                      );
                    },
                  );
                }
              }),
            ),
            RichText(
              text: TextSpan(
                text: 'Purchasing an from our ',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        openLink(settingsController.setting.value!.nftWebsite);
                      },
                    text: 'website',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' does not necessitate a subscription through the app.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              text: "Subscribe now",
              buttonColor: buttonColor,
              textColor: Colors.black,
              onTap: () {
                if (selectedContainerIndex != -1) {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        width: Get.width,
                        height: Get.height * .62,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Text(
                              "Confirm your Subscription",
                              style: title1,
                            ).marginSymmetric(
                              vertical: 10.sp,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                // height: Get.height * .40,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: buttonColor,
                                    width: 2.sp,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(() {
                                                return Text(
                                                  "${controllerGetPlans.plans[selectedContainerIndex].name} PLAN",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              }),
                                              Spacer(),
                                              if (controllerGetPlans
                                                      .plans[
                                                          selectedContainerIndex]
                                                      .name ==
                                                  "Premium")
                                                Obx(() {
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        "${planType.value}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Switch(
                                                          value:
                                                              planType.value ==
                                                                  "Monthly",
                                                          onChanged: (value) {
                                                            if (planType
                                                                    .value ==
                                                                "Monthly") {
                                                              planType.value =
                                                                  "Yearly";
                                                              interval.value =
                                                                  "yearly";
                                                            } else {
                                                              planType.value =
                                                                  "Monthly";
                                                              interval.value =
                                                                  "monthly";
                                                            }
                                                          }),
                                                    ],
                                                  );
                                                })
                                            ],
                                          )),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Obx(() {
                                              return controllerGetPlans
                                                          .plans[
                                                              selectedContainerIndex]
                                                          .name ==
                                                      "Golden"
                                                  ? Text(
                                                      "\$${controllerGetPlans.plans[selectedContainerIndex].monthlyPrice}/Life time")
                                                  : controllerGetPlans
                                                              .plans[
                                                                  selectedContainerIndex]
                                                              .name ==
                                                          "Free"
                                                      ? Text(
                                                          "\$${controllerGetPlans.plans[selectedContainerIndex].monthlyPrice}/Free")
                                                      : Row(
                                                          children: [
                                                            Text(
                                                              "\$${(planType.value == "Monthly") ? controllerGetPlans.plans[selectedContainerIndex].monthlyPrice : controllerGetPlans.plans[selectedContainerIndex].yearlyPrice} /",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 3.sp,
                                                            ),
                                                            Text(
                                                              "${planType.value}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12.sp,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            )
                                                          ],
                                                        );
                                            }),
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: buttonColor,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).marginSymmetric(
                                        vertical: 10.sp,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: controllerGetPlans
                                            .plans[selectedContainerIndex]
                                            .points
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var point = controllerGetPlans
                                              .plans[selectedContainerIndex]
                                              .points[index];
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 5.h),
                                                height: 10.h,
                                                width: 10.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: buttonColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  point,
                                                  style: TextStyle(
                                                      fontSize: 12
                                                          .sp), // Adjust the font size as needed
                                                ),
                                              ),
                                            ],
                                          ).marginSymmetric(vertical: 4.h);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ).marginSymmetric(
                                  horizontal: 20.w, vertical: 10.h),
                            ),
                            Obx(() {
                              return CustomButton(
                                text: "Subscribe now",
                                loading: controllerGetPlans.isLoading.value,
                                buttonColor: buttonColor,
                                textColor: Colors.black,
                                onTap: () async {
                                  log(controllerGetPlans
                                      .plans[selectedContainerIndex].id
                                      .toString());
                                  if (controllerHome.user.value!.user
                                          .information.subscribed ==
                                      "1") {
                                    controllerGetPlans.changeSubscriptionPlan(
                                        controllerGetPlans
                                            .plans[selectedContainerIndex].id
                                            .toString());
                                  } else {
                                    if (controllerGetPlans
                                            .plans[selectedContainerIndex].id ==
                                        1) {
                                      var response = await controllerGetPlans
                                          .subscribeToPlan(
                                              controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .id,
                                              "o",
                                              "");
                                    } else {
                                      String? productId = (controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .name ==
                                              "Premium")
                                          ? (planType.value == "Monthly"
                                              ? controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .monthlyStripePlan
                                              : controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .yearlyStripePlan)
                                          : controllerGetPlans
                                              .plans[selectedContainerIndex]
                                              .monthlyStripePlan;
                                      String? amount = (controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .name ==
                                              "Premium")
                                          ? (planType.value == "Monthly"
                                              ? controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .monthlyPrice
                                              : controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .yearlyPrice)
                                          : controllerGetPlans
                                              .plans[selectedContainerIndex]
                                              .monthlyPrice;
                                      log(amount);
                                      PaymentsController().makePayment(
                                        amount,
                                        productId!,
                                        onSuccess: (infoData) async {
                                          // Get.offAll(HomeScreen());
                                          //
                                          log(infoData.toString());
                                          Get.back();
                                          Get.dialog(
                                            Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                                backgroundColor:
                                                    Colors.transparent,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            barrierDismissible: false,
                                          );
                                          int? planId = (controllerGetPlans
                                                      .plans[
                                                          selectedContainerIndex]
                                                      .name ==
                                                  "Premium")
                                              ? (planType.value == "Monthly"
                                                  ? controllerGetPlans
                                                      .plans[
                                                          selectedContainerIndex]
                                                      .id
                                                  : controllerGetPlans
                                                      .plans[
                                                          selectedContainerIndex]
                                                      .id)
                                              : controllerGetPlans
                                                  .plans[selectedContainerIndex]
                                                  .id;

                                          // Retrieve payment method ID from the infoData map
                                          String paymentMethodId =
                                              "pm_card_visa";

                                          var response =
                                              await controllerGetPlans
                                                  .subscribeToPlan(
                                                      planId,
                                                      paymentMethodId,
                                                      interval.value);
                                          Get.back();
                                        },
                                        onError: (error) {
                                          print("Payment failed: $error");
                                        },
                                      );
                                    }
                                  }
//                                 // Get.offAll(HomeScreen());

                                  //
                                },
                                // onTap: () {
                                //   controllerGetPlans.subscribeToPlan(1,
                                //       "pm_1PQbwXJnrGXVIoZJLBE4MZ1O", "one_time");
                                // },
                              );
                            }).marginSymmetric(
                              horizontal: 20.sp,
                            ),
                          ],
                        ).marginSymmetric(
                          vertical: 20.sp,
                        ),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please Select at Least one Plan")));
                }
              },
            ).marginSymmetric(
              vertical: 6.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
