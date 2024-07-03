import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    this.value,
    this.groupValue,
    this.onChanged,
    this.label,
    this.selectedColor,
    this.unselectedColor = Colors.grey,
  }) : super(key: key);

  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic>? onChanged;
  final String? label;
  final Color? selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () {
        if (onChanged != null && value != null) {
          onChanged!(value);
        }
      },
      child: Row(
        children: [
          Radio<dynamic>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: selectedColor,
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return selectedColor ?? Theme.of(context).colorScheme.primary;
                }
                return unselectedColor;
              },
            ),
          ),
          if (label != null) ...[
            SizedBox(width: 8.0),
            Text(
              label!,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
