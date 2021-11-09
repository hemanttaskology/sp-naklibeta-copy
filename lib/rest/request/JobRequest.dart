class JobRequest {
  late OrderModel orderModel;

  JobRequest({required this.orderModel});

  JobRequest.fromJson(Map<String, dynamic> json) {
    orderModel = (json['orderModel'] != null
        ? new OrderModel.fromJson(json['orderModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderModel != null) {
      data['orderModel'] = this.orderModel.toJson();
    }
    return data;
  }
}

class OrderModel {
  late String providerId;

  OrderModel({required this.providerId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_id'] = this.providerId;
    return data;
  }
}
