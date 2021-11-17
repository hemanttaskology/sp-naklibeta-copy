import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/SplashController.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as Constants;
import 'package:nakli_beta_service_provider/common/Globals.dart';
import 'package:nakli_beta_service_provider/pages/Login.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
as AppConstants;
import '../main.dart';
import 'Dashboard.dart';

class Splash extends StatefulWidget {
  static const routeName = 'splash';

  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashController splashController = Get.put(SplashController());
  bool login = false, personalDetail = false;
  late String token;
  late Data userData;
  late SharedPreferences prefs;
  @override
  initState() {
    super.initState();
    if (Platform.isIOS) {
      Globals.deviceType = "ios";
    }else{
      Globals.deviceType = "android";
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((var message) {
      if (message != null) {
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                playSound: true,
                // sound: ,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });
    isUserLoggedIn();
    Timer(
      Duration(seconds: 2),
      () => Navigator.popAndPushNamed(
        context,
        (login ? Dashboard.routeName : Login.routeName),
      ),
    );
  }

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    Globals.token = token;
    splashController.sendToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Image(
            image: AssetImage('images/splash_logo.png'),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ));
  }

  isUserLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    login = prefs.getBool(Constants.LOGIN)!;
    if(login){
      userData = Data.fromJson(
          json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
      Globals.providerId = userData.providerId;
      getToken();
    }
  }
}
