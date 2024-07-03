import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final ValueChanged<double>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double sliderWidth; // New property for slider width

  const SliderWidget({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.sliderWidth = 200.0, // Default width
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.sliderWidth,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        ),
        child: Slider(
          value: _value,
          min: widget.minValue,
          max: widget.maxValue,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
        ),
      ),
    );
  }
}