import 'package:json_annotation/json_annotation.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';

@JsonSerializable()
class OTPVerificationResponse {
  late String message;
  late int statusCode;
  late Data data;

  OTPVerificationResponse(
      {required this.message, required this.statusCode, required this.data});

  OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
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
