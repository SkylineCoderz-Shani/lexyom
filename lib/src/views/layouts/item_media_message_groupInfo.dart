// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:video_player/video_player.dart';
//
// import '../screen_full_videoPlayer.dart';
//
// class ItemMediaMessageGroupInfo extends StatelessWidget {
//   const ItemMediaMessageGroupInfo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width,
//       child: categorizedMessages["media"]!.isEmpty
//           ? Center(child: Text("No Media"))
//           : SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: categorizedMessages["media"]!
//               .map((message) =>
//           message.type ==
//               MessageType.image
//               ? Image.network(
//             message
//                 .imageMessage!.imageUrl,
//             height: Get.height,
//             fit: BoxFit.cover,
//           )
//               : GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       FullScreenVideoPlayer(
//                           videoUrl: message
//                               .videoMessage!
//                               .videoUrl),
//                 ),
//               );
//             },
//             child: Container(
//               height: Get.height * .45,
//               width: Get.width * .7,
//               margin: EdgeInsets.only(
//                   top: 4.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius:
//                 BorderRadius.only(
//                   topLeft:
//                   Radius.circular(
//                       15.0),
//                   topRight:
//                   Radius.circular(
//                       2.0),
//                   bottomLeft:
//                   Radius.circular(
//                       15.0),
//                   bottomRight:
//                   Radius.circular(
//                       15.0),
//                 ),
//               ),
//               child: Stack(
//                 alignment:
//                 Alignment.center,
//                 children: [
//                   AspectRatio(
//                     aspectRatio:
//                     VideoPlayerController
//                         .network(
//                         message
//                             .content)
//                         .value
//                         .aspectRatio,
//                     child: VideoPlayer(
//                         VideoPlayerController
//                             .network(message
//                             .content)),
//                   ),
//                   Center(
//                     child: Icon(
//                       Icons
//                           .play_circle_outline,
//                       color: Colors.white,
//                       size: 64.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
