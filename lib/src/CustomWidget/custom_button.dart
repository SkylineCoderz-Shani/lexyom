import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomButton extends StatefulWidget {
  String text;
  double? fontSize;
  VoidCallback? onTap;
  bool? isRound;
  double? width;
  double? height;
  EdgeInsetsGeometry? margin;
  Color? buttonColor;
  Color? textColor;
  bool? loading;

  @override
  _CustomButtonState createState() => _CustomButtonState();

  CustomButton({
    required this.text,
    this.fontSize,
    this.onTap,
    this.isRound,
    this.width,
    this.height,
    this.margin,
    this.buttonColor,
    this.textColor,
    this.loading = false,
  });
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap!();
      },
      child: Container(
        alignment: Alignment.center,
        height: widget.height ?? 62,
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: widget.isRound == true
              ? BorderRadius.circular(30)
              : BorderRadius.circular(10),
          color: widget.buttonColor ?? appColor,
        ),
        child: (widget.loading!)
            ? CircularProgressIndicator(
                color: Colors.black,
              )
            : Text(
                widget.text,
                style: TextStyle(
                    fontSize: widget.fontSize ?? 16,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w700,
                    color: widget.textColor ?? Colors.white),
              ),
      ),
    );
  }
}
