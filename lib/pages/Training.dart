import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/TrainingScheduleRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Training extends StatefulWidget {
  static const routeName = '/training';
  @override
  State<StatefulWidget> createState() {
    return TrainingState();
  }
}

class TrainingState extends State<Training> {
  late Data userData;
  String phoneNumber = '', name = '', email = '', date = '', time = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      //initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      lastDate: DateTime(2050),
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      // selectableDayPredicate: (date) {
      //   // Disable weekend days to select from the calendar
      //   if (date.weekday == 6 || date.weekday == 7) {
      //     return false;
      //   }
      //   return true;
      // },
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        date = formatDate(picked, [dd, '-', mm, '-', yyyy]);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        time = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    setState(() {
      name = "Name: " + userData.name;
      email = "Email ID: " + userData.emailId;
      phoneNumber = "Phone Number: " + userData.mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    // make widget
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Schedule Training",
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: (SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30, 10, 0),
                child: Text(name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                child: Text(email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                child: Text(phoneNumber,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 60, 10, 0),
                child: Text("Schedule:",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: ListTile(
                    onTap: () {
                      _selectDate(context);
                    },
                    trailing: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey.shade700,
                    ),
                    title: Text(
                      'Preferred Date: ' + date,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: ListTile(
                    onTap: () {
                      _selectTime(context);
                    },
                    trailing: Icon(
                      Icons.watch_later_outlined,
                      color: Colors.grey.shade700,
                    ),
                    title: Text(
                      'Preferred Time: ' + time,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
                      if (date != null &&
                          time != null &&
                          date.isNotEmpty &&
                          time.isNotEmpty) {
                        _showMyDialog();
                      } else {
                        snackBar("Please select preferred date and time",
                            Colors.red);
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Text('Your preferred date is ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          )),
                      Text(date,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(' and preferred time is ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          )),
                      Text(time,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  submitSchedule(new TrainingModel(
                      providerId: userData.providerId, date: date, time: time));
                },
              ),
              TextButton(
                child: Text('Cancel',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void submitSchedule(TrainingModel trainingModel) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.trainingSchedule(trainingModel).then((value) async {
          Navigator.pop(context);
          BaseResponse baseResponse = value;
          if (baseResponse.data != null) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(
                AppConstants.USER_DETAIL, json.encode(baseResponse.data));
          }

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
}
