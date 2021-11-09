import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/ReferenceRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class References extends StatefulWidget {
  static const routeName = '/references';
  @override
  State<StatefulWidget> createState() {
    return ReferencesState();
  }
}

class ReferencesState extends State<References> {
  late Data userData;

  final _textNamePerson1 = TextEditingController();
  final _textPhoneNumberPerson1 = TextEditingController();
  bool validateNamePerson1 = false;
  bool validatePhoneNumberPerson1 = false;

  final _textNamePerson2 = TextEditingController();
  final _textPhoneNumberPerson2 = TextEditingController();
  bool validateNamePerson2 = false;
  bool validatePhoneNumberPerson2 = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null) {
      _textNamePerson1.value =
          _textNamePerson1.value.copyWith(text: userData.name1);
      _textPhoneNumberPerson1.value =
          _textPhoneNumberPerson1.value.copyWith(text: userData.mobile1);
      _textNamePerson2.value =
          _textNamePerson2.value.copyWith(text: userData.name2);
      _textPhoneNumberPerson2.value =
          _textPhoneNumberPerson2.value.copyWith(text: userData.mobile2);

    }
  }

  @override
  Widget build(BuildContext context) {
    // make widget
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("References",
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: (SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),
                    Text(
                      'Person 1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (Colors.black),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: _textNamePerson1,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name ',
                    errorText: validateNamePerson1 ? 'Name is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: _textPhoneNumberPerson1,
                  maxLength: 10,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter Phone Number',
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).disabledColor, width: 2.0),
                    ),
                    errorText: validatePhoneNumberPerson1
                        ? 'Invalid Phone Number'
                        : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),
                    Text(
                      'Person 2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (Colors.black),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: _textNamePerson2,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter Name ',
                    errorText: validateNamePerson2 ? 'Name is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: _textPhoneNumberPerson2,
                  maxLength: 10,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter Phone Number',
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).disabledColor, width: 2.0),
                    ),
                    errorText: validatePhoneNumberPerson2
                        ? 'Invalid Phone Number'
                        : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        validateNamePerson1 =
                            _textNamePerson1.text.toString().isEmpty
                                ? true
                                : false;

                        validatePhoneNumberPerson1 = (_textPhoneNumberPerson1
                                    .text
                                    .toString()
                                    .isNotEmpty &&
                                validateMobile(
                                    _textPhoneNumberPerson1.text.toString()))
                            ? false
                            : true;

                        validateNamePerson2 =
                            _textNamePerson2.text.toString().isEmpty
                                ? true
                                : false;

                        validatePhoneNumberPerson2 = (_textPhoneNumberPerson2
                                    .text
                                    .toString()
                                    .isNotEmpty &&
                                validateMobile(
                                    _textPhoneNumberPerson2.text.toString()))
                            ? false
                            : true;
                      });
                      if (_textNamePerson1.text.toString().isNotEmpty &&
                          _textPhoneNumberPerson1.text.toString().isNotEmpty &&
                          validateMobile(
                              _textPhoneNumberPerson1.text.toString()) &&
                          _textNamePerson2.text.toString().isNotEmpty &&
                          _textPhoneNumberPerson2.text.toString().isNotEmpty &&
                          validateMobile(
                              _textPhoneNumberPerson2.text.toString())) {
                        Reference reference = new Reference(
                            providerId: userData.providerId,
                            name1: _textNamePerson1.text,
                            name2: _textNamePerson2.text,
                            mobile1: _textPhoneNumberPerson1.text,
                            mobile2: _textPhoneNumberPerson2.text);
                        submitReferences(reference);
                      }
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void submitReferences(Reference reference) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.reference(reference).then((value) async {
          Navigator.pop(context);
          BaseResponse baseResponse = value;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              AppConstants.USER_DETAIL, json.encode(baseResponse.data));
          Fluttertoast.showToast(
              msg: baseResponse.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              fontSize: 16.0);
          Navigator.pop(context, true);
        }).onError((error, stackTrace) {
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

  bool validateMobile(String value) {
    String pattern = r'([0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
