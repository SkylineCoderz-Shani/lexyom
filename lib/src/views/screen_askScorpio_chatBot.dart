import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../controllers/controller_chatgpt_response.dart';
import '../CustomWidget/custom_AskScorpio_ChatBot_Suggestions.dart';

class ScreenAskScorpioChatBot extends StatefulWidget {
  @override
  _ScreenAskScorpioChatBotState createState() =>
      _ScreenAskScorpioChatBotState();
}

class _ScreenAskScorpioChatBotState extends State<ScreenAskScorpioChatBot> {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ChatPromptController chatPromptController = Get.put(ChatPromptController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Chat",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatPromptController.responseList.isEmpty) {
                if (chatPromptController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (chatPromptController.chatPrompts.value == null) {
                  return Text("No Prompt Added");
                } else {
                  return ListView.builder(
                    itemCount: chatPromptController.chatPrompts.value!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var prompt = chatPromptController.chatPrompts.value![index];
                      return CustomAskScorpioChatBot(
                        title: prompt.prompt,
                        subtitle: prompt.explanation,
                        isRight: false,
                        onTap: () {
                          chatPromptController.sendMessage(prompt.prompt);
                        },
                      );
                    },
                  );
                }
              } else {
                return ListView.builder(
                  itemCount: chatPromptController.responseList.length + (chatPromptController.sendMessageLoading.value ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index < chatPromptController.responseList.length) {
                      var responseChat = chatPromptController.responseList[index];
                      return CustomAskScorpioChatBot(
                        title: responseChat.title,
                        subtitle: responseChat.response,
                        onTap: () {},
                        isRight: true,
                      );
                    } else {
                      // Show loading indicator at the end
                      return Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Please wait......",style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black
                          ),),
                          SizedBox(
                              height: 30.h,
                              width: 30.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.r,
                              )),
                        ],
                      ).marginSymmetric(vertical: 20.h));
                    }
                  },
                );
              }
            }),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: TextField(
                    maxLines: 5,
                    minLines: 1,
                    controller: chatPromptController.textFieldController,
                    focusNode: _textFieldFocusNode,
                    decoration: InputDecoration(
                      hintText: "Type something...",
                      prefixIcon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.sp),
              Container(
                width: 45.sp,
                height: 45.sp,
                padding: EdgeInsets.all(5.0.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF000000),
                ),
                child: IconButton(
                  onPressed: () {
                    String message = chatPromptController.textFieldController.text.trim();
                    if (message.isNotEmpty) {
                      chatPromptController.sendMessage(message);
                    }
                  },
                  icon: Icon(Icons.send, color: Color(0xFFEfFF00)),
                ),
              ),
            ],
          ).marginSymmetric(horizontal: 10.w, vertical: 7.h),
        ],
      ),
    );
  }
}
