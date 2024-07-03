import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFieldDescription extends StatelessWidget {
  const MyTextFieldDescription({
    Key? key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.enabled = true,
    this.maxLines = 1, // Default value for maxLines
    this.minLines, // Optional minLines
  }) : super(key: key);

  final String? label;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool obscureText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final String? hintText;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 15),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
