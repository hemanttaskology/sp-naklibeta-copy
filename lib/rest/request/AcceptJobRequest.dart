class AcceptJobRequest {
  late OrderModel orderModel;

  AcceptJobRequest({required this.orderModel});

  AcceptJobRequest.fromJson(Map<String, dynamic> json) {
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
  late String orderId;

  OrderModel({required this.providerId, required this.orderId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_id'] = this.providerId;
    data['orderId'] = this.orderId;
    return data;
  }
}
