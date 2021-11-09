class OTPVerificationRequest {
  late OTPVerificationModel _providerModel;

  OTPVerificationRequest({required OTPVerificationModel providerModel}) {
    this._providerModel = providerModel;
  }

  OTPVerificationModel get providerModel => _providerModel;
  set providerModel(OTPVerificationModel providerModel) =>
      _providerModel = providerModel;

  OTPVerificationRequest.fromJson(Map<String, dynamic> json) {
    _providerModel = (json['providerModel'] != null
        ? new OTPVerificationModel.fromJson(json['providerModel'])
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

class OTPVerificationModel {
  int _id = 0;
  int _otp = 0;
  int _loginStatus = 0;

  OTPVerificationModel(
      {required int id, required int otp, required int loginStatus}) {
    this._id = id;
    this._otp = otp;
    this._loginStatus = loginStatus;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get otp => _otp;
  set otp(int otp) => _otp = otp;
  int get loginStatus => _loginStatus;
  set loginStatus(int loginStatus) => _loginStatus = loginStatus;

  OTPVerificationModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _otp = json['otp'];
    _loginStatus = json['loginStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['otp'] = this._otp;
    data['loginStatus'] = this._loginStatus;
    return data;
  }
}
