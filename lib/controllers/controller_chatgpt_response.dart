import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/chatgpt_prompt_model.dart';

class ChatPromptController extends GetxController {
  final TextEditingController textFieldController = TextEditingController();

  var isLoading = true.obs; // Observable variable to track loading state
  var sendMessageLoading = false.obs; // Observable variable to track loading state
  var chatPrompts = Rxn<List<ChatPrompt>>(); // Rxn is used to handle null values
  var responseList = <ResponseChat>[].obs; // Initialize with an empty list to handle null safety

  @override
  void onInit() {
    super.onInit();
    fetchChatPrompts();
  }

  Future<void> fetchChatPrompts() async {
    isLoading.value = true; // Set loading state to true while fetching data

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    log(token.toString());

    final response = await http.get(
      Uri.parse('https://skorpio.codergize.com/api/get-chatgpt-prompt'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    log(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)["data"];
      if (data["status"]) {
        final chatPromptResponse = ChatPromptResponse.fromJson(data);
        chatPrompts.value = chatPromptResponse.chatPrompts;
      } else {
        chatPrompts.value=[];
      }
    } else {
      chatPrompts.value=[];

    }

    isLoading.value = false; // Set loading state to false after data is fetched
  }

  Future<void> sendMessage(String message) async {
    sendMessageLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("https://skorpio.codergize.com/api/chat/send"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log(data.toString());

      ResponseChat responseChat = ResponseChat(
          title: message,
          response: data['response']
      );

      // Ensure the response list is not null before adding the response
      responseList.add(responseChat);

      // Clear the text field after sending the message
      textFieldController.clear();
      log(responseList.length.toString());
    } else {
      chatPrompts.value=[];

    }
    sendMessageLoading.value = false; // Reset loading state after processing
  }
}

class ResponseChat {
  String title;
  String response;

  ResponseChat({
    required this.title,
    required this.response,
  });
}
