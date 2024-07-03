// import 'package:flutter/material.dart';
//
// class ItemFileMessageGroupInfo extends StatelessWidget {
//   const ItemFileMessageGroupInfo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue,
//       child: Center(
//         child: categorizedMessages["files"]!.isEmpty
//             ? Text("No File")
//             : ListView(
//           children: categorizedMessages["files"]!
//               .map((message) =>
//               ListTile(
//                 title: Text(message.content),
//               ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
