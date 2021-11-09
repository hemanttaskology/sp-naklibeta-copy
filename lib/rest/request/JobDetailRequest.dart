class JobDetailRequest {
  late JobDetailModel orderModel;

  JobDetailRequest({required this.orderModel});

  JobDetailRequest.fromJson(Map<String, dynamic> json) {
    orderModel = (json['orderModel'] != null
        ? new JobDetailModel.fromJson(json['orderModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderModel'] = this.orderModel.toJson();
    return data;
  }
}

class JobDetailModel {
  late String orderId;

  JobDetailModel({required this.orderId});

  JobDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    return data;
  }
}
