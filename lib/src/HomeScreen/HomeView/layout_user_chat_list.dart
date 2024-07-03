import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/firebase_utils.dart';
import '../../../models/last_message.dart';
import '../../views/layouts/layout_allMessages.dart';
import '../../views/layouts/layout_readMessages.dart';
import '../../views/layouts/layout_unreadMessages.dart';
import '../../views/screen_user_search.dart';

RxList<LastMessage> unReadMessages = <LastMessage>[].obs;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

class LayoutUserChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _refreshIndicatorKey,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0.sp,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.grey,
            ),
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                text: 'All Messages',
              ),
              Tab(text: 'Read'),
              Tab(text: 'Unread'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 40.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    Get.to(ScreenSearchUsers());
                  },
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    // contentPadding:
                    //     EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    hintText: "Search User",
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseUtils.myId)
                      .collection("chats")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      );
                    }
                    var rooms = snapshot.data!.docs.map((e) {
                      var obj =
                          LastMessage.fromMap(e.data() as Map<String, dynamic>);
                      print(obj.toMap());

                      return obj;
                    }).toList();
                    var readMessages =
                        rooms.where((element) => element.counter == 0).toList();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      unReadMessages.value = rooms
                          .where((element) => element.counter != 0)
                          .toList();
                    });

                    return TabBarView(
                      children: [
                        LayoutAllMessage(
                          allMessages: rooms,
                        ),
                        LayoutReadMessages(
                          readMessages: readMessages,
                        ),
                        LayoutUnreadMessages(
                          unreadMessages: unReadMessages,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
