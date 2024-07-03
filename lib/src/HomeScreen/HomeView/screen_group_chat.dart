import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:android_path_provider/android_path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lexyom/controllers/controller_get_member_token.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../api_integration/create_Group_APIService/create_group_model_repository/model_and_fetchGroups.dart';
import '../../../constants/ApiEndPoint.dart';
import '../../../constants/chat_constant.dart';
import '../../../constants/colors.dart';
import '../../../constants/file_pick.dart';
import '../../../constants/firebase_utils.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/controller_get_announcments.dart';
import '../../../controllers/controller_get_group_member.dart';
import '../../../controllers/controller_group.dart';
import '../../../models/message.dart';
import '../../CustomWidget/chat_buble.dart';
import '../../CustomWidget/custom_openDrawer.dart';
import '../../views/layouts/item_image_message.dart';
import '../../views/layouts/item_media.dart';
import '../../views/layouts/item_message_audio.dart';
import '../../views/layouts/item_video_message.dart';
import '../../views/screen_groupInfo.dart';

class ScreenGroupChat extends StatefulWidget {
  Groups group;

  @override
  State<ScreenGroupChat> createState() => _ScreenGroupChatState();

  ScreenGroupChat({
    required this.group,
  });
}

class _ScreenGroupChatState extends State<ScreenGroupChat> {
  ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  late Stream<DatabaseEvent> stream = Stream.empty();

  ChatController controller = Get.put(ChatController());
  GroupController groupController = Get.put(GroupController());
  ControllerGetGroupMemberToken controllerGetGroupMemberToken =
      Get.put(ControllerGetGroupMemberToken());
  RxList<String> membersName = RxList([]);

  @override
  void initState() {
    super.initState();
    groupController.fetchGroupInfo(widget.group.id);
    controller.clearMessageCounter(
        widget.group.id.toString(), FirebaseUtils.myId);

    stream = chatGroupRef
        .child(widget.group.id.toString())
        .child('messages')
        .onValue;

    controllerGetGroupMemberToken.fetchGroupMemberToken(widget.group.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.scrollToBottom();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isPlayingMsg = true.obs;
  bool isRecording = false, isSending = false;

  late bool _isLoading = true;
  late bool _permissionReady;
  late String _localPath;
  TargetPlatform? platform;
  int _selectedIndex = 0;

  final ImagePicker _picker = ImagePicker();

  void _onMenuItemClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void readMessage(List<Message> messages) async {
    for (Message message in messages) {
      if (message.senderId != FirebaseUtils.myId &&
          (message.status == 'sent' || message.status == 'delivered')) {
        await chatref
            .child(widget.group.id.toString())
            .child('messages')
            .child(message.id) // Assuming each message has a unique ID
            .update({'status': 'seen'});
      }
    }
  }

  RxList<Map<String, String>> transformGroupMembersToMentionData = RxList([]);

  @override
  Widget build(BuildContext context) {
    controller.clearMessageCounter(
        widget.group.id.toString(), FirebaseUtils.myId);

    GroupMemberController groupMemberController =
        Get.put(GroupMemberController(groupId: widget.group.id));
    groupMemberController.fetchGroupMembers(widget.group.id).then((valu) {
      membersName.value = groupMemberController.groupMembers
          .where((m) => m.id != FirebaseUtils.myId)
          .map((e) => e.name)
          .toList();
      transformGroupMembersToMentionData.value =
          groupMemberController.groupMembers.map((member) {
        return {
          'id': member.id.toString(),
          'display': member.name,
          'token': member.deviceToken ?? '',
          'full_name': member.name,
          'profile': "${AppEndPoint.groupProfile}${member.profile}",
        };
      }).toList();
      transformGroupMembersToMentionData.add({
        'id': "everyone",
        'display': "everyone",
        'token': "everyone",
        'full_name': "everyone",
        'profile': "${AppEndPoint.userProfile}4ScYhPACYYn5BKhkAIic.jpg",
      });
    });

    log("Men${transformGroupMembersToMentionData.toString()}");

    var adminMember =
        widget.group.members.where((element) => element.isAdmin == 1).toList();
    bool isCurrentUserAdmin = adminMember
        .any((element) => element.userId.toString() == FirebaseUtils.myId);
    Future.delayed(Duration(milliseconds: 2), () {
      controller.scrollToBottom();
    });

    if (controller.messages.isNotEmpty) {
      var lastMessage = controller.messages.value.last;
      DateTime lastTime = lastMessage.senderId == FirebaseUtils.myId
          ? DateTime.fromMillisecondsSinceEpoch(lastMessage.timestamp)
          : DateTime.now();
      controller.checkMessageSendingEligibility(widget.group, lastTime);
    }
    log(widget.group.id.toString());
    AnnouncementGetController announcementGetController =
        Get.put(AnnouncementGetController(groupId: widget.group.id));
    announcementGetController.fetchUnSeenAnnouncements(widget.group.id);
    groupController.fetchGroupInfo(widget.group.id);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          title: GestureDetector(
            onTap: () {
              Get.to(ScreenGroupInfo(
                groupId: widget.group.id,
                messagesList: controller.messages.value,
                tokens: controllerGetGroupMemberToken.memberTokens.value,
              ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Text(
                    (groupController.groupInfo.value!.groupInfo!.title! == "")
                        ? widget.group.title
                        : groupController.groupInfo.value!.groupInfo!.title!,
                    style: TextStyle(fontSize: 18),
                  );
                }),
                Obx(() {
                  return Text(
                      '${(groupController.groupInfo.value.members == null) ? widget.group.numberOfMembers : groupController.groupInfo.value!.groupInfo!.numberOfMembers} Members',
                      style: TextStyle(fontSize: 14, color: Colors.grey));
                }),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16.sp,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: NetworkImage(
                      "${AppEndPoint.userProfile}${widget.group.profile[0]}"),
                ),
                if (widget.group.profile.length > 1)
                  CircleAvatar(
                    radius: 16.sp,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(
                        "${AppEndPoint.userProfile}${widget.group.profile[1]}"),
                  ).marginSymmetric(
                    horizontal: 6.sp,
                  ),
                if (widget.group.profile.length > 2)
                  CircleAvatar(
                    radius: 16.sp,
                    backgroundColor: Color(0xffE3FF00),
                    child: Center(
                      child: Text(
                        "+${widget.group.members.length - 2}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ).marginSymmetric(
              horizontal: 10.sp,
            )
          ],
        ),
        drawer: CustomSidebar(
          onMenuItemClicked: _onMenuItemClicked,
          group: widget.group,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                key: ValueKey(widget.group.id),
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error loading messages"),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return Center(
                      child: Text("No message"),
                    );
                  }

                  controller.messages.value = snapshot.data!.snapshot.children
                      .map((e) => Message.fromJson(
                          Map<String, dynamic>.from(e.value as dynamic)))
                      .toList();

                  var messages = [];
                  messages.assignAll(controller.messages.value);
                  messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.scrollToBottom();
                    if (groupController
                                .groupInfo.value.groupInfo!.timeSensitive! !=
                            0 &&
                        !isCurrentUserAdmin) {
                      List<Message> myMessagesList = controller.getMyMessages();
                      controller.checkMessageSendingEligibility(
                          widget.group,
                          DateTime.fromMillisecondsSinceEpoch(
                              myMessagesList.last.timestamp));
                    }
                  });
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    physics: BouncingScrollPhysics(),
                    controller: controller.scrollController,
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message messageData = messages[index];
                      String senderId = messageData.senderId;
                      bool showImage = index == 0 ||
                          messages[index - 1].senderId != senderId;

                      switch (messageData.type) {
                        case MessageType.text:
                          return ChatBubble(
                            message: messageData,
                            chatId: widget.group.id.toString(),
                            showImage: showImage,
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        case MessageType.voice:
                          return ItemMessageAudio(
                            message: messageData,
                            chatId: widget.group.id.toString(),
                            showImage: showImage,
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        case MessageType.audio:
                          return ItemMessageAudio(
                            message: messageData,
                            showImage: showImage,
                            chatId: widget.group.id.toString(),
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        case MessageType.image:
                          return ImageMessageBubble(
                            showImage: showImage,
                            message: messageData,
                            chatId: widget.group.id.toString(),
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        case MessageType.video:
                          return VideoMessageBubble(
                            message: messageData,
                            chatId: widget.group.id.toString(),
                            showImage: showImage,
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        case MessageType.file:
                          return ItemMedia(
                            message: messageData,
                            chatId: widget.group.id.toString(),
                            showImage: showImage,
                            notificationToken: '',
                            notificationsList: controllerGetGroupMemberToken
                                .memberTokens.value,
                          );
                        default:
                          return Container();
                      }
                    },
                  );
                },
              ),
            ),
            Obx(() {
              return (groupController
                          .groupInfo.value.groupInfo!.timeSensitive! ==
                      9999999&&groupController.groupInfo.value.admins!.any((element) => FirebaseUtils.myIntId!=element.id))
                  ? Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      decoration: BoxDecoration(
                          color: appPrimaryColor,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r))),
                      child: Text(
                        "Only Admin can Send Messages",
                        style: TextStyle(fontSize: 12.sp),
                      ))
                  : Container(
                      child: controller.remainingTime.value == 0 ||
                              controller.canSendMessage == true
                          ? buildTextFieldContainer(
                              context, controller, groupMemberController)
                          : Container(
                              alignment: Alignment.center,
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.r))),
                              // Set your button color
                              child: Countdown(
                                seconds: controller.remainingTime.value,
                                build: (BuildContext context, double time) {
                                  return Text(
                                    time.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30.0),
                                  );
                                },
                                onFinished: () {
                                  var lastMessage =
                                      controller.messages.value.last;
                                  DateTime lastTime =
                                      lastMessage.senderId == FirebaseUtils.myId
                                          ? DateTime.fromMillisecondsSinceEpoch(
                                              lastMessage.timestamp)
                                          : DateTime.now();
                                  controller.checkMessageSendingEligibility(
                                      widget.group, lastTime);
                                },
                              ),
                            ),
                    );
            })
            // Obx(() {
            //   var lastMessage=controller.messages.value.last;
            //   DateTime lastTime=lastMessage.senderId==FirebaseUtils.myId?DateTime.fromMillisecondsSinceEpoch(lastMessage.timestamp):DateTime.now();
            //   controller.checkMessageSendingEligibility(widget.group, lastTime);
            //
            //   return  controller.canSendMessage.value ||
            //       controller.remainingTime.value == 0
            //       ? buildTextFieldContainer(context, controller)
            //       : Container(
            //     alignment: Alignment.center,
            //     width: Get.width,
            //     decoration: BoxDecoration(color: Colors.red),
            //     // Set your button color
            //     child: Countdown(
            //       seconds: controller.remainingTime.value * 60,
            //       build: (BuildContext context, double time) {
            //         return Text(
            //           time.toString(),
            //           style: TextStyle(color: Colors.black, fontSize: 30.0),
            //         );
            //       },
            //       onFinished: () {
            //         var lastMessage=controller.messages.value.last;
            //         DateTime lastTime=lastMessage.senderId==FirebaseUtils.myId?DateTime.fromMillisecondsSinceEpoch(lastMessage.timestamp):DateTime.now();
            //         controller.checkMessageSendingEligibility(widget.group, lastTime);
            //         controller.checkMessageSendingEligibility(widget.group, lastTime);
            //       },
            //     ),
            //   );
            // })
          ],
        ));
  }

  RxList<Map<String, String>> _mentions = <Map<String, String>>[].obs;
  final GlobalKey<FlutterMentionsState> mentionsKey =
      GlobalKey<FlutterMentionsState>();

  Widget buildTextFieldContainer(BuildContext context,
      ChatController controller, GroupMemberController groupMemberController) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
            child: FlutterMentions(
              key: mentionsKey,
              textInputAction: TextInputAction.send,
              onMentionAdd: (mention) {
                if (mention['id'] == "everyone") {
                  _mentions.clear();
                  _mentions.add({
                    'id': mention['id'],
                    'display': mention['display'],
                    'token': mention['token'],
                    'full_name': mention['full_name'],
                    'profile': mention['profile'],
                  });
                } else {
                  _mentions.add({
                    'id': mention['id'],
                    'display': mention['display'],
                    'token': mention['token'],
                    'full_name': mention['full_name'],
                    'profile': mention['profile'],
                  });
                }
                log(_mentions.toString());
              },
              onChanged: (value) {
                controller.messageTyping.value = value;
                annotationcontroller.text = value;
                // Handle text change
              },
              suggestionPosition: SuggestionPosition.Top,
              minLines: 1,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Type something..",
                contentPadding: EdgeInsets.all(10.sp),
                border: InputBorder.none,
              ),
              mentions: [
                Mention(
                  trigger: '@',
                  style: TextStyle(color: Colors.blue),
                  data: transformGroupMembersToMentionData,
                  suggestionBuilder: (data) {
                    return SizedBox(
                      width: Get.width * 0.3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${AppEndPoint.userProfile}${data['profile']}"),
                        ),
                        title: Text(data['full_name']),
                      ),
                    ).marginOnly(left: 50.w);
                  },
                ),
              ],
            ),
          ).marginOnly(left: 10.sp, right: 5.w),
        ),
        SendVoiceMessage().marginOnly(right: 5.w),
        Obx(() {
          log(controller.messageTyping.value);
          return controller.messageTyping.value.isEmpty
              ? InkWell(
                  onTap: () async {
                    _showBottomSheet(context);
                  },
                  child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFFC6C6C6)),
                      child: Obx(
                        () => controller.uploadingLoading.value
                            ? SizedBox(
                                height: 20.sp,
                                width: 20.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  backgroundColor: Colors.red,
                                ).marginAll(10.sp),
                              )
                            : Icon(Icons.add).marginSymmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                      )))
              : SendTextMessage(groupMemberController);
        })
      ],
    ).marginSymmetric(horizontal: 10.w, vertical: 7.h);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return buildBottomSheet(context);
      },
    );
  }

  final annotationcontroller = TextEditingController();

  InkWell SendTextMessage(GroupMemberController groupMemberController) {
    return InkWell(
      onTap: () async {
        String message = annotationcontroller.text.trim();
        mentionsKey.currentState?.controller?.clear();

        annotationcontroller.clear();

        if (message.isNotEmpty) {
          log(_mentions.toString());

          List<String> tokens = [];
          if (_mentions.any((mention) => mention['id'] == "everyone")) {
            // If "everyone" is mentioned, get tokens of all group members
            tokens = groupMemberController.groupMembers
                .map((member) => member.deviceToken)
                .where((token) => token != null)
                .cast<String>()
                .toList();
          } else {
            // Only get tokens of mentioned users
            tokens = _mentions
                .map((mention) {
                  var user = groupMemberController.groupMembers.firstWhere(
                      (member) => member.id.toString() == mention['id']);
                  return user.deviceToken ?? "";
                })
                .where((token) => token.isNotEmpty)
                .toList();
          }

          log(tokens.toString());
          controller.messageTyping.value = "";
          controller
              .sendMessage(
            group: widget.group,
            message: message,
            tokens: _mentions.isNotEmpty
                ? tokens
                : controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.text,
            mentions: _mentions,
          )
              .then((value) {
            controller.image.value = "";
            _mentions.clear();
            controller.scrollToBottom();

            controller.messageTyping.value = "";
          }).catchError((error) {
            log(error.toString());
          });
        }
        controller.image.value = "";
      },
      child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFFC6C6C6)),
          child: Icon(Icons.send)
              .marginSymmetric(horizontal: 10.sp, vertical: 5.sp)),
    );
  }

  GestureDetector SendVoiceMessage() {
    return GestureDetector(
      onTap: () async {
        String text = annotationcontroller.text;
        RecorderController recorderController = RecorderController()
          ..androidEncoder = AndroidEncoder.aac
          ..androidOutputFormat = AndroidOutputFormat.mpeg4
          ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
          ..sampleRate = 44100;
        var sendClicked = false.obs;

        RxString duration = "".obs;
        duration.bindStream(recorderController.onCurrentDuration
            .map((event) => "${formatDuration(event, "mm:ss")}"));

        if (text.isEmpty) {
          String id = FirebaseUtils.newId.toString();
          var recordPermissionAllowed =
              (await recorderController.checkPermission());
          var storagePermissionAllowed = await _checkStoragePermission();
          // print(permissionAllowed
          if (recordPermissionAllowed && storagePermissionAllowed) {
            var dir = await _prepareSaveDir();
            var path = "$dir${Platform.pathSeparator}$id.m4a";
            print(path);

            recorderController.record(path: path);

            Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // height: Get.height * .15,
                        child: Column(
                          children: [
                            ListTile(
                              title: AudioWaveforms(
                                size: Size(Get.width * .5, 50),
                                recorderController: recorderController,
                                enableGesture: true,
                                waveStyle: WaveStyle(
                                    // showDurationLabel: true,
                                    spacing: 8.0,
                                    showBottom: false,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                    gradient: ui.Gradient.linear(
                                      const Offset(70, 50),
                                      Offset(
                                          MediaQuery.of(context).size.width / 2,
                                          0),
                                      [Colors.red, Colors.green],
                                    ),
                                    waveColor: Colors.black),
                              ),
                              trailing: Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color(0xff866e02),
                                      shape: BoxShape.circle),
                                  child: Obx(() {
                                    return IconButton(
                                      onPressed: sendClicked.isTrue
                                          ? null
                                          : () async {
                                              sendClicked.value = true;
                                              var path =
                                                  await recorderController
                                                      .stop(false);
                                              print(path);
                                              if (path != null) {
                                                await FirebaseStorageUtils
                                                        .uploadImage(
                                                            (File(path)),
                                                            "GroupChat/${widget.group.id.toString()}",
                                                            "Voice Message ${id}")
                                                    .then((value) {
                                                  if (path != null) {
                                                    controller.sendMessage(
                                                      group: widget.group,
                                                      message: '',
                                                      tokens:
                                                          controllerGetGroupMemberToken
                                                              .memberTokens
                                                              .value,
                                                      messageType:
                                                          MessageType.voice,
                                                      voiceMessage:
                                                          VoiceMessage(
                                                              voiceUrl: value!,
                                                              duration: duration
                                                                  .value),
                                                    );

                                                    sendClicked.value = false;
                                                    recorderController
                                                        .dispose();
                                                    Get.back();
                                                    // Get.back();
                                                  }
                                                }).catchError((error) {
                                                  sendClicked.value = false;
                                                  recorderController.dispose();
                                                  Get.back();
                                                });
                                              } else {
                                                sendClicked.value = false;
                                                recorderController.dispose();
                                                Get.back();
                                              }
                                            },
                                      icon: Obx(() {
                                        return (sendClicked.value)
                                            ? CircularProgressIndicator()
                                            : Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              );
                                      }),
                                    );
                                  })),
                              leading: IconButton(
                                  onPressed: () {
                                    recorderController.dispose();
                                    Get.back();
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                            Obx(() {
                              return Text(
                                duration.value,
                                style: TextStyle(fontSize: 16.sp),
                              ).paddingAll(10);
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                isDismissible: false);
          }
        }
      },
      child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFFC6C6C6)),
          child: Icon(
            CupertinoIcons.mic,
            color: Colors.black,
          )).marginAll(8.sp),
    );
  }

  // GestureDetector SendImageMessage() {
  //   return GestureDetector(
  //     onTap: () async {
  //       final imagePicker = ImagePicker();
  //       final pickedImage =
  //           await imagePicker.pickImage(source: ImageSource.gallery);
  //       if (pickedImage != null) {
  //         controller.image.value = pickedImage.path;
  //         // setState((){});
  //       }
  //
  //       if (controller.image.value.isNotEmpty) {
  //         String imagePath =
  //             controller.image.value; // Get the image file path as a String
  //
  //         int id = DateTime.now().millisecondsSinceEpoch;
  //         controller.uploadingLoading.value = true;
  //
  //         try {
  //           controller.messageImageUrl.value = await FirebaseUtils.uploadImage(
  //             imagePath, // Pass the file path directly
  //             "messages/images/${id.toString()}",
  //             onSuccess: (url) {
  //               controller
  //                   .sendMessage(
  //                       group: widget.group,
  //                       message: '',
  //                       tokens:
  //                           controllerGetGroupMemberToken.memberTokens.value,
  //                       messageType: MessageType.image,
  //                       imageMessage: ImageMessage(imageUrl: url))
  //                   .then((value) {
  //                 controller.messageController.clear();
  //                 controller.image.value = "";
  //               });
  //               controller.scrollToBottom();
  //               print("Image uploaded successfully. URL: $url");
  //               controller.uploadingLoading.value = false;
  //               controller.scrollToBottom();
  //             },
  //             onError: (error) {
  //               print("Error uploading image: $error");
  //               controller.uploadingLoading.value = false;
  //               // Handle the error here if needed.
  //             },
  //             onProgress: (progress) {
  //               print("Upload progress: $progress");
  //               // Update the progress if needed.
  //             },
  //           ).catchError((error){
  //             log(error.toString());
  //           });
  //
  //           controller.image.value = "";
  //         } catch (error) {
  //           print("Error uploading image or sending message: $error");
  //           // Handle the error here if needed.
  //         }
  //       } else {
  //         print("Image file path is empty");
  //         // Handle the case where the image file path is empty.
  //       }
  //     },
  //     child: Container(
  //       width: 45,
  //       height: 45,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(100), color: Color(0xFFC6C6C6)),
  //       child: Obx(() => controller.uploadingLoading.value
  //           ? SizedBox(
  //               height: 20.sp,
  //               width: 20.sp,
  //               child: CircularProgressIndicator(
  //                 strokeWidth: .2,
  //                 backgroundColor: Colors.red,
  //               ),
  //             )
  //           : Icon(
  //               CupertinoIcons.mic,
  //               color: Colors.black,
  //             )).marginAll(8.sp),
  //     ),
  //   );
  // }

  Container buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 280.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select an option',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                context,
                icon: Icons.image,
                label: 'Image',
                onTap: () {
                  pickImage();
                  Get.back();

                  // Handle image upload
                },
              ),
              _buildOption(
                context,
                icon: Icons.video_library,
                label: 'Video',
                onTap: () {
                  pickVideo();
                  Get.back();

                  // Handle video upload
                },
              ),
              _buildOption(
                context,
                icon: Icons.audiotrack,
                label: 'Audio',
                onTap: () {
                  pickAudio();
                  Get.back();

                  // Handle audio upload
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                onTap: () {
                  pickDocument();
                  Get.back();
                },
              ),
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  pickCamera();
                  Get.back();
                },
              ),
              _buildOption(
                context,
                icon: Icons.image,
                label: 'Gallery',
                onTap: () {
                  pickGallery();
                  Get.back();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector _buildOption(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<String> _prepareSaveDir() async {
    _localPath = (await getTemporaryDirectory()).path;
    _localPath = '$_localPath${Platform.pathSeparator}Skorpio';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
    return savedDir.path;
  }

  Future<bool> _checkStoragePermission() async {
    if (Platform.isIOS) return true;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkStoragePermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> pickCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      controller.uploadingLoading.value = true;
      var file = File(pickedFile.path);
      var fileSize = await file.length();

      var url = await FirebaseStorageUtils.uploadImage(
              file, 'GroupChat/${widget.group.id.toString()}', pickedFile.name)
          .then((value) {
        controller.sendMessage(
            group: widget.group,
            message: "",
            tokens: controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.file,
            fileMessage: FileMessage(
                fileName: pickedFile.name,
                fileUrl: value!,
                fileSize: fileSize.toString()));
        controller.uploadingLoading.value = false;
      }).catchError((error) {
        Get.snackbar("Alert", error.toString());
        controller.uploadingLoading.value = false;

        // SendMessage(value, 'file', pickedFile.name);
      }).catchError((eror) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(eror.toString())));
        controller.uploadingLoading.value = false;
      });
    }
  }

  Future<void> pickGallery() async {
    try {
      final XFile? pickedFile =
          await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Process the picked image file
        print('Gallery image picked: ${pickedFile.path}');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  void pickDocument() async {
    var pickedFile = await FilePick().pickFile(FileType.any);
    if (pickedFile != null) {
      controller.uploadingLoading.value = true;
      var file = File(pickedFile.path);
      var fileSize = await file.length();

      var url = await FirebaseStorageUtils.uploadImage(
              file, 'GroupChat/${widget.group.id.toString()}', pickedFile.name)
          .then((value) {
        controller.sendMessage(
            group: widget.group,
            message: "",
            tokens: controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.file,
            fileMessage: FileMessage(
                fileName: pickedFile.name,
                fileUrl: value!,
                fileSize: fileSize.toString()));
        controller.uploadingLoading.value = false;
      }).catchError((error) {
        Get.snackbar("Alert", error.toString());
        controller.uploadingLoading.value = false;

        // SendMessage(value, 'file', pickedFile.name);
      }).catchError((eror) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(eror.toString())));
        controller.uploadingLoading.value = false;
      });
    }
  }

  void pickVideo() async {
    var pickedFile = await FilePick().pickFile(FileType.video);
    if (pickedFile != null) {
      controller.uploadingLoading.value = true;
      var file = File(pickedFile.path);
      var fileSize = await file.length();

      var url = await FirebaseStorageUtils.uploadImage(
              file, 'GroupChat/${widget.group.id.toString()}', pickedFile.name)
          .then((value) {
        controller.sendMessage(
            group: widget.group,
            message: "",
            tokens: controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.video,
            videoMessage:
                VideoMessage(videoUrl: value!, duration: fileSize.toString()));
        controller.uploadingLoading.value = false;
      }).catchError((error) {
        Get.snackbar("Alert", error.toString());
        controller.uploadingLoading.value = false;

        // SendMessage(value, 'file', pickedFile.name);
      }).catchError((eror) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(eror.toString())));
        controller.uploadingLoading.value = false;
      });
    }
  }

  void pickAudio() async {
    var pickedFile = await FilePick().pickFile(FileType.audio);
    if (pickedFile != null) {
      controller.uploadingLoading.value = true;
      var file = File(pickedFile.path);
      var fileSize = await file.length();

      var url = await FirebaseStorageUtils.uploadImage(
              file, 'GroupChat/${widget.group.id.toString()}', pickedFile.name)
          .then((value) {
        controller.sendMessage(
            group: widget.group,
            message: "",
            tokens: controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.audio,
            audioMessage: AudioMessage(
              audioUrl: value!,
              duration: pickedFile.name,
            ));
        controller.uploadingLoading.value = false;
      }).catchError((error) {
        Get.snackbar("Alert", error.toString());
        controller.uploadingLoading.value = false;

        // SendMessage(value, 'file', pickedFile.name);
      }).catchError((eror) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(eror.toString())));
        controller.uploadingLoading.value = false;
      });
    }
  }

  void pickImage() async {
    var pickedFile = await FilePick().pickFile(FileType.image);
    if (pickedFile != null) {
      controller.uploadingLoading.value = true;
      var file = File(pickedFile.path);
      var url = await FirebaseStorageUtils.uploadImage(
              file, 'GroupChat/${widget.group.id.toString()}', pickedFile.name)
          .then((value) {
        controller.sendMessage(
            group: widget.group,
            message: "",
            tokens: controllerGetGroupMemberToken.memberTokens.value,
            messageType: MessageType.image,
            imageMessage: ImageMessage(
              imageUrl: value!,
            ));
        controller.uploadingLoading.value = false;
      }).catchError((error) {
        log(error.toString());
        Get.snackbar("Alert", error.toString());
        controller.uploadingLoading.value = false;

        // SendMessage(value, 'file', pickedFile.name);
      }).catchError((error) {
        log(error.toString());

        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(error.toString())));
        controller.uploadingLoading.value = false;
      });
    } else {
      controller.uploadingLoading.value = false;
      log("Image not selected");
    }
  }

  String formatDuration(Duration duration, String formatPattern) {
    final formatter = DateFormat(formatPattern);
    return formatter.format(DateTime(0, 0, 0, duration.inHours,
        duration.inMinutes % 60, duration.inSeconds % 60));
  }
}
