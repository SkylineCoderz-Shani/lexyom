import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ContainerState { defaultState, selected, requested }

class SelectableContainer extends StatefulWidget {
  final String defaultText;
  final String selectedText;
  final Color defaultColor;
  final Color selectedColor;
  final Color textColor;
  final String requestedText;
  final Color requestedColor;

  const SelectableContainer({
    Key? key,
    required this.defaultText,
    required this.selectedText,
    required this.defaultColor,
    required this.selectedColor,
    required this.textColor,
    required this.requestedText,
    required this.requestedColor,
  }) : super(key: key);

  @override
  _SelectableContainerState createState() => _SelectableContainerState();
}

class _SelectableContainerState extends State<SelectableContainer> {
  ContainerState _containerState = ContainerState.defaultState;

  void _toggleState() {
    setState(() {
      if (_containerState == ContainerState.defaultState) {
        _containerState = ContainerState.requested;
      } else if (_containerState == ContainerState.requested) {
        _containerState = ContainerState.selected;
      } else {
        _containerState = ContainerState.defaultState;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayText;
    Color containerColor;

    switch (_containerState) {
      case ContainerState.selected:
        displayText = widget.selectedText;
        containerColor = widget.selectedColor;
        break;
      case ContainerState.requested:
        displayText = widget.requestedText;
        containerColor = widget.requestedColor;
        break;
      default:
        displayText = widget.defaultText;
        containerColor = widget.defaultColor;
    }

    return InkWell(
      onTap: _toggleState,
      child: Container(
        height: 40,
        width: Get.width * 0.3,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
