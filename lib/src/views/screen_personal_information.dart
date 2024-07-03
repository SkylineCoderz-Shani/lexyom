import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:lexyom/src/views/screen_subscrptionSimple.dart';
import '../../api_integration/authentication_APIServices/registration_from_singlescreen_api_service.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_container.dart';

class ScreenPersonalInformation extends StatefulWidget {
  final String email;
  final String password;
  final String confirmPassword;
  final VoidCallback onSignUp;
  ScreenPersonalInformation({
    required this.email,
    required this.password,
    required this.onSignUp,
    required this.confirmPassword,
  });

  @override
  _ScreenPersonalInformationState createState() =>
      _ScreenPersonalInformationState();
}

class _ScreenPersonalInformationState
    extends State<ScreenPersonalInformation> {
  String? firstName, lastName , location, occupation, companyName, phone;
  String? selectedGender;
  RxString dateOfBirth = ''.obs;
  RxString country_code = '+92'.obs;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            MyContainer(),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Information',
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
                  label: 'First Name',
                  onChange: (value) => firstName = value,
                ),
                CustomTextField(
                  label: 'Last Name',
                  onChange: (value) => lastName = value,
                ).marginSymmetric(
                  vertical: 15.sp,
                ),
                CustomTextField(
                  prefix: CountryCodePicker(
                    padding: EdgeInsets.zero,
                    onChanged: (value) {
                      country_code.value = value.dialCode.toString();
                    },
                    textStyle: TextStyle(
                        fontSize: 14.sp, fontFamily: "Arial",color: Colors.black),
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'LB',
                    favorite: ['+961', 'LB'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ).paddingOnly(top: 10)
                  ,
                  label: 'Phone Number',
                  keyboardType: TextInputType.numberWithOptions(),
                  onChange: (value) => phone = value,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Gender", style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child:DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            value: selectedGender,
                            hint: Text('Gender'),
                            items: [
                              DropdownMenuItem(
                                child: Text('Male'),
                                value:"Male",
                              ),
                              DropdownMenuItem(
                                child: Text('Female'),
                                value: "Female",
                              ),
                              DropdownMenuItem(
                                child: Text('Other'),
                                value:"Other",
                              ),
                            ],
                             onChanged: (String? value) {
                              setState(() {
                              selectedGender = value!;
                               });
                              log(selectedGender.toString());
                            },
                          ).marginSymmetric(
                        vertical: 6.sp,
                        horizontal: 10.sp,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  label: 'Location',
                  onChange: (value) => location = value,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  onTap: ()async{

                    final DateTime? picked = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: buttonColor, // header background color
                              onPrimary: Colors.black, // header text color
                              onSurface: Colors.black, // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != DateTime.now()) {
                        dateOfBirth.value = "${picked.toLocal()}".split(' ')[0];
                        setState(() {

                        });
                    }
                  },
                  suffix: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  readOnly: true,
                  label: 'Date of Birth',
                  controller: TextEditingController(text: dateOfBirth.value),
                  onChange: (value) => dateOfBirth.value = value!,
                ),
                CustomTextField(
                  label: 'Occupation',
                  onChange: (value) => occupation = value,
                ).marginSymmetric(
                  vertical: 17.sp,
                ),
                CustomTextField(
                  label: 'Company Name',
                  onChange: (value) => companyName = value,
                ),
                SizedBox(
                  height: 12.h,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomButton(
                  text: "Sign up",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: () async {
                    if (firstName != null &&
                        lastName != null &&
                        location != null &&
                        dateOfBirth.value != null &&
                        occupation != null &&
                        companyName != null &&
                        phone != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        },
                      );

                      final apiService = APIService();
                      final response = await apiService.registerUser(
                        firstName: firstName!,
                        lastName: lastName!,
                        phone: country_code.value + phone!,
                        email: widget.email,
                        password: widget.password,
                        confirmPassword: widget.confirmPassword,
                        gender: selectedGender ?? "Male",
                        location: location!,
                        dob: dateOfBirth.value!,
                        occupation: occupation!,
                        company: companyName!,
                      );

                      Navigator.of(context).pop();
                      log(response.toString());

                      if (response['status'] == true) {
                        Get.snackbar(
                          "Success",
                          "Registration successful",
                          backgroundColor: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.black,
                        );
                        Get.offAll(ScreenSubscription());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
                      }
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill in all required fields.",
                        backgroundColor: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.black,
                      );
                    }
                  },
                ).marginOnly(bottom: 20.h)
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

