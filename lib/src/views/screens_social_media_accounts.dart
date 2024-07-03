import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_update-profile.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';

class ScreenSociaMediaAccounts extends StatelessWidget {
  ControllerHome controllerHome = Get.put(ControllerHome());
  final ControllerUpdateProfile updateController = ControllerUpdateProfile();

  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController threadsController = TextEditingController();
  TextEditingController warpcastController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (controllerHome.user.value!.user.socials.tiktok != null) {
      tiktokController.text = controllerHome.user.value!.user.socials.tiktok!;
    }

    if (controllerHome.user.value!.user.socials.youtube != null) {
      youtubeController.text = controllerHome.user.value!.user.socials.youtube!;
    }

    if (controllerHome.user.value!.user.socials.threads != null) {
      threadsController.text = controllerHome.user.value!.user.socials.threads!;
    }

    if (controllerHome.user.value!.user.socials.warpcast != null) {
      warpcastController.text =
      controllerHome.user.value!.user.socials.warpcast!;
    }

    if (controllerHome.user.value!.user.socials.instagram != null) {
      instagramController.text =
      controllerHome.user.value!.user.socials.instagram!;
    }

    if (controllerHome.user.value!.user.socials.facebook != null) {
      facebookController.text =
      controllerHome.user.value!.user.socials.facebook!;
    }

    if (controllerHome.user.value!.user.socials.linkedin != null) {
      linkedinController.text =
      controllerHome.user.value!.user.socials.linkedin!;
    }

    if (controllerHome.user.value!.user.socials.twitter != null) {
      twitterController.text = controllerHome.user.value!.user.socials.twitter!;
    }


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Get.back(); }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
        backgroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * .36,
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
                                : "${AppEndPoint.userProfile}${controllerHome
                                .user.value!.user.information.profile}"),
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
                                controllerHome.user.value!.user.information
                                    .points
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
                    "User Social Media Accounts Details",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ).marginSymmetric(
                  vertical: 15.sp,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      controller: tiktokController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/tk.png").marginSymmetric(
                        vertical: 6.sp,
                      ),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: youtubeController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/yt.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: twitterController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/twitterx.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: facebookController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/fb.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: instagramController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/insta.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: linkedinController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/lnk.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: threadsController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 5.sp,
                          width: 5.sp,
                          "assets/icons/thrd.png"),
                    ).marginSymmetric(vertical: 8.h),
                    CustomTextField(
                      controller: warpcastController,
                      label: 'Profile Name',
                      prefix: Image.asset(
                          height: 2.sp,
                          width: 2.sp,
                          "assets/icons/wp.png").marginSymmetric(
                        vertical: 6.sp,
                      ),
                    ).marginSymmetric(vertical: 8.h),
                  ],
                ),
                Obx(() {
                  return CustomButton(
                    loading: updateController.isLoading.value,
                    buttonColor: buttonColor,
                    textColor: Colors.black,
                    text: 'Update Details',
                    onTap: () async {
                      String tiktok = tiktokController.text;
                      String youtube = youtubeController.text;
                      String threads = threadsController.text;
                      String twitter = twitterController.text;
                      String facebook = facebookController.text;
                      String instagram = instagramController.text;
                      String linkedin = linkedinController.text;
                      String warpcast = warpcastController.text;
                      if (tiktok.isNotEmpty || youtube.isNotEmpty ||
                          twitter.isNotEmpty || facebook.isNotEmpty || instagram
                          .isNotEmpty || linkedin.isNotEmpty ||
                          warpcast.isNotEmpty||threads.isNotEmpty) {
                        updateController.updateProfileSection({
                          "tiktok": tiktok,
                          "youtube": youtube,
                          "twitter": twitter,
                          "facebook": facebook,
                          "instagram": instagram,
                          "threads": threads,
                          "linkedin": linkedin,
                          "warpcast": warpcast
                        });
                      }
                      else {
                        Get.snackbar("Alert", "Please fill at least one field",
                            colorText: Colors.white,
                            backgroundColor: Colors.red);
                      }
                    },
                  );
                }),
              ],
            ).marginSymmetric(horizontal: 20.sp),
          ],
        ),
      ),
    );
  }
}
