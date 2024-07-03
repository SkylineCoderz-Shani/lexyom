import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../api_integration/authentication_APIServices/login_api_service.dart';
import '../../constants/ApiEndPoint.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_update-profile.dart';
import '../../controllers/home_controllers.dart';
import '../../models/user.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_text_feild.dart';
import '../CustomWidget/my_input_feild.dart';

class ScreenEditProfile extends StatefulWidget {
  UserResponse user;

  ScreenEditProfile({required this.user});

  @override
  State<ScreenEditProfile> createState() => _ScreenEditProfileState();
}

class _ScreenEditProfileState extends State<ScreenEditProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? selectedGender;
  RxString dateOfBirth = ''.obs;
  RxString country_code = '+92'.obs;
  String? phone;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _profileController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();

  ControllerUpdateProfile controllerUpdateProfile=Get.put(ControllerUpdateProfile());
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.user.information.name;
    _occupationController.text = widget.user.user.information.occupation;
    _emailController.text = widget.user.user.information.email;
    _locationController.text = widget.user.user.information.location;
    _profileController.text = widget.user.user.information.profile!;
    selectedGender = widget.user.user.information.gender;
    dateOfBirth.value = widget.user.user.information.dob;
    _phoneController.text = widget.user.user.information.phone;
    _companyController.text = widget.user.user.information.company;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateProfile() async {

    String? token = await LoginAPIService
        .getToken(); // Assuming you have a method to get the token    APIService apiService = APIService();
    var response = await ControllerUpdateProfile().updateUserProfile(
      profile: _nameController.text,
      phone: _phoneController.text,
      gender: selectedGender ?? "Male",
      location: _locationController.text,
      dob: dateOfBirth.value!,
      occupation: _occupationController.text,
      company: _companyController.text,
      hobbies: '',
      // Add hobbies field if needed
      brand: '',
      // Add brand field if needed
      instagram: '',
      // Add instagram field if needed
      facebook: '',
      // Add facebook field if needed
      tiktok: '',
      // Add tiktok field if needed
      linkedin: '',
      // Add linkedin field if needed
      twitter: '',
      // Add twitter field if needed
      threads: '',
      // Add threads field if needed
      warpcast: '',
      // Add warpcast field if needed
      youtube: '',
      // Add youtube field if needed
      profileImage: _selectedImage, // Include the selected image
    );



    if (response['status'] == true) {
      print(response);
      Get.snackbar(
        "Successful",
        'Profile updated successfully!',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } else {
      print(response);
      Get.snackbar(
        "Failed",
        'Failed to update profile: ${response['msg']}',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    ControllerHome controllerHome = Get.put(ControllerHome());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * .4.sp,
              width: width,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ).marginOnly(
                          bottom: 10.sp,
                          right: 30.sp,
                        ),
                      ),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          fontFamily: 'Inter',
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ).paddingOnly(
                        bottom: 10.sp,
                        right: 170.sp,
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 136,
                        width: 136,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : NetworkImage(
                            controllerHome.user.value == null
                                ? image_url
                                : "${AppEndPoint.userProfile}${controllerHome
                                .user.value!.user.information.profile}",
                          ) as ImageProvider,
                        ),
                      ),
                      Positioned(
                        left: 50.sp,
                        bottom: 0.sp,
                        child: Container(
                          height: 45.sp,
                          width: 45.sp,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 4.sp,
                              color: Colors.white,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _showPicker(context);
                            },
                            icon: Icon(Icons.camera_alt_rounded),
                            iconSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.sp,
                right: 10.sp,
                top: 20.sp,
                bottom: 10.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyInputField(
                    hint: "Name",
                    controller: _nameController,
                    text: widget.user.user.information.name,
                    suffix: Icon(CupertinoIcons.person),
                  ),
                  Divider(
                    indent: 15.sp,
                    endIndent: 15.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  MyInputField(
                    hint: "Occupation",
                    controller: _occupationController,
                    text: widget.user.user.information.occupation,
                    suffix: Icon(Icons.work),
                  ),
                  Divider(
                    indent: 15.sp,
                    endIndent: 15.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  MyInputField(
                    hint: "Company",
                    text: widget.user.user.information.company,
                    controller: _companyController,
                    suffix: Icon(Icons.business_center),
                  ),
                  Divider(
                    indent: 15.sp,
                    endIndent: 15.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  MyInputField(
                    hint: "Email",
                    controller: _emailController,
                    text: widget.user.user.information.email,
                    suffix: Icon(CupertinoIcons.mail),
                  ),
                  Divider(
                    indent: 15.sp,
                    endIndent: 15.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  MyInputField(
                    hint: "Location",
                    controller: _locationController,
                    text: widget.user.user.information.location,
                    suffix: Icon(CupertinoIcons.placemark),
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.2),
                  //         spreadRadius: 3,
                  //         blurRadius: 3,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: DropdownButton<String>(
                  //     isExpanded: true,
                  //     underline: Container(),
                  //     value: selectedGender,
                  //     hint: Text(widget.user.user.information.gender),
                  //     items: [
                  //       DropdownMenuItem(
                  //         child: Text('Male'),
                  //         value: "Male",
                  //       ),
                  //       DropdownMenuItem(
                  //         child: Text('Female'),
                  //         value: "Female",
                  //       ),
                  //       DropdownMenuItem(
                  //         child: Text('Other'),
                  //         value: "Other",
                  //       ),
                  //     ],
                  //     onChanged: (String? value) {
                  //       setState(() {
                  //         selectedGender = value;
                  //       });
                  //     },
                  //   ).marginSymmetric(
                  //     vertical: 6.sp,
                  //     horizontal: 10.sp,
                  //   ),
                  // ).marginSymmetric(
                  //   horizontal: 10.sp,
                  // ),
                  MyInputField(
                    hint: "Gender",
                    text: widget.user.user.information.gender,
                    controller: _genderController,
                    suffix: Icon(Icons.transgender_sharp),
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  // CustomTextField(
                  //   prefix: CountryCodePicker(
                  //     padding: EdgeInsets.zero,
                  //     onChanged: (value) {
                  //       country_code.value = value.dialCode.toString();
                  //     },
                  //     textStyle: TextStyle(
                  //         fontSize: 14.sp, fontFamily: "Arial",color: Colors.black),
                  //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  //     initialSelection: 'US',
                  //     favorite: ['+1', 'US'],
                  //     // optional. Shows only country name and flag
                  //     showCountryOnly: false,
                  //     // optional. Shows only country name and flag when popup is closed.
                  //     showOnlyCountryWhenClosed: false,
                  //     // optional. aligns the flag and the Text left
                  //     alignLeft: false,
                  //   ).paddingOnly(top: 10)
                  //   ,
                  //   label: 'Phone Number',
                  //   keyboardType: TextInputType.numberWithOptions(),
                  //   onChange: (value) => phone = value,
                  // ),
                  MyInputField(
                    hint: "Phone Number",
                    text: widget.user.user.information.phone,
                    controller: _phoneController,
                    suffix: Icon(Icons.phone),
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.sp,
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
                      color: Colors.grey,
                    ),
                    readOnly: true,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontFamily: "Arial"
                    ),
                    // label: widget.user.user.information.dob,
                    controller: TextEditingController(text: dateOfBirth.value),
                    onChange: (value) => dateOfBirth.value = value!,
                  ).marginSymmetric(
                    horizontal: 10.sp,
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Obx(() {
                    return CustomButton(
                      loading: controllerUpdateProfile.isLoading.value,
                      text: "Update Profile",
                      buttonColor: buttonColor,
                      textColor: Colors.black,
                      onTap: () {
                        if (_selectedImage != null) {
                          _updateProfile();
                        }
                        else {
                          String name = _nameController.text;
                          String occupation = _occupationController.text;
                          String email = _emailController.text;
                          String location = _locationController.text;
                          String phone = _phoneController.text;
                          String company = _companyController.text;
                          String gender = _genderController.text;
                          String dob = dateOfBirth.value!;
                          controllerUpdateProfile.updateProfileSection({
                            "name": name,
                            "occupation": occupation,
                            "email": email,
                            "location": location,
                            "phone": phone,
                            "company": company,
                            "gender": gender,
                            "dob": dob,
                          });
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
