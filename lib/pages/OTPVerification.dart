import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/SplashController.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as Constants;
import 'package:nakli_beta_service_provider/common/Globals.dart';
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/Registration.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/OTPVerificationRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/OTPVerificationResponse.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class OTPVerification extends StatefulWidget {
  static const routeName = '/OTPVerification';

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController textEditingController = TextEditingController();
  static int otpLength = 4;
 SplashController splashController = Get.find();
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  String token = "";
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  late ScreenArguments args;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${args.data}",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 21)),
                      ],
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      length: otpLength,
                      obscureText: true,
                      // obscuringCharacter: '*',
                      // obscuringWidget: FlutterLogo(
                      //   size: 24,
                      // ),
                      blinkWhenObscuring: true,
                      autoFocus: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Theme.of(context).primaryColor,
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                      cursorColor: Colors.grey.shade600,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.grey,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {},
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "* Invalid OTP" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Didn't receive the code? ",
              //       style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              //     ),
              //     TextButton(
              //         onPressed: () => snackBar("OTP resend!!"),
              //         child: Text(
              //           "RESEND",
              //           style: TextStyle(
              //               color: Theme.of(context).buttonColor,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18),
              //         ))
              //   ],
              // ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != otpLength) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        verifyOtp(currentText);
                      }
                      // else if (currentText != "1234") {
                      //   errorController!.add(ErrorAnimationType
                      //       .shake); // Triggering error shake animation
                      //   setState(() => hasError = true);
                      // }
                      // else {
                      //   setState(
                      //     () {
                      //       hasError = false;
                      //       snackBar("OTP Verified!!");
                      //       openNextScreen();
                      //     },
                      //   );
                      // }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY OTP".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300, width: 2),

                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.green.shade200,
                  //       offset: Offset(1, -2),
                  //       blurRadius: 5),
                  //   BoxShadow(
                  //       color: Colors.green.shade200,
                  //       offset: Offset(-1, 2),
                  //       blurRadius: 5),
                  // ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                    child: Text("Clear",
                        style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void openNextScreen(OTPVerificationResponse otpVerificationResponse) async {
    if (otpVerificationResponse.data != null &&
        (otpVerificationResponse.data.emailId != null ||
            otpVerificationResponse.data.mobile != null)) {
      Data userData = otpVerificationResponse.data;

      bool userVerified = userData.userVerification == 1 ? true : false;
      bool loginStatus = userData.loginStatus == 1 ? true : false;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          AppConstants.USER_DETAIL, json.encode(otpVerificationResponse.data));
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: otpVerificationResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      if (loginStatus && userVerified) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool(Constants.LOGIN, true);
        bool login = prefs.getBool(Constants.LOGIN)!;
        if (login) {
          Globals.providerId = userData.providerId;
          getToken();
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          Dashboard.routeName,
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Registration.routeName,
          (Route<dynamic> route) => false,
          arguments: ScreenArguments(
            'TITLE',
            AppConstants.TITLE_REGISTRATION,
          ),
        );
      }
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: otpVerificationResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> verifyOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    Data loginResponse = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (loginResponse != null) {
      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          buildShowDialog(context);
          APIManager apiManager = new APIManager();
          OTPVerificationModel user = new OTPVerificationModel(
              otp: int.parse(otp),
              loginStatus: loginResponse.loginStatus,
              id: loginResponse.id);
          // print('request =>> ${user.toJson().toString()}');

          apiManager.verifyOTP(user).then((value) async {
            OTPVerificationResponse otpVerificationResponse = value;
            openNextScreen(otpVerificationResponse);
          }).onError((error, stackTrace) {
            print(error);
            Navigator.pop(context);
            snackBar(error.toString(), Colors.red);
          });
        } else {
          snackBar(AppConstants.INTERNET_ERROR, Colors.red);
        }
      });
    } else {
      snackBar(AppConstants.ERROR, Colors.red);
    }
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

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    Globals.token = token;
    splashController.sendToken();
  }
}
