import 'Data.dart';

class BaseResponse {
  late String message;
  late int statusCode;
  late Data data;

  BaseResponse(
      {required this.message, required this.statusCode, required this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.toJson();
    return data;
  }
}
