import 'package:dio/dio.dart';

class NotificationUpdateStatus {
  static const String BASE_URL = 'https://naklibeta.com/api/api/';
  static const String NOTIFICATION_UPDATE = BASE_URL + 'jobs/readNotification';

  static updateStatus(String providerId) async {
    var dio = Dio();
    Response response = await dio.post(NOTIFICATION_UPDATE, data: {
      "providerId": providerId,
    });
    return response.data;
  }
}
