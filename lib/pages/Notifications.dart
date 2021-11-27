import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/NotificationController.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/JobDetails.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/BaseRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/NotificationResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  State<StatefulWidget> createState() {
    return NotificationsState();
  }
}

class NotificationsState extends State<Notifications> {
  late List<NotificationData> notificationList = [];
  bool isLoading = true;
  late Timer timer;
  bool isFistimeLoad = true;
  NotificationController notificationController = Get.find();
  @override
  initState(){
    if(isFistimeLoad){
      getNotifications();
      isFistimeLoad = false;
      timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
        getNotifications();
      });
    }else{
      timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
        getNotifications();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: (notificationList.length > 0
          ? ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: notificationList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    if(notificationList[index].url=="jobDetails"){
                      Get.to(JobDetails(
                                orderId: notificationList[index].pageId,
                              ));
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //     builder: (context) => JobDetails(
                      //                       //       orderId: notificationList[index].pageId,
                      //                       //     )))
                      //     .then((val) => val != null ? Navigator.pop(context, true) : null);
                    }
                  },
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text(
                              'Order ID : ' + notificationList[index].pageId,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Text(
                              'Date : ' + notificationList[index].date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Text(
                              notificationList[index].title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Theme.of(context).backgroundColor,
              ),
            )
          : Center(
              child: Container(),
            )),
    );
  }

  getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    Data userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null && userData.providerId.isNotEmpty) {
      BaseRequest request = new BaseRequest(
          providerModel: new BaseModel(providerId: userData.providerId));
      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          APIManager apiManager = new APIManager();
          apiManager.notification(request).then((value) async {
            NotificationResponse response = value;
            setState(() {
              isLoading = false;
              if (response.data != null) {
                notificationList = response.data;
                notificationController.updateStatus(userData.providerId);
              }
            });
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
            snackBar(error.toString(), Colors.red);
          });
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppConstants.INTERNET_ERROR,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
              duration: Duration(minutes: 10),
              action: SnackBarAction(
                label: 'REFRESH',
                onPressed: () {
                  getNotifications();
                },
              ),
            ),
          );
        }
      });
    }
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
