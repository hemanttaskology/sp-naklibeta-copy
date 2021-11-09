class BaseRequest {
  late BaseModel providerModel;

  BaseRequest({required this.providerModel});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    providerModel = (json['providerModel'] != null
        ? new BaseModel.fromJson(json['providerModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providerModel != null) {
      data['providerModel'] = this.providerModel.toJson();
    }
    return data;
  }
}

class BaseModel {
  late String providerId;

  BaseModel({required this.providerId});

  BaseModel.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    return data;
  }
}
