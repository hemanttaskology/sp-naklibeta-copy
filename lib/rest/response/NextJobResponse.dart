class NextJobResponse {
  late String message;
  late int statusCode;
  late NextJobData data;

  NextJobResponse(
      {required this.message, required this.statusCode, required this.data});

  NextJobResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data =
        (json['data'] != null ? new NextJobData.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.toJson();
    return data;
  }
}

class NextJobData {
  late String orderId;
  late int status;

  NextJobData({required this.orderId, required this.status});

  NextJobData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['status'] = this.status;
    return data;
  }
}
