// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
//
// class CustomPinput extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final GlobalKey<FormState> formKey;
//   final void Function(String) onCompleted;
//   final void Function(String) onChanged;
//
//   const CustomPinput({
//     Key? key,
//     required this.controller,
//     required this.focusNode,
//     required this.formKey,
//     required this.onCompleted,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(19),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 3),
//             blurRadius: 8,
//             blurStyle: BlurStyle.outer,
//             color: Colors.grey.withOpacity(.5),
//           ),
//         ],
//       ),
//     );
//
//     return Form(
//       key: formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Pinput(
//             length: 5,
//             controller: controller,
//             focusNode: focusNode,
//             defaultPinTheme: defaultPinTheme,
//             validator: (value) {
//               return value == '22222' ? null : 'Pin is incorrect';
//             },
//             onCompleted: onCompleted,
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class PinputExample extends StatefulWidget {
//   const PinputExample({Key? key}) : super(key: key);
//
//   @override
//   State<PinputExample> createState() => _PinputExampleState();
// }
//
// class _PinputExampleState extends State<PinputExample> {
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPinput(
//       controller: pinController,
//       focusNode: focusNode,
//       formKey: formKey,
//       onCompleted: (pin) {
//         debugPrint('onCompleted: $pin');
//       },
//       onChanged: (value) {
//         debugPrint('onChanged: $value');
//       },
//     );
//   }
// }
