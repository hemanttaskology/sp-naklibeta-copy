class QuotationResponse {
  late String message;
  late int statusCode;
  late QuotationData data;

  QuotationResponse(
      {required this.message, required this.statusCode, required this.data});

  QuotationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = (json['data'] != null
        ? new QuotationData.fromJson(json['data'])
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

class QuotationData {
  late String orderId;
  late String quotation;
  late String taxableAmount;
  late String taxAmount;
  late String providerCommission;
  late String companyCommission;
  late String totalAmount;
  late String taxPercentage;
  late int status;

  QuotationData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    quotation = json['quotation'];
    taxableAmount = json['taxable_amount'];
    taxAmount = json['tax_amount'];
    providerCommission = json['provider_commission'];
    companyCommission = json['company_commission'];
    totalAmount = json['total_amount'];
    taxPercentage = json['tax_percentage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['quotation'] = this.quotation;
    data['taxable_amount'] = this.taxableAmount;
    data['tax_amount'] = this.taxAmount;
    data['provider_commission'] = this.providerCommission;
    data['company_commission'] = this.companyCommission;
    data['total_amount'] = this.totalAmount;
    data['tax_percentage'] = this.taxPercentage;
    data['status'] = this.status;
    return data;
  }
}
