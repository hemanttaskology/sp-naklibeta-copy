class DeclineRequest {
  late DeclineModel orderModel;

  DeclineRequest({required this.orderModel});

  DeclineRequest.fromJson(Map<String, dynamic> json) {
    orderModel = (json['orderModel'] != null
        ? new DeclineModel.fromJson(json['orderModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderModel'] = this.orderModel.toJson();
    return data;
  }
}

class DeclineModel {
  late String orderId;
  late String providerId;

  DeclineModel({required this.orderId, required this.providerId});

  DeclineModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    providerId = json['providerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['providerId'] = this.providerId;
    return data;
  }
}
