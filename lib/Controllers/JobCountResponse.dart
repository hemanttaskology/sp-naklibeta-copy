import 'dart:convert';

JobCountResponse JobCountResponseFromJson(String str) => JobCountResponse.fromJson(json.decode(str));

String JobCountResponseToJson(JobCountResponse data) => json.encode(data.toJson());

class JobCountResponse {
  JobCountResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  String message;
  int statusCode;
  int data;

  factory JobCountResponse.fromJson(Map<String, dynamic> json) => JobCountResponse(
    message: json["message"],
    statusCode: json["statusCode"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "statusCode": statusCode,
    "data": data,
  };
}