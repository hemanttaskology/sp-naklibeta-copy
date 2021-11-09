class LoginRequest {
  late LoginModel _providerModel;

  LoginRequest({required LoginModel providerModel}) {
    _providerModel = providerModel;
  }

  LoginModel get providerModel => _providerModel;
  set providerModel(LoginModel providerModel) => _providerModel = providerModel;

  LoginRequest.fromJson(Map<String, dynamic> json) {
    _providerModel = (json['providerModel'] != null
        ? new LoginModel.fromJson(json['providerModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._providerModel != null) {
      data['providerModel'] = this._providerModel.toJson();
    }
    return data;
  }
}

class LoginModel {
  String _username = '';

  LoginModel({required String username}) {
    _username = username;
  }

  String get username => _username;
  set username(String username) => _username = username;

  LoginModel.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = _username;
    return data;
  }
}
