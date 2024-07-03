import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:android_path_provider/android_path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lexyom/extensions/time_ago.dart';
import 'package:lexyom/src/views/screen_userProfileInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/chat_constant.dart';
import '../../../constants/file_pick.dart';
import '../../../constants/firebase_utils.dart';
import '../../../models/message.dart';
import '../../constants/ApiEndPoint.dart';
import '../../controllers/controller_personal_chat.dart';
import '../../controllers/home_controllers.dart';
import '../../models/last_message.dart';
import '../../models/user.dart';
import '../CustomWidget/chat_buble.dart';
import 'layouts/item_image_message.dart';
import 'layouts/item_media.dart';
import 'layouts/item_message_audio.dart';
import 'layouts/item_video_message.dart';

class ScreenUserChat extends StatefulWidget {
  UserResponse user;
  String? chatRoomId;
  LastMessage? lstMsg;
  int? counter;

  @override
  State<ScreenUserChat> createState() => _ScreenUserChatState();

  ScreenUserChat({
    required this.user,
    this.chatRoomId,
    this.lstMsg,
    this.counter,
  });
}

class _ScreenUserChatState extends State<ScreenUserChat> {
  late Stream<DatabaseEvent> stream = Stream.empty();

  ControllerPersonalChat controller = Get.put(ControllerPersonalChat());
  var chatRoomId = "";

  RxBool get emojiShowing => false.obs;

  Future<bool> checkUser() async {
    var exist = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseUtils.myId)
        .collection("chats")
        .doc(
            "${widget.user.user.information.id.toString()}_${FirebaseUtils.myId}")
        .get();
    return exist.exists;
  }

  Future<void> checkCondition() async {
    if (chatRoomId == '') {
      bool userExists = await checkUser();
      if (userExists) {
        chatRoomId =
            "${widget.user.user.information.id.toString()}_${FirebaseUtils.myId}";
      } else {
        chatRoomId =
            "${FirebaseUtils.myId}_${widget.user.user.information.id.toString()}";
        log(chatRoomId);
      }
    } else {
      chatRoomId = widget.chatRoomId!;
    }
  }

  Future<void> clearCounter() async {
    try {
      DocumentReference chatRef = FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseUtils.myId)
          .collection("chats")
          .doc(chatRoomId);

      DocumentSnapshot chatSnapshot = await chatRef.get();

      if (chatSnapshot.exists) {
        await chatRef.update({"counter": 0});
      } else {
        print("Document not found: $chatRoomId");
      }
    } catch (error) {
      print("Error clearing counter: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    checkCondition().then((value) {
      log("My Chat Room $chatRoomId");
      log("My Chat Room ${widget.counter}");
      stream = chatref.child(chatRoomId).onValue;

      setState(() {});
      clearCounter();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.scrollToBottom();
      });
    });
  }

  List<String> tokens = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isPlayingMsg = true.obs;
  bool isRecording = false, isSending = false;

  late bool _isLoading = true;
  late bool _permissionReady;
  late String _localPath;
  TargetPlatform? platform;
  int _selectedIndex = 0;

  final ImagePicker _picker = ImagePicker();

  Future<void> readMessage() async {
    if (widget.lstMsg!.sender != FirebaseUtils.myId) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseUtils.myId)
          .collection("chats")
          .doc(chatRoomId)
          .update({"status": "read"});
    }
  }

  @override
  Widget build(BuildContext context) {
    readMessage();
    clearCounter();
    var uid =
        Get.find<ControllerHome>().user.value!.user.information.id.toString();
    DateTime now = DateTime.now();
    var todatDate =
        DateTime(now.day, now.month, now.year).millisecondsSinceEpoch;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.sp,
        title: GestureDetector(
          onTap: () {
            Get.to(ScreenUserProfileInfo(id: widget.user.user.information.id));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.user.information.name,
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                widget.user.user.information.lastSeen!.isOnline
                    ? "Online"
                    : widget.user.user.information.lastSeen!.toRelativeTime,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        leadingWidth: 70.w,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ).marginOnly(left: 5.sp),
              CircleAvatar(
                radius: 18.r,
                backgroundImage: NetworkImage(
                    "${AppEndPoint.userProfile}${widget.user.user.information.profile}"),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              key: ValueKey(widget.user.user.information.id.toString()),
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading messages"));
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(child: Text("No messages found"));
                }

                List<Message> messages = snapshot.data!.snapshot.children
                    .map((e) => Message.fromJson(
                        Map<String, dynamic>.from(e.value as dynamic)))
                    .toList();
                Message lastMessage = messages.last;
                messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                controller.messagesList.value.assignAll(messages);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.scrollToBottom();
                });
                return messages.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        controller: controller.scrollController,
                        scrollDirection: Axis.vertical,
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          Message messageData = messages[index];
                          String senderId = messageData.senderId;
                          String message = messageData.content;
                          bool showImage = index == 0 ||
                              messages[index - 1].senderId != senderId;

                          return messageData.type == MessageType.text
                              ? ChatBubble(
                                  message: messageData,
                                  chatId: chatRoomId,
                                  showImage: showImage,
                                  notificationToken: widget
                                          .user.user.information.deviceToken ??
                                      "",
                                  notificationsList: [],
                                  personalChat: true,
                                )
                              : messageData.type == MessageType.voice
                                  ? ItemMessageAudio(
                                      personalChat: true,
                                      message: messageData,
                                      chatId: chatRoomId.toString(),
                                      showImage: showImage,
                                      notificationToken: widget.user.user
                                              .information.deviceToken ??
                                          "",
                                      notificationsList: [])
                                  : messageData.type == MessageType.audio
                                      ? ItemMessageAudio(
                                          personalChat: true,
                                          message: messageData,
                                          showImage: showImage,
                                          chatId: chatRoomId.toString(),
                                          notificationToken: widget.user.user
                                                  .information.deviceToken ??
                                              "",
                                          notificationsList: [])
                                      : messageData.type == MessageType.image
                                          ? ImageMessageBubble(
                                              personalChat: true,
                                              showImage: showImage,
                                              message: messageData,
                                              chatId: chatRoomId,
                                              notificationToken: widget
                                                      .user
                                                      .user
                                                      .information
                                                      .deviceToken ??
                                                  "",
                                              notificationsList: [])
                                          : messageData.type ==
                                                  MessageType.video
                                              ? VideoMessageBubble(
                                                  personalChat: true,
                                                  showImage: showImage,
                                                  message: messageData,
                                                  chatId: chatRoomId,
                                                  notificationToken: widget
                                                          .user
                                                          .user
                                                          .information
                                                          .deviceToken ??
                                                      "",
                                                  notificationsList: [])
                                              : messageData.type ==
                                                      MessageType.file
                                                  ? ItemMedia(
                                                      personalChat: true,
                                                      showImage: showImage,
                                                      message: messageData,
                                                      chatId: chatRoomId,
                                                      notificationToken: widget
                                                              .user
                                                              .user
                                                              .information
                                                              .deviceToken ??
                                                          "",
                                                      notificationsList: [],
                                                    )
                                                  : Align(
                                                      alignment: messageData
                                                                  .senderId ==
                                                              FirebaseUtils.myId
                                                          ? Alignment.topRight
                                                          : Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    messageData
                                                                        .senderProfileImage),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            margin: senderId ==
                                                                    uid
                                                                ? EdgeInsets
                                                                    .only(
                                                                        left: 20
                                                                            .w,
                                                                        bottom: 5
                                                                            .sp,
                                                                        top: 4
                                                                            .sp)
                                                                : EdgeInsets.only(
                                                                    left: 12.sp,
                                                                    bottom:
                                                                        5.sp,
                                                                    top: 4.sp),
                                                            height: 200.h,
                                                            width: 100.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border: Border.all(
                                                                  width: .3,
                                                                  color: Color(
                                                                      0xffd6d6d6)),
                                                            ),
                                                            child:
                                                                Image.network(
                                                              messageData
                                                                  .content,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                        },
                      )
                    : Center(child: Text("No message"));
              },
            ),
          ),
          buildTextFieldContainer(context)
        ],
      ),
    );
  }

  Widget buildTextFieldContainer(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              maxLines: 5,
              minLines: 1,
              onChanged: (value) {
                controller.messageTyping.value = value;
                log(controller.messageTyping.value);
              },
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: "Type something..",
                contentPadding: EdgeInsets.all(10.sp),
                border: InputBorder.none,
              ),
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
              : SendTextMessage();
        }),
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

  InkWell SendTextMessage() {
    return InkWell(
      onTap: () async {
        String message = controller.messageController.text.trim();
        clearCounter();
        if (message.isNotEmpty) {
          log("Cunter: ${widget.counter}");
          if (widget.counter != null) {
            widget.counter = widget.counter! + 1;
          } else {
            widget.counter = 1;
          }
          log("Cunter after: ${widget.counter}");
          controller.messageTyping.value = "";
          controller
              .sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: message,
            token: widget.user.user.information.deviceToken ?? "",
            counter: widget.counter!,
            messageType: MessageType.text,
          )
              .then(
            (value) {
              controller.messageController.clear();
              controller.image.value = "";
            },
          );
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
        String text = controller.messageController.text;
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
          // print(permissionAllowed);
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
                                                            File(path),
                                                            "UserChat/$chatRoomId",
                                                            "Voice Message$id")
                                                    .then((value) {
                                                  clearCounter();
                                                  if (widget.counter != null) {
                                                    widget.counter =
                                                        widget.counter! + 1;
                                                  } else {
                                                    widget.counter = 1;
                                                  }
                                                  print(value);
                                                  controller.sendMessage(
                                                    chatRoomId: chatRoomId,
                                                    receiverId: widget.user.user
                                                        .information.id
                                                        .toString(),
                                                    message: "",
                                                    token: widget
                                                        .user
                                                        .user
                                                        .information
                                                        .deviceToken!,
                                                    counter: widget.counter!,
                                                    messageType:
                                                        MessageType.voice,
                                                    voiceMessage: VoiceMessage(
                                                        voiceUrl: value!,
                                                        duration:
                                                            duration.value),
                                                  );
                                                  sendClicked.value = false;
                                                  recorderController.dispose();
                                                  Get.back();
                                                }).catchError((error) {
                                                  sendClicked.value = false;
                                                  recorderController.dispose();
                                                  Get.back();
                                                });
                                                ;
                                              } else {
                                                sendClicked.value = false;
                                                recorderController.dispose();
                                                Get.back();
                                              }
                                            },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
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

  GestureDetector SendImageMessage() {
    return GestureDetector(
      onTap: () async {
        final imagePicker = ImagePicker();
        final pickedImage =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          controller.image.value = pickedImage.path;
        }

        if (controller.image.value.isNotEmpty) {
          String imagePath =
              controller.image.value; // Get the image file path as a String

          int id = DateTime.now().millisecondsSinceEpoch;
          controller.uploadingLoading.value = true;

          try {
            controller.messageImageUrl.value = await FirebaseUtils.uploadImage(
              imagePath,
              "messages/images/${id.toString()}",
              onSuccess: (url) {
                clearCounter();
                if (widget.counter != null) {
                  widget.counter = widget.counter! + 1;
                } else {
                  widget.counter = 1;
                }
                controller
                    .sendMessage(
                        chatRoomId: chatRoomId,
                        receiverId: widget.user.user.information.id.toString(),
                        message: "",
                        token: widget.user.user.information.deviceToken!,
                        counter: widget.counter!,
                        messageType: MessageType.image,
                        imageMessage: ImageMessage(imageUrl: url))
                    .then((value) {
                  controller.messageController.clear();
                  controller.image.value = "";
                });
                controller.scrollToBottom();
                print("Image uploaded successfully. URL: $url");
                controller.uploadingLoading.value = false;
                controller.scrollToBottom();
              },
              onError: (error) {
                print("Error uploading image: $error");
                controller.uploadingLoading.value = false;
              },
              onProgress: (progress) {
                print("Upload progress: $progress");
              },
            );

            controller.image.value = "";
          } catch (error) {
            print("Error uploading image or sending message: $error");
          }
        } else {
          print("Image file path is empty");
        }
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Color(0xFFC6C6C6)),
        child: Obx(() => controller.uploadingLoading.value
            ? SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(
                  strokeWidth: .2,
                  backgroundColor: Colors.red,
                ),
              )
            : Icon(
                CupertinoIcons.mic,
                color: Colors.black,
              )).marginAll(8.sp),
      ),
    );
  }

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
              file, 'usersChat/${chatRoomId.toString()}', pickedFile.name)
          .then((value) {
        clearCounter();
        if (widget.counter != null) {
          widget.counter = widget.counter! + 1;
        } else {
          widget.counter = 1;
        }
        controller.sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: "",
            token: widget.user.user.information.deviceToken!,
            counter: widget.counter!,
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
              file, 'usersChat/${chatRoomId.toString()}', pickedFile.name)
          .then((value) {
        clearCounter();
        if (widget.counter != null) {
          widget.counter = widget.counter! + 1;
        } else {
          widget.counter = 1;
        }
        controller.sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: "",
            token: widget.user.user.information.deviceToken!,
            counter: widget.counter!,
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
              file, 'usersChat/${chatRoomId.toString()}', pickedFile.name)
          .then((value) {
        clearCounter();
        if (widget.counter != null) {
          widget.counter = widget.counter! + 1;
        } else {
          widget.counter = 1;
        }
        controller.sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: "",
            token: widget.user.user.information.deviceToken!,
            counter: widget.counter!,
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
              file, 'usersChat/${chatRoomId.toString()}', pickedFile.name)
          .then((value) {
        clearCounter();
        if (widget.counter != null) {
          widget.counter = widget.counter! + 1;
        } else {
          widget.counter = 1;
        }
        controller.sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: "",
            token: widget.user.user.information.deviceToken!,
            counter: widget.counter!,
            messageType: MessageType.audio,
            audioMessage: AudioMessage(
              audioUrl: value!,
              duration: fileSize.toString(),
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
              file, 'usersChat/${chatRoomId.toString()}', pickedFile.name)
          .then((value) {
        clearCounter();
        if (widget.counter != null) {
          widget.counter = widget.counter! + 1;
        } else {
          widget.counter = 1;
        }
        controller.sendMessage(
            chatRoomId: chatRoomId,
            receiverId: widget.user.user.information.id.toString(),
            message: "",
            token: widget.user.user.information.deviceToken!,
            counter: widget.counter!,
            messageType: MessageType.image,
            imageMessage: ImageMessage(
              imageUrl: value!,
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

  String formatDuration(Duration duration, String formatPattern) {
    final formatter = DateFormat(formatPattern);
    return formatter.format(DateTime(0, 0, 0, duration.inHours,
        duration.inMinutes % 60, duration.inSeconds % 60));
  }
}
