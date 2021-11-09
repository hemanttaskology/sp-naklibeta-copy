class LogoutRequest {
  late LogOutModel providerModel;

  LogoutRequest({required this.providerModel});

  LogoutRequest.fromJson(Map<String, dynamic> json) {
    providerModel = (json['providerModel'] != null
        ? new LogOutModel.fromJson(json['providerModel'])
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

class LogOutModel {
  late String providerId;

  LogOutModel({required this.providerId});

  LogOutModel.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    return data;
  }
}
