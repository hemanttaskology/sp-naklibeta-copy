import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServicesResponse {
  late String message;
  late int statusCode;
  late List<ServicesData> data;

  ServicesResponse(
      {required this.message, required this.statusCode, required this.data});

  ServicesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <ServicesData>[];
      json['data'].forEach((v) {
        data.add(new ServicesData.fromJson(v));
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
class ServicesData {
  late int id;
  late String name;
  late int subcategoryId;
  late String types;
  late String shortDesc;
  late int basePrice;
  late String photo;
  late bool status;
  late String subcategoryName;
  late String categoryName;

  ServicesData(
      {required this.id,
        required this.name,
        required this.subcategoryId,
        required this.types,
        required this.shortDesc,
        required this.basePrice,
        required this.photo,
        required this.status,
        required this.subcategoryName,
        required this.categoryName});

  ServicesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subcategoryId = json['subcategory_id'];
    types = json['types'];
    shortDesc = json['short_desc'];
    basePrice = json['base_price'];
    photo = json['photo'];
    status = json['status'];
    subcategoryName = json['subcategory_name'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subcategory_id'] = this.subcategoryId;
    data['types'] = this.types;
    data['short_desc'] = this.shortDesc;
    data['base_price'] = this.basePrice;
    data['photo'] = this.photo;
    data['status'] = this.status;
    data['subcategory_name'] = this.subcategoryName;
    data['category_name'] = this.categoryName;
    return data;
  }
}
