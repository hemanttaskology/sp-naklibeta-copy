class FAQResponse {
  late String message;
  late int statusCode;
  late List<FAQData> data;

  FAQResponse(
      {required this.message, required this.statusCode, required this.data});

  FAQResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <FAQData>[];
      json['data'].forEach((v) {
        data.add(new FAQData.fromJson(v));
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

class FAQData {
  late int id;
  late String questions;
  late String answers;
  late int status;

  FAQData(
      {required this.id,
      required this.questions,
      required this.answers,
      required this.status});

  FAQData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questions = json['questions'];
    answers = json['answers'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['questions'] = this.questions;
    data['answers'] = this.answers;
    data['status'] = this.status;
    return data;
  }
}
