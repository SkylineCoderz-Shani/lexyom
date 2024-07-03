// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:lexyom/splash_screen.dart';

import 'constants/colors.dart';
import 'controllers/controller_payment.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1));
  PaymentsController controllerMakePayment = Get.put(PaymentsController());
  Stripe.publishableKey = PaymentsController.stripePublishableKey;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  colorConfig();
  runApp(const MyApp());
}

void colorConfig() {
  MaterialColor appPrimaryColor = MaterialColor(
    0xFFE3FF00,
    const <int, Color>{
      50: const Color(0xff39D27F),
      100: const Color(0xff39D27F),
      200: const Color(0xff39D27F),
      300: const Color(0xff39D27F),
      400: const Color(0xff39D27F),
      500: const Color(0xff39D27F),
      600: const Color(0xff39D27F),
      700: const Color(0xff39D27F),
      800: const Color(0xff39D27F),
      900: const Color(0xff39D27F),
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    checkNotificationPermission();
    super.initState();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("message: $message");

    if (message.data['type'] == 'chat') {}
  }

  void setupNotificationChannel() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const settingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final settingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null);
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? iOS = message.notification?.apple;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    icon: android.smallIcon,
                    enableVibration: true,
                    priority: Priority.max,
                    enableLights: true
                    // other properties...
                    ),
                iOS: DarwinNotificationDetails(
                  sound: iOS?.sound?.name,
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )));
      }
    });
  }

  void initNotificationChannel() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  void checkNotificationPermission() async {
    var settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setupInteractedMessage();
      initNotificationChannel();
      setupNotificationChannel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(
          320,
          812,
        ),
        minTextAdapt: true,
        fontSizeResolver: (fontSize, instance) {
          return fontSize * (instance.screenWidth / 360);
        },
        splitScreenMode: true,
        builder: (_, child) {
          return Portal(
            child: GetMaterialApp(
              supportedLocales: [
                Locale("af"),
                Locale("am"),
                Locale("ar"),
                Locale("az"),
                Locale("be"),
                Locale("bg"),
                Locale("bn"),
                Locale("bs"),
                Locale("ca"),
                Locale("cs"),
                Locale("da"),
                Locale("de"),
                Locale("el"),
                Locale("en"),
                Locale("es"),
                Locale("et"),
                Locale("fa"),
                Locale("fi"),
                Locale("fr"),
                Locale("gl"),
                Locale("ha"),
                Locale("he"),
                Locale("hi"),
                Locale("hr"),
                Locale("hu"),
                Locale("hy"),
                Locale("id"),
                Locale("is"),
                Locale("it"),
                Locale("ja"),
                Locale("ka"),
                Locale("kk"),
                Locale("km"),
                Locale("ko"),
                Locale("ku"),
                Locale("ky"),
                Locale("lt"),
                Locale("lv"),
                Locale("mk"),
                Locale("ml"),
                Locale("mn"),
                Locale("ms"),
                Locale("nb"),
                Locale("nl"),
                Locale("nn"),
                Locale("no"),
                Locale("pl"),
                Locale("ps"),
                Locale("pt"),
                Locale("ro"),
                Locale("ru"),
                Locale("sd"),
                Locale("sk"),
                Locale("sl"),
                Locale("so"),
                Locale("sq"),
                Locale("sr"),
                Locale("sv"),
                Locale("ta"),
                Locale("tg"),
                Locale("th"),
                Locale("tk"),
                Locale("tr"),
                Locale("tt"),
                Locale("uk"),
                Locale("ug"),
                Locale("ur"),
                Locale("uz"),
                Locale("vi"),
                Locale("zh")
              ],
              localizationsDelegates: [
                CountryLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              home: SplashScreen(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: "Arial",
                scaffoldBackgroundColor: Colors.white,
                primaryColor: appPrimaryColor,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: appPrimaryColor,
                  primary: appPrimaryColor,
                ),
                progressIndicatorTheme:
                    ProgressIndicatorThemeData(color: appPrimaryColor),
                appBarTheme: AppBarTheme(
                    color: Colors.white,
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: "Arial",
                      fontSize: 20.sp,
                    ),
                    elevation: 0),
                useMaterial3: false,
              ),

              // defaultTransition: Transition.fade,
              title: "Skorpio",
            ),
          );
        });
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

class NoColorScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

/// monthly
/// one_time
