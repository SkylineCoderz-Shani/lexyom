// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'item_message_audio.dart';
//
// class ItemVoiceMessageGroupInfo extends StatelessWidget {
//   const ItemVoiceMessageGroupInfo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.green,
//       child: Center(
//         child: categorizedMessages["voice"]!.isEmpty
//             ? Text("No Voice")
//             : ListView(
//           children: categorizedMessages["voice"]!
//               .map((message) =>
//               ItemMessageAudio(
//                 message: message,
//                 chatId: group.id.toString(),
//               ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
