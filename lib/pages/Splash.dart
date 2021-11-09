import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as Constants;
import 'package:nakli_beta_service_provider/pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class Splash extends StatefulWidget {
  static const routeName = 'splash';

  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool login = false, personalDetail = false;

  @override
  void initState() {
    super.initState();
    isUserLoggedIn();
    Timer(
      Duration(seconds: 2),
      () => Navigator.popAndPushNamed(
        context,
        (login ? Dashboard.routeName : Login.routeName),
      ),
    );
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
    final prefs = await SharedPreferences.getInstance();
    login = prefs.getBool(Constants.LOGIN)!;
  }
}
