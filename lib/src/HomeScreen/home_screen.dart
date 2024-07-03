import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../api_integration/authentication_APIServices/login_api_service.dart';
import '../../controllers/controller_getAll_notification.dart';
import '../../controllers/follow_controller.dart';
import '../../controllers/home_controllers.dart';
import '../CustomWidget/custom_bottomNavigationBar.dart';
import '../views/screen-community.dart';
import '../views/screen_askScorpio.dart';
import '../views/screen_profile.dart';
import 'HomeView/layout_notification.dart';
import 'HomeView/layout_user_chat_list.dart';
import 'HomeView/layout_user_home.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  void navigateToIndex(int index) {
    _HomeScreenState? state = _homeKey.currentState as _HomeScreenState?;
    state?.navigateToIndex(index);
  }
}

final GlobalKey<_HomeScreenState> _homeKey = GlobalKey<_HomeScreenState>();

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController = PageController();
  final tabs = [
    LayoutUserHome(),
    LayoutNotification(),
    ScreenCommunity(),
    LayoutUserChatList(),
    ScreenProfile(),
  ];

  ControllerHome controllerHome = Get.put(ControllerHome());
  Timer? _lastSeenTimer;
  FollowController followController = Get.put(FollowController());

  @override
  void initState() {
    super.initState();
    followController.fetchFollowRequests();

    WidgetsBinding.instance.addObserver(this);
    _startLastSeenTimer();
    // Simulate notification arrival for demonstration purposes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopLastSeenTimer();
    super.dispose();
  }

  void _startLastSeenTimer() {
    _lastSeenTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateLastSeen();
    });
  }

  void _stopLastSeenTimer() {
    _lastSeenTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startLastSeenTimer();
    } else if (state == AppLifecycleState.hidden) {
      _startLastSeenTimer();
    } else if (state == AppLifecycleState.inactive) {
      _startLastSeenTimer();
    } else if (state == AppLifecycleState.paused) {
      _startLastSeenTimer();
    } else {
      _stopLastSeenTimer();
    }
  }

  Future<void> updateLastSeen() async {
    String? accessToken = await LoginAPIService.getToken();
    const String endpoint =
        "https://skorpio.codergize.com/api/update_last_seen";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map<String, String> payload = {
      'last_seen': formattedDate,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: payload,
      );
      // log(response.body);
      if (response.statusCode != 200) {
        log('Failed to update Last Seen: ${response.statusCode}');
      } else {
        log('Last Seen updated successfully');
      }
    } catch (e) {
      log('Error updating Last Seen: $e');
    }
  }

  void navigateToIndex(int index) {
    setState(() {
      controllerHome.currentIndex.value = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    NotificationController notificationController =
        Get.put(NotificationController());
    controllerHome.fetchUserInfo();
    return Scaffold(
      key: _homeKey,
      body: Obx(() {
        return WillPopScope(
            onWillPop: () {
              if (controllerHome.currentIndex.value == 0) {
                return Future.value(false);
              } else {
                controllerHome.currentIndex.value = 0;
                return Future.value(true);
              }
            },
            child: tabs[controllerHome.currentIndex.value]);
      }),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavigationBar(
          selectedColor: Colors.white,
          backgroundColor: Colors.black,
          unselectedColor: Color(0xFF676666),
          currentIndex: controllerHome.currentIndex.value,
          hasNotification: notificationController.hasUnseenNotifications.value,
          onItemTapped: navigateToIndex,
          hasChatNotification: unReadMessages.isNotEmpty,
          hasRequestNotification: followController.followRequests.isNotEmpty,
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        return controllerHome.currentIndex == 3
            ? (controllerHome.user.value!.user.information.plan != "free"
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(ScreenAskScorpio());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.asset(
                        'assets/images/floating_btn.png',
                        width: 47.sp,
                        height: 47.sp,
                        fit: BoxFit.contain,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  )
                : SizedBox())
            : SizedBox();
      }),
    );
  }
}
