import 'dart:io';

class KycRequest {
  late String providerId;
  late File aadharFront;
  late File aadharBack;
  late File panCard;
  late String name;
  late String bankName;
  late String ifsc;
  late String branchName;
  late String acNumber;
  late String gstin;

  KycRequest(
      {required this.providerId,
      required this.aadharFront,
      required this.aadharBack,
      required this.panCard,
      required this.name,
      required this.bankName,
      required this.ifsc,
      required this.branchName,
      required this.acNumber,
      required this.gstin});

  KycRequest.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    aadharFront = json['aadharFront'];
    aadharBack = json['aadharBack'];
    panCard = json['panCard'];
    name = json['name'];
    bankName = json['bankName'];
    ifsc = json['ifsc'];
    branchName = json['branchName'];
    acNumber = json['acNumber'];
    gstin = json['gstin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    data['aadharFront'] = this.aadharFront;
    data['aadharBack'] = this.aadharBack;
    data['panCard'] = this.panCard;
    data['name'] = this.name;
    data['bankName'] = this.bankName;
    data['ifsc'] = this.ifsc;
    data['branchName'] = this.branchName;
    data['acNumber'] = this.acNumber;
    data['gstin'] = this.gstin;
    return data;
  }
}
