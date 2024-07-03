import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_update-profile.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';

class ScreenUpdateHobby extends StatelessWidget {
  TextEditingController hobbyController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    ControllerUpdateProfile controller =
    Get.put(ControllerUpdateProfile());
    ControllerHome controllerHome = Get.put(ControllerHome());
    if (controllerHome.user.value!.user.more.brands != null) {
      brandController.text = controllerHome.user.value!.user.more.brands!;
    }
    if (controllerHome.user.value!.user.more.hobbies != null) {
      hobbyController.text = controllerHome.user.value!.user.more.hobbies!;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Get.back(); }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
        backgroundColor: Colors.black,
      ),

      body: ListView(
        children: [
          Container(
            height: Get.height * .44,
            width: Get.width,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 136,
                      width: 136,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                          )),
                      child: Obx(() {
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(controllerHome
                              .user.value ==
                              null
                              ? image_url
                              : "${AppEndPoint.userProfile}${controllerHome.user
                              .value!.user.information.profile}"),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        controllerHome.user.value!.user.information.name,
                        style: title2,
                      );
                    }),
                    SizedBox(width: 10.sp),
                    Container(
                      height: 25.sp,
                      width: 75.sp,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.diamond_outlined,
                            color: Colors.purple,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Obx(() {
                            return Text(
                              controllerHome.user.value!.user.information.points
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Container(
                  height: 35.sp,
                  width: Get.width * .55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      controllerHome.user.value!.user.information.email,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update Optional Information",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ).marginSymmetric(
                vertical: 15.sp,
              ),
              CustomTextField(
                controller: hobbyController,
                label: 'Update Hobby',
              ),
              CustomTextField(
                controller: brandController,
                label: 'Update Brand',
              ).marginSymmetric(
                vertical: 15.sp,
              ),
              Obx(() {
                return CustomButton(
                  loading: controller.isLoading.value,
                  text: "Update Details",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: () async {
                    isLoading = true;

                    var response = await controller.updateProfileSection({
                      "brand": brandController.text,
                      "hobbie": hobbyController.text
                    });
                  },
                );
              }),
            ],
          ).marginSymmetric(
            horizontal: 20.sp,
          )
        ],
      ),
    );
  }
}
