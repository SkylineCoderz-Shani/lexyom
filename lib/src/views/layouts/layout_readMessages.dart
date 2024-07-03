import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/firebase_utils.dart';
import '../../../controllers/controller_user.dart';
import '../../../dummy_data_Users/users_List.dart';
import '../../../models/chat_model.dart';
import '../../../models/last_message.dart';
import '../../../models/user.dart';
import '../../HomeScreen/HomeView/layout_user_chat_list.dart';
import '../../HomeScreen/HomeView/screen_group_chat.dart';
import '../screen_userChat.dart';

class LayoutReadMessages extends StatefulWidget {
  List<LastMessage> readMessages;

  @override
  State<LayoutReadMessages> createState() => _LayoutReadMessagesState();

  LayoutReadMessages({
    required this.readMessages,
  });
}

class _LayoutReadMessagesState extends State<LayoutReadMessages> {
  List<String> items = List.generate(20, (index) => "Item ${index + 1}");

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());

    return widget.readMessages.isEmpty
        ? Center(child: Text("No User"))
        : ListView.builder(
            itemCount: widget.readMessages.length,
            itemBuilder: (BuildContext context, int index) {
              var lastMessageObj = widget.readMessages[index];

              // Fetch user information
              var user =
                  get2ndUserId(lastMessageObj.chatRoomId, FirebaseUtils.myId);
              return FutureBuilder<UserResponse?>(
                  future: userController.getUserDetailRoomInfo(user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      );
                    }
                    if (snapshot.data == null) {
                      return Center(child: Text("No User Data Found"));
                    }
                    var user = snapshot.data ?? null;
                    return GestureDetector(
                      onTap: () {},
                      child: Dismissible(
                        key: Key(user!.user.information.id.toString()),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (DismissDirection direction) async {
                          return true;
                        },
                        onDismissed: (direction) {
                          setState(() {
                            widget.readMessages.removeAt(index);
                          });
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('$item dismissed'),
                          //     action: SnackBarAction(
                          //       label: 'Undo',
                          //       onPressed: () {
                          //         setState(() {
                          //           items.insert(index, item);
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // );
                        },
                        background: Container(
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: ItemUserChatList(
                            user: user!,
                            lastMessage: lastMessageObj,
                          ).marginSymmetric(
                            horizontal: 15.sp,
                            vertical: 6.sp,
                          ),
                        ),
                      ),
                    );
                  });
            },
          );
  }
}

int get2ndUserId(String chatRoomId, String myId) {
  // Convert myId to an integer
  int myIdInt = int.parse(myId);

  // Split the chatRoomId by the underscore
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
