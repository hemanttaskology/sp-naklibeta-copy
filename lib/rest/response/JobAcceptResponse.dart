class JobAcceptResponse {
  late String message;
  late int statusCode;
  late JobAcceptData data;

  JobAcceptResponse(
      {required this.message, required this.statusCode, required this.data});

  JobAcceptResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = (json['data'] != null
        ? new JobAcceptData.fromJson(json['data'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class JobAcceptData {
  late int id;
  late String userName;
  late String mobile;
  late String address;
  late String serviceName;
  late String requirement;
  late String date;
  late int status;

  JobAcceptData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    mobile = json['mobile'];
    address = json['address'];
    serviceName = json['serviceName'];
    requirement = json['requirement'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['serviceName'] = this.serviceName;
    data['requirement'] = this.requirement;
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}
