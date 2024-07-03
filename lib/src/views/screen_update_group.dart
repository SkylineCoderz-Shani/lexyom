import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_update_group.dart';
import '../../models/group_info.dart';
import '../CustomWidget/custom_RadioButton.dart';
import '../CustomWidget/custom_button.dart';
import '../CustomWidget/custom_descriptionInputField.dart';
import '../CustomWidget/custom_text_feild.dart';

class ScreenUpdateGroup extends StatefulWidget {
  GroupInfoResponse group;
  @override
  State<ScreenUpdateGroup> createState() => _ScreenCreateGroupState();

  ScreenUpdateGroup({
    required this.group,
  });
}

class _ScreenCreateGroupState extends State<ScreenUpdateGroup> {
  double _currentValue = 0;

  final List<double> _values = [
    0, 30, 60, 300, 900, 1800, 3600, 86400, 9999999
  ];

  final Map<double, String> _labels = {
    0: 'Off',
    30: '30s',
    60: '1m',
    300: '5m',
    900: '15m',
    1800: '30m',
    3600: '1h',
    86400: '24h',
    9999999: 'Never'
  };

  String _getLabelFromValue(double value) {
    return _labels[value] ?? '';
  }
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool isPrivate = false;
  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedValue="Private";
  double _value = 40.0;

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
  void initState() {
  descriptionController.text=widget.group.groupInfo!.description!;
  titleController.text=widget.group.groupInfo!.title!;
  _currentValue=widget.group.groupInfo!.timeSensitive!.toDouble();
  _selectedValue=widget.group.groupInfo!.isPrivate==1?"Private":"Public";
  super.initState();
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
              "Update Group",
              style: title1,
            ),
            Text(
              "Thanks for Updating group Info.",
              style: subtitle1,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h,),
                GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.0),
                        height: 100.sp,
                        width: 100.sp,
                        child: _selectedImage == null
                            ? Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                          size: 60.sp,
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
                ).marginOnly(bottom: 14.h,top: 20.h),
                MyTextFieldDescription(
                  controller: descriptionController,
                  label: 'Group Description',
                  maxLines: 10,
                  minLines: 3,
                  obscureText: false,
                ).marginSymmetric(vertical: 7.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRadioButton(
                      value: 'Private',
                      groupValue: _selectedValue,
                      onChanged: _onRadioButtonChanged,
                      label: 'Private',
                      selectedColor: appPrimaryColor,
                      unselectedColor: Colors.grey[300]!,
                    ),
                    SizedBox(width: 15.0.sp),
                    CustomRadioButton(
                      value: 'Public',
                      groupValue: _selectedValue,
                      onChanged: _onRadioButtonChanged,
                      label: 'Public',
                      selectedColor: appPrimaryColor,
                      unselectedColor: Colors.grey[300]!,
                    ),
                  ],
                ).marginSymmetric(vertical: 10.sp),

                SizedBox(
                  height: 20.h,
                ),
                CustomButton(
                  text: "Update Group",
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
                      await UpdateGroupController().updateGroup(
                        groupId: widget.group.groupInfo!.id!,
                        imgFile: _selectedImage,
                        title: titleController.text,
                        description: descriptionController.text,
                        isPrivate: _selectedValue == 'Private',
                        timeSensitive: _currentValue.toInt(),
                      );
                      Get.snackbar(
                        'Success',
                        'Group updated successfully!',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                      Get.back();
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to update group: $e',
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
