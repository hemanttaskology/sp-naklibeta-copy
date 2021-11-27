class QuotationRequest {
  late Quotations orderModel;

  QuotationRequest({required this.orderModel});

  QuotationRequest.fromJson(Map<String, dynamic> json) {
    orderModel = (json['orderModel'] != null
        ? new Quotations.fromJson(json['orderModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderModel != null) {
      data['orderModel'] = this.orderModel.toJson();
    }
    return data;
  }
}

class Quotations {
  late String orderId;
  late String quotation;
  late String amount;
  late String gst;
  late String sgst;
  late String igst;
  late bool taxType;

  Quotations(
      {required this.orderId, required this.quotation, required this.amount, required this.gst, required this.sgst,required this.igst,required this.taxType});

  Quotations.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    quotation = json['quotation'];
    amount = json['amount'];
    gst = json['gst'];
    sgst=json['sgst'];
    igst=json['igst'];
    taxType=json['taxType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['quotation'] = this.quotation;
    data['amount'] = this.amount;
    data['gst']=this.gst;
    data['sgst']=this.sgst;
    data['igst']=this.igst;
    data['taxType']=this.taxType;
    return data;
  }
}
