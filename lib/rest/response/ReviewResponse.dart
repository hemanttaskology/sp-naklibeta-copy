class ReviewResponse {
  late String message;
  late int statusCode;
  late List<ReviewData> data;

  ReviewResponse(
      {required this.message, required this.statusCode, required this.data});

  ReviewResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data.add(new ReviewData.fromJson(v));
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

class ReviewData {
  late String orderId;
  late int id;
  late int ratings;
  late String review;
  late int status;
  late String name;

  ReviewData(
      {required this.orderId,
      required this.id,
      required this.ratings,
      required this.review,
      required this.status,
      required this.name});

  ReviewData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    id = json['id'];
    ratings = json['ratings'];
    review = json['review'];
    status = json['status'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['id'] = this.id;
    data['ratings'] = this.ratings;
    data['review'] = this.review;
    data['status'] = this.status;
    data['name'] = this.name;
    return data;
  }
}
