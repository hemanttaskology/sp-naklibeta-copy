class MyJobResponse {
  late String message;
  late int statusCode;
  late List<MyJobData> data;

  MyJobResponse(
      {required this.message, required this.statusCode, required this.data});

  MyJobResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <MyJobData>[];
      json['data'].forEach((v) {
        data.add(new MyJobData.fromJson(v));
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

class MyJobData {
  late String id;
  late String title;
  late String detail;
  late String date;
  late int status;
  late String amount;
  late String details;
  late DateTime dateTime;

  MyJobData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    date = json['date'];
    status = json['status'];
    amount = json['amount'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['date'] = this.date;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['details'] = this.details;
    return data;
  }
}
