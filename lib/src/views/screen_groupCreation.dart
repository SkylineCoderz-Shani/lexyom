import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../api_integration/authentication_APIServices/login_api_service.dart';
import '../../api_integration/create_Group_APIService/create_group_APIService_method.dart';
import '../../constants/colors.dart';
import '../CustomWidget/custom_RadioButton.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_descriptionInputField.dart';
import '../CustomWidget/custom_text_feild.dart';

class ScreenCreateGroup extends StatefulWidget {
  @override
  State<ScreenCreateGroup> createState() => _ScreenCreateGroupState();
}

class _ScreenCreateGroupState extends State<ScreenCreateGroup> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool isPrivate = false;
  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedValue;
  bool _isRadioButtonSelected = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  void _onRadioButtonChanged(dynamic value) {
    setState(() {
      _selectedValue = value;
      _isRadioButtonSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Group",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Thanks for creating a new group.",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Uncomment and implement image picker
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.0),
                        height: 100,
                        width: 100,
                        child: _selectedImage == null
                            ? Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                          size: 60,
                        )
                            : ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        "Add Image",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  controller: titleController,
                  label: 'Group Title',
                ).marginSymmetric(vertical: 10.sp),
                MyTextFieldDescription(
                  controller: descriptionController,
                  label: 'Group Description',
                  maxLines: 10,
                  minLines: 3,
                  obscureText: false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRadioButton(
                      value: 'Private',
                      groupValue: _selectedValue,
                      onChanged: _onRadioButtonChanged,
                      label: 'Private',
                      selectedColor: buttonColor,
                      unselectedColor: Colors.grey[300]!,
                    ),
                    SizedBox(width: 15.0),
                    CustomRadioButton(
                      value: 'Public',
                      groupValue: _selectedValue,
                      onChanged: _onRadioButtonChanged,
                      label: 'Public',
                      selectedColor: buttonColor,
                      unselectedColor: Colors.grey[300]!,
                    ),
                  ],
                ).marginSymmetric(vertical: 10.sp),
                CustomButton(
                  text: "Create Group",
                  buttonColor: buttonColor,
                  textColor: Colors.black,
                  onTap: _isLoading
                      ? null
                      : () async {
                    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill all fields.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      String? token = await LoginAPIService.getToken();
                      if (token == null) {
                        Get.snackbar(
                          'Error',
                          'Token not found. Please log in.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                        return;
                      }
                      if (_selectedValue == null) {
                        Get.snackbar(
                          'Error',
                          'Please select a privacy level.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                        return;
                      }
                      await GroupService().createGroup(
                        imgFile: _selectedImage,
                        title: titleController.text,
                        description: descriptionController.text,
                        isPrivate: _selectedValue == 'Private',
                        timeSensitive: 0,
                        groupId: 0,
                        userId: 0,
                        isAdmin: 'false',
                        joined: 'false',
                      );
                      Get.snackbar(
                        'Success',
                        'Group created successfully!',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to create group: $e',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ).marginSymmetric(horizontal: 20.sp),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
