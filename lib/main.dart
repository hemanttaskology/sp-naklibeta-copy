// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/localization/form_builder_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/MyJobCountController.dart';
import 'package:nakli_beta_service_provider/Controllers/NotificationController.dart';
import 'package:nakli_beta_service_provider/pages/Dashboard.dart';
import 'package:nakli_beta_service_provider/pages/HelpAndSupport.dart';
import 'package:nakli_beta_service_provider/pages/Home.dart';
import 'package:nakli_beta_service_provider/pages/JobDetails.dart';
import 'package:nakli_beta_service_provider/pages/JobList.dart';
import 'package:nakli_beta_service_provider/pages/Login.dart';
import 'package:nakli_beta_service_provider/pages/MyJobs.dart';
import 'package:nakli_beta_service_provider/pages/Notifications.dart';
import 'package:nakli_beta_service_provider/pages/OTPVerification.dart';
import 'package:nakli_beta_service_provider/pages/Payments.dart';
import 'package:nakli_beta_service_provider/pages/PaymentsComplete.dart';
import 'package:nakli_beta_service_provider/pages/PaymentsPending.dart';
import 'package:nakli_beta_service_provider/pages/ProfileQualification.dart';
import 'package:nakli_beta_service_provider/pages/Quotation.dart';
import 'package:nakli_beta_service_provider/pages/References.dart';
import 'package:nakli_beta_service_provider/pages/Registration.dart';
import 'package:nakli_beta_service_provider/pages/Reviews.dart';
import 'package:nakli_beta_service_provider/pages/SearchPage.dart';
import 'package:nakli_beta_service_provider/pages/SelectCategoryPage.dart';
import 'package:nakli_beta_service_provider/pages/Settings.dart';
import 'package:nakli_beta_service_provider/pages/Splash.dart';
import 'package:nakli_beta_service_provider/pages/Training.dart';
import 'package:nakli_beta_service_provider/pages/UserKYC.dart';
import 'package:nakli_beta_service_provider/theme/custom_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          playSound: true,
          icon: "@mipmap/ic_launcher",
        ),
      ));
}

// /// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  // playSound: true,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// /// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
// BehaviorSubject<ReceivedNotification>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  /// We use this channel in the `Android`Manifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MyJobCountController jobCountController = Get.put(MyJobCountController());
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    localizationsDelegates: [
      FormBuilderLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', ''),
    ],
    home: Splash(),
    routes: <String, WidgetBuilder>{
      Splash.routeName: (context) => new Splash(),
      Login.routeName: (context) => new Login(),
      OTPVerification.routeName: (context) => new OTPVerification(),
      Registration.routeName: (context) => Registration(),
      Dashboard.routeName: (context) => Dashboard(),
      Home.routeName: (context) => Home(),
      MyJobs.routeName: (context) => MyJobs(),
      Notifications.routeName: (context) => Notifications(),
      Settings.routeName: (context) => Settings(),
      ProfileQualification.routeName: (context) => ProfileQualification(),
      UserKyc.routeName: (context) => UserKyc(),
      References.routeName: (context) => References(),
      Training.routeName: (context) => Training(),
      Payments.routeName: (context) => Payments(),
      HelpAndSupport.routeName: (context) => HelpAndSupport(),
      Reviews.routeName: (context) => Reviews(),
      JobDetails.routeName: (context) => JobDetails(
            orderId: '',
          ),
      Quotation.routeName: (context) => Quotation(
            orderId: '',
            detail: '',
            preferredDate: '',
            taxPercentage: 0,
            providerPercentage: 0,
            updateQuotation: false,
          ),
      JobList.routeName: (context) => JobList(
            title: '',
            dataList: [],
          ),
      PaymentsComplete.routeName: (context) => PaymentsComplete(),
      PaymentsPending.routeName: (context) => PaymentsPending(),
      SearchCategoryPage.routeName: (context) => SearchCategoryPage(
            title: '',
            dataList: [],
          ),
      SearchSelectPage.routeName: (context) => SearchSelectPage(
            title: '',
            dataList: [],
            isRadioSelected: -1,
          ),
    },
  ));
}
/*
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
 */
