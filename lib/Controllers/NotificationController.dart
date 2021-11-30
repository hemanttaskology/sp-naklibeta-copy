import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/main.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/BaseRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/NotificationUpdateStatus.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/NotificationResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;

class NotificationController extends GetxController {
  List<NotificationData> notificationList = <NotificationData>[].obs;
  var notifiCount = 0.obs;
  late Timer timer;

  @override
  void onInit() {
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      getNotifications();
    });
    Timer.periodic(Duration(minutes: 15), (Timer timer) {
      showNotification();
    });
    super.onInit();
  }

  getNotifications() async {
    notificationList = [];
    final prefs = await SharedPreferences.getInstance();
    late Data userData;
    try{
      userData = Data.fromJson(
          json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    }catch(e){}
    if (userData != null && userData.providerId.isNotEmpty) {
      BaseRequest request = new BaseRequest(
          providerModel: new BaseModel(providerId: userData.providerId));

      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          APIManager apiManager = new APIManager();
          apiManager.notification(request).then((value) async {
            NotificationResponse response = value;
            if (response.data != null) {
              notificationList = response.data;
              notifiCount.value = notificationList
                  .where((element) => element.status == 0)
                  .length;
            }
          }).onError((error, stackTrace) {
            notifiCount.value = 0;
          });
        }
      });
    }
  }

  snackBar(String? message, MaterialColor colors) {
    return SnackBar(
      content: Text(message!),
      backgroundColor: colors,
      duration: Duration(seconds: 2),
    );
  }

  Future<void> showNotification() async {
    final prefs = await SharedPreferences.getInstance();
    Data userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));

    if (userData != null && userData.providerId.isNotEmpty) {
      BaseRequest request = new BaseRequest(
          providerModel: new BaseModel(providerId: userData.providerId));

      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          APIManager apiManager = new APIManager();
          apiManager.notification(request).then((value) async {
            NotificationResponse response = value;
            if (response.data != null) {
              notificationList.addAll(response.data);
              notifiCount.value = notificationList
                  .where((element) => element.status == 0)
                  .length;
              if (notifiCount.value > 0) {
                flutterLocalNotificationsPlugin.show(
                    0,
                    "NakliBeta",
                    "You have few messages unread in application,Please read.",
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
            }
          }).onError((error, stackTrace) {
            notifiCount.value = 0;
          });
        }
      });
    }
  }

  updateStatus(String providerId) async {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        var bookingResult = await NotificationUpdateStatus.updateStatus(providerId);
        if (bookingResult.responseCode == 200) {
        }
      } catch (e) {
        // Get.back();
        // showSnackBar(MyString.somethingWentWrong);
      }
    });
  }
}
