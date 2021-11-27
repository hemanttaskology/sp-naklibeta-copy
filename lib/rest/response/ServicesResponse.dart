// To parse this JSON data, do
//
//     final servicesResponse = servicesResponseFromJson(jsonString);

import 'dart:convert';

ServicesResponse servicesResponseFromJson(String str) => ServicesResponse.fromJson(json.decode(str));

String servicesResponseToJson(ServicesResponse data) => json.encode(data.toJson());

class ServicesResponse {
  ServicesResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  String message;
  int statusCode;
  List<Service> data;

  factory ServicesResponse.fromJson(Map<String, dynamic> json) => ServicesResponse(
    message: json["message"],
    statusCode: json["statusCode"],
    data: List<Service>.from(json["data"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "statusCode": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Service {
  Service({
    required this.subCateName,
    required this.subCateId,
    required this.serviceDetails,
  });

  String subCateName;
  int subCateId;
  List<ServiceDetail> serviceDetails;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    subCateName: json["subCateName"],
    subCateId: json["subCateId"],
    serviceDetails: List<ServiceDetail>.from(json["serviceDetails"].map((x) => ServiceDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subCateName": subCateName,
    "subCateId": subCateId,
    "serviceDetails": List<dynamic>.from(serviceDetails.map((x) => x.toJson())),
  };
}

class ServiceDetail {
  ServiceDetail({
    required this.name,
    required this.id,
  });

  String name;
  int id;

  factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
