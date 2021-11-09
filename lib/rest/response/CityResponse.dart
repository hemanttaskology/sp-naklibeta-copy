import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CityResponse {
  late String message;
  late int statusCode;
  late List<CityData> data;

  CityResponse(
      {required this.message, required this.statusCode, required this.data});

  CityResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <CityData>[];
      json['data'].forEach((v) {
        data.add(new CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@JsonSerializable()
class CityData {
  late int id;
  late String city;
  late int stateId;
  late int status;

  CityData(
      {required this.id,
      required this.city,
      required this.stateId,
      required this.status});

  CityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    stateId = json['stateId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['stateId'] = this.stateId;
    data['status'] = this.status;
    return data;
  }
}
