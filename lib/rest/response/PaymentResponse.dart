class PaymentResponse {
  late String message;
  late int statusCode;
  late List<Payment> data;

  PaymentResponse(
      {required this.message, required this.statusCode, required this.data});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Payment>[];
      json['data'].forEach((v) {
        data.add(new Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  late int status;
  late String orderId;
  late int totalAmount;
  late String date;
  late int yourEarning;

  Payment(
      {required this.status,
      required this.orderId,
      required this.totalAmount,
      required this.date,
      required this.yourEarning});

  Payment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['orderId'];
    totalAmount = json['total_amount'];
    date = json['date'];
    yourEarning = json['yourEarning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    data['date'] = this.date;
    data['yourEarning'] = this.yourEarning;
    return data;
  }
}
