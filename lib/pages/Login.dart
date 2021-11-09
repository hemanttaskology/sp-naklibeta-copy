import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/LoginRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OTPVerification.dart';

class Login extends StatefulWidget {
  static const routeName = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  bool _validate = false;
  Future<LoginResponse>? userLogin;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).accentColor,
              height: 500,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Image(
                  image: AssetImage('images/splash_logo.png'),
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _text,
                style: TextStyle(color: Colors.grey.shade900),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Email ID / Phone Number',
                  hintText: 'Enter email id or phone number',
                  errorText:
                      _validate ? 'Invalid Email ID / Phone Number' : null,
                  labelStyle: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _validate = _text.text.toString().isEmpty ? true : false;
                    if (_text.text.isNotEmpty) {
                      if (validateEmail(_text.text) ||
                          validateMobile(_text.text)) {
                        _validate = false;
                        login(_text.text.toString());
                      } else {
                        _validate = true;
                      }
                    }
                  });
                },
                child: Text(
                  'LOGIN / SIGN UP',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(String username) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        LoginModel user = new LoginModel(username: username);
        apiManager.loginUser(user).then((value) async {
          LoginResponse loginResponse = value;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              AppConstants.USER_DETAIL, json.encode(loginResponse.data));
          Navigator.pop(context);
          // Fluttertoast.showToast(
          //     msg:
          //         "login status => ${loginResponse.data.loginStatus} and OTP => ${loginResponse.data.otp} ",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
          Navigator.pushNamed(
            context,
            OTPVerification.routeName,
            arguments: ScreenArguments(
              'DATA',
              _text.text,
            ),
          );
        }).onError((error, stackTrace) {
          print(error);
          Navigator.pop(context);
          snackBar(error.toString(), Colors.red);
        });
      } else {
        snackBar(AppConstants.INTERNET_ERROR, Colors.red);
      }
    });
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  snackBar(String? message, MaterialColor colors) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: colors,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

bool validateEmail(String value) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);
}
