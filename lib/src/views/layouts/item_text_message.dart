import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';

class ItemTextMessage extends StatelessWidget {
  final Message message;

  const ItemTextMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = message.senderId == FirebaseUtils.myId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: GestureDetector(
        onLongPress: () {
          showReactionPicker(context);

        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${AppEndPoint.userProfile}${message.senderProfileImage}"),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isCurrentUser ? 15.0 : 2.0),
                        topRight: Radius.circular(isCurrentUser ? 2.0 : 15.0),
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        if (message.reactions.isNotEmpty)
                          Row(
                            mainAxisAlignment: isCurrentUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: message.reactions.entries
                                .map((entry) => Text('${entry.value} '))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrentUser)
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${AppEndPoint.userProfile}${message.senderProfileImage}"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showReactionPicker(BuildContext context) {
    final List<String> reactions = ['👍', '❤️', '😢', '😊', '👌', '+'];
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset messageOffset = renderBox.localToGlobal(Offset.zero);
    Size messageSize = renderBox.size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width -
                  messageOffset.dx -
                  messageSize.width * .95,
              top: messageOffset.dy - 60,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          if (reaction == '+') {
                            // Open the emoji picker here
                            // Implement your emoji picker logic
                          } else {
                            addReactionToMessage(message.id, reaction);
                          }
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(reaction, style: TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addReactionToMessage(String messageId, String reaction) {
    final String userId = FirebaseUtils.myId;
    if (message.reactions[userId] == reaction) {
      message.reactions.remove(userId);
    } else {
      message.reactions[userId] = reaction;
    }

    final DatabaseReference messageRef = FirebaseDatabase.instance
        .reference()
        .child("GroupChat")
        .child(message.senderId)
        .child("messages")
        .child(messageId);

    // Update the reactions in the database
    messageRef.update({
      'reactions': message.reactions,
    }).then((_) {
      print("Reactions updated successfully");
    }).catchError((error) {
      print("Failed to update reactions: $error");
    });
  }
}
