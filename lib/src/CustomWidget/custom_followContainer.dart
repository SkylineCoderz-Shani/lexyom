import 'package:flutter/material.dart';

class CustomFollowBackRow extends StatefulWidget {
  final String initialButtonText;
  final Color initialButtonColor;
  final Color followingButtonColor;
  final String followingButtonText;
  final VoidCallback onFollowing;

  CustomFollowBackRow({
    required this.initialButtonText,
    required this.initialButtonColor,
    required this.followingButtonColor,
    required this.followingButtonText,
    required this.onFollowing,
  });

  @override
  _CustomFollowBackRowState createState() => _CustomFollowBackRowState();
}

class _CustomFollowBackRowState extends State<CustomFollowBackRow> {
  late Color buttonColor;
  late String buttonText;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.initialButtonColor;
    buttonText = widget.initialButtonText;
  }

  void _onFollowBackTap() {
    setState(() {
      buttonColor = widget.followingButtonColor;
      buttonText = widget.followingButtonText;
    });
    widget.onFollowing(); // Call the callback to update the parent widget
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onFollowBackTap,
      child: Container(
        width: 95,
        height: 45,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(child: Text(buttonText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        )),
      ),
    );
  }
}
