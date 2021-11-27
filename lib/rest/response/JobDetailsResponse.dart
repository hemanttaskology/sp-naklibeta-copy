class JobDetailsResponse {
  late String message;
  late int statusCode;
  late JobDetailData data;

  JobDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = (json['data'] != null
        ? new JobDetailData.fromJson(json['data'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.toJson();
    return data;
  }
}

class JobDetailData {
  late int id = -1;
  late String title;
  late String detail;
  late String date;
  late int status;
  late Quotations quotation;
  late String address;
  late String url;
  late String name;
  late String phone;
  late int taxPercentage;
  late int taxPercentage2;
  late int taxPercentage3;
  late int providerPercentage;
  late int taxStatus;

  JobDetailData();

  JobDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    date = json['date'];
    status = json['status'];
    quotation = (json['quotation'] != null
        ? new Quotations.fromJson(json['quotation'])
        : null)!;
    address = json['address'];
    url = json['url'];
    name = json['customerName'];
    phone = json['mobile'];
    taxPercentage = json['taxPercentage'];
    taxPercentage2 = json['taxPercentage2'];
    taxPercentage3 = json['taxPercentage3'];
    providerPercentage = json['providerPercentage'];
    taxStatus=json['taxStatus'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['date'] = this.date;
    data['status'] = this.status;
    if (this.quotation != null) {
      data['quotation'] = this.quotation.toJson();
    }
    data['address'] = this.address;
    data['url'] = this.url;
    data['taxPercentage'] = this.taxPercentage;
    data['providerPercentage'] = this.providerPercentage;
    data['taxStatus']=this.taxStatus;
    return data;
  }
}

class Quotations {
  late String amount;
  late String taxable_amount;
  late String details;

  Quotations.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    taxable_amount = json['taxable_amount'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['taxable_amount'] = this.taxable_amount;
    data['details'] = this.details;
    return data;
  }
}
