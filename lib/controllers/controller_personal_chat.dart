import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_integration/authentication_APIServices/login_api_service.dart';
import '../constants/ApiEndPoint.dart';
import '../constants/chat_constant.dart';
import '../constants/fcm.dart';
import '../constants/firebase_utils.dart';
import '../models/last_message.dart';
import '../models/message.dart';

class ControllerPersonalChat extends GetxController {
  RxList<Message> messagesList = RxList([]);
  TextEditingController messageController = TextEditingController();
  RxString image = "".obs;
  RxString messageTyping = "".obs;
  RxString messageImageUrl = "".obs;
  ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  RxBool uploadingLoading = false.obs;

  Future<void> sendMessage({
    required String chatRoomId,
    required String receiverId,
    required String message,
    required String token,
    required MessageType messageType,
    required int counter,
    VoiceMessage? voiceMessage,
    AudioMessage? audioMessage,
    VideoMessage? videoMessage,
    FileMessage? fileMessage,
    ImageMessage? imageMessage,
  }) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    DocumentReference chatRef = FirebaseFirestore.instance
        .collection("user")
        .doc(receiverId)
        .collection("chats")
        .doc(chatRoomId);

    DocumentSnapshot chatSnapshot = await chatRef.get();
    int _counter = chatSnapshot['counter'] + 1;
    log("Test ${chatSnapshot['counter']}");
    Message messageModel = Message(
      id: id.toString(),
      senderId: FirebaseUtils.myId,
      senderName: FirebaseUtils.myName,
      senderProfileImage: FirebaseUtils.myImage,
      content: message,
      type: messageType,
      reactions: {},
      status: "sent",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      voiceMessage: messageType == MessageType.voice ? voiceMessage : null,
      audioMessage: messageType == MessageType.audio ? audioMessage : null,
      imageMessage: messageType == MessageType.image ? imageMessage : null,
      videoMessage: messageType == MessageType.video ? videoMessage : null,
      fileMessage: messageType == MessageType.file ? fileMessage : null,
    );
    log(message.toString());
    var lastMessageMap = LastMessage(
      sender: messageModel.senderId,
      lastMessage: messageType == MessageType.text
          ? message
          : messageType == MessageType.voice
              ? "Send a voice message"
              : messageType == MessageType.video
                  ? "Send a video"
                  : messageType == MessageType.image
                      ? "Send Image"
                      : "Send a file",
      timestamp: messageModel.timestamp,
      counter: _counter,
      chatRoomId: chatRoomId,
      type: messageType,
      status: 'sent',
    );
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseUtils.myId)
        .collection("chats")
        .doc(chatRoomId)
        .set(lastMessageMap.copyWith(counter: 0).toMap())
        .catchError((onError) {
      Get.snackbar("Alert", onError.toString());
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(receiverId)
        .collection("chats")
        .doc(chatRoomId)
        .set(lastMessageMap.toMap())
        .catchError((onError) {
      Get.snackbar("Alert", onError.toString());
    });

    await chatref
        .child(chatRoomId)
        .child(messageModel.id)
        .set(messageModel.toJson())
        .then((value) {
      addGemPersonalChat();
    }).catchError((onError) {
      log(onError);
    });
    if (token != null) {
      log(token);
      FCM.sendMessageSingle(
          "New Message",
          messageType == MessageType.text
              ? message
              : messageType == MessageType.voice
                  ? "Send a voice message"
                  : messageType == MessageType.video
                      ? "Send a video"
                      : messageType == MessageType.image
                          ? "Send Image"
                          : "Send a file",
          token,
          {});
    }
  }

  int get2ndUserId(String chatRoomId, String myId) {
    // Convert myId to an integer
    int myIdInt = int.parse(myId);

    List<String> ids = chatRoomId.split('_');

    // If the length of ids is not 2, then there's an issue with the input format
    if (ids.length != 2) {
      throw ArgumentError('Invalid chatRoomId format.');
    }

    // Convert the split IDs to integers
    int id1 = int.parse(ids[0]);
    int id2 = int.parse(ids[1]);

    // Determine which ID is not myIdInt
    if (id1 == myIdInt) {
      return id2; // Return the second ID as a string
    } else if (id2 == myIdInt) {
      return id1; // Return the first ID as a string
    } else {
      throw ArgumentError('myId not found in chatRoomId.');
    }
  }

  static Future<void> addGemPersonalChat() async {
    String? token = await LoginAPIService.getToken();

    final response = await http.post(
      Uri.parse('${AppEndPoint.baseUrl}/add-gem-chat'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'user_id': FirebaseUtils.myId},
    );
    log(response.body);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add gem to group');
    }
  }
}
