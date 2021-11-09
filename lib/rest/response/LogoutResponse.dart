import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LogoutResponse {
  late String message;
  late int statusCode;

  LogoutResponse({required this.message, required this.statusCode});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
