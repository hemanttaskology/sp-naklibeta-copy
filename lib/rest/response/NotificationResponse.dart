class NotificationResponse {
  late String message;
  late int statusCode;
  late List<NotificationData> data;

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class NotificationData {
  late String title;
  late String orderId;
  late String date;

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    orderId = json['orderId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['orderId'] = this.orderId;
    data['date'] = this.date;
    return data;
  }
}
