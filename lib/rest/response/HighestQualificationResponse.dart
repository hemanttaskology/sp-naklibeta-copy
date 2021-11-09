class HighestQualificationResponse {
  late String message;
  late int statusCode;
  late List<HighestQualificationData> data;

  HighestQualificationResponse(
      {required this.message, required this.statusCode, required this.data});

  HighestQualificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <HighestQualificationData>[];
      json['data'].forEach((v) {
        data.add(new HighestQualificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class HighestQualificationData {
  late int id;
  late String name;

  HighestQualificationData({required this.id, required this.name});

  HighestQualificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
