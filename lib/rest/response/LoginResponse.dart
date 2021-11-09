import 'package:json_annotation/json_annotation.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';

@JsonSerializable()
class LoginResponse {
  late String _message;
  late int _statusCode;
  late Data _data;

  LoginResponse(
      {required String message, required int statusCode, required Data data}) {
    this._message = message;
    this._statusCode = statusCode;
    this._data = data;
  }

  String get message => _message;
  set message(String message) => _message = message;
  int get statusCode => _statusCode;
  set statusCode(int statusCode) => _statusCode = statusCode;
  Data get data => _data;
  set data(Data data) => _data = data;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _statusCode = json['statusCode'];
    _data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['statusCode'] = this._statusCode;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}
