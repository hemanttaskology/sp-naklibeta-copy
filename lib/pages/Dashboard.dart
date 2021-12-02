import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/BottomNavigationController.dart';
import 'package:nakli_beta_service_provider/Controllers/MyJobCountController.dart';
import 'package:nakli_beta_service_provider/Controllers/NotificationController.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Globals.dart';
import 'package:nakli_beta_service_provider/pages/MyJobs.dart';
import 'package:nakli_beta_service_provider/pages/Notifications.dart';
import 'package:nakli_beta_service_provider/pages/Settings.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'Payments.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  int _selectedIndex = 0;
  String _title = "Home";
  bool activeUser = false;
  bool isFistimeLoad = true;
  // bool activeUser = false;
  final List pagesList = [
    Home(),
    MyJobs(),
    Payments(),
    Notifications(),
    Settings(),
  ];
  NotificationController notificationController =
  Get.put(NotificationController());
  MyJobCountController myJobCountController = Get.find();
  BottomNavigationController landingPageController =
  Get.put(BottomNavigationController(), permanent: false);
  @override
  void initState() {
    if(isFistimeLoad){
      getData();
      isFistimeLoad = false;
      Timer.periodic(Duration(seconds: 10), (Timer timer) {
        getData();
      });
    }else{
      Timer.periodic(Duration(seconds: 10), (Timer timer) {
        getData();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            icon: Icon(Icons.circle,
                size: 20,
                color: (activeUser ? Colors.green : Colors.grey.shade600)),
            label: Text(
              (activeUser ? "Active" : "Inactive"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              // Fluttertoast.showToast(
              //     msg: 'test',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     textColor: Colors.white,
              //     backgroundColor: Theme.of(context).accentColor,
              //     fontSize: 16.0);
              // showBanner();
            },
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset('images/action.png'),
        ),

        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.flutter_dash),
        // ),
        title:
            Text(_title, style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Center(
        child: pagesList[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homes',
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.account_circle),
                Obx(()=> Positioned(
                  right: 0,
                  child: myJobCountController.myJobCount.value>0?Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(7),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      myJobCountController.myJobCount.value.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ):Container(),
                ))
              ],
            ),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications),
                Obx(()=> Positioned(
                  right: 0,
                  child: notificationController.notifiCount.value>0?Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(7),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      notificationController.notifiCount.value.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ):Container(),
                ))
              ],
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Home';
            // getUserData();
          }
          break;
        case 1:
          {
            _title = 'My Jobs';
          }
          break;
        case 2:
          {
            _title = 'Payments';
          }
          break;
        case 3:
          {
            _title = 'Notification';

          }
          break;
        case 4:
          {
            _title = 'Settings';
          }
          break;
      }
    });
  }

  // Future<void> getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   Data userData = Data.fromJson(
  //       json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
  //
  //   if (userData != null && userData.providerId.isNotEmpty) {
  //     BaseRequest request = new BaseRequest(
  //         providerModel: new BaseModel(providerId: userData.providerId));
  //
  //     Utility.checkInternetConnection().then((internet) {
  //       if (internet) {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         APIManager apiManager = new APIManager();
  //         apiManager.refresh(request).then((value) async {
  //           RefreshResponse refreshResponse = value;
  //           if (refreshResponse.data != null)
  //             setState(() {
  //               userData.status = refreshResponse.data.status;
  //               prefs.setString(
  //                   AppConstants.USER_DETAIL, json.encode(userData));
  //               setState(() {
  //                 activeUser = refreshResponse.data.status == 1 ? true : false;
  //               });
  //             });
  //         }).onError((error, stackTrace) {});
  //       } else {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //               AppConstants.INTERNET_ERROR,
  //               style:
  //                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //             ),
  //             backgroundColor: Colors.red,
  //             duration: Duration(minutes: 10),
  //             action: SnackBarAction(
  //               label: 'REFRESH',
  //               onPressed: () {
  //                 getUserData();
  //               },
  //             ),
  //           ),
  //         );
  //       }
  //     });
  //   }
  // }
  //
  // snackBar(String? message, MaterialColor colors) {
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message!),
  //       backgroundColor: colors,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  showBanner() {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    return ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      backgroundColor: Colors.grey.shade300,
      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
      content: Text(
        activeUser
            ? 'Your profile is active.'
            : 'Your profile is pending. Please complete it from settings',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
      ),
      leading: Icon(
        Icons.info,
        color: Theme.of(context).primaryColor,
      ),
      actions: [
        TextButton(
          child: Text(
            'Ok',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
        ),
      ],
    ));
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    Data userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null) {
      Globals.providerId = userData.providerId;
      setState(() {
        activeUser = userData.is_active == 1 ? true : false;
      });
    }
  }
}
