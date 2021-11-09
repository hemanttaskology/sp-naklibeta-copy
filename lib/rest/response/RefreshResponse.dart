class RefreshResponse {
  late String message;
  late int statusCode;
  late RefreshData data;

  RefreshResponse(
      {required this.message, required this.statusCode, required this.data});

  RefreshResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data =
        (json['data'] != null ? new RefreshData.fromJson(json['data']) : null)!;
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

class RefreshData {
  late int status;

  RefreshData({required this.status});

  RefreshData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
