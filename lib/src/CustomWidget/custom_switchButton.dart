import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class CustomSwitch extends StatefulWidget {
  @override
  _ReminderSwitchState createState() => _ReminderSwitchState();
}

class _ReminderSwitchState extends State<CustomSwitch> {
  bool _isSwitched = false;

  get buttonColor => Color(0xffFF4956);

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.white,
      activeTrackColor: Color(0xFFE3FF00),
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
          if (_isSwitched) {
            // _showReminderDialog(context);
          }
        });
      },
    );
  }
}