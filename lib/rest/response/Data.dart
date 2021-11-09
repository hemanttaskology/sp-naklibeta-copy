import 'package:json_annotation/json_annotation.dart';
import 'package:nakli_beta_service_provider/rest/request/Category.dart';

@JsonSerializable()
class Data {
  late var id;
  late String name;
  late String mobile;
  late String emailId;
  late String city;
  late String state;
  late String address;
  late List<Category> serviceCategory = [];
  late String token;
  late int status;
  late int loginStatus;
  late int userVerification;
  late String providerId;
  late String photo;
  late String degree;
  late String education;
  late String occupation;
  late String gstin;
  late String aadharCardFront;
  late String aadharCardBack;
  late String pancard;
  late String certificate;
  late String aboutUs;
  late String name1;
  late String mobile1;
  late String name2;
  late String mobile2;
  late String acName;
  late String bank;
  late String ifsc;
  late String branch;
  late String acNumber;
  late String trainingDate;
  late String trainingTime;
  late int trainingStatus;
  late String completeTime;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    emailId = json['emailId'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    if (json['serviceCategory'] != null) {
      serviceCategory = <Category>[];
      json['serviceCategory'].forEach((v) {
        serviceCategory.add(new Category.fromJson(v));
      });
    }
    token = json['token'];
    status = json['status'];
    loginStatus = json['loginStatus'];
    userVerification = json['userVerification'];
    providerId = json['providerId'];
    photo = json['photo'];
    degree = json['degree'];
    education = json['education'];
    occupation = json['occupation'];
    gstin=json['gstin'];
    aadharCardFront = json['aadharCardFront'];
    aadharCardBack = json['aadharCardBack'];
    pancard = json['pancard'];
    certificate = json['certificate'];
    aboutUs = json['aboutUs'];
    name1 = json['name1'];
    mobile1 = json['mobile1'];
    name2 = json['name2'];
    mobile2 = json['mobile2'];
    aboutUs = json['aboutUs'];
    acName = json['ac_name'];
    bank = json['bank'];
    ifsc = json['ifsc'];
    branch = json['branch'];
    acNumber = json['ac_number'];
    trainingDate = json['trainingDate'];
    trainingTime = json['trainingTime'];
    trainingStatus = json['trainingStatus'];
    completeTime = json['completeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['emailId'] = this.emailId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['address'] = this.address;
    data['serviceCategory'] =
        this.serviceCategory.map((v) => v.toJson()).toList();
    data['token'] = this.token;
    data['status'] = this.status;
    data['loginStatus'] = this.loginStatus;
    data['userVerification'] = this.userVerification;
    data['providerId'] = this.providerId;
    data['photo'] = this.photo;
    data['education'] = this.education;
    data['degree'] = this.degree;
    data['occupation'] = this.occupation;
    data['gstin']=this.gstin;
    data['aadharCardFront'] = this.aadharCardFront;
    data['aadharCardBack'] = this.aadharCardBack;
    data['pancard'] = this.pancard;
    data['certificate'] = this.certificate;
    data['aboutUs'] = this.aboutUs;
    data['name1'] = this.name1;
    data['mobile1'] = this.mobile1;
    data['name2'] = this.name2;
    data['mobile2'] = this.mobile2;
    data['aboutUs'] = this.aboutUs;
    data['ac_name'] = this.acName;
    data['bank'] = this.bank;
    data['ifsc'] = this.ifsc;
    data['branch'] = this.branch;
    data['ac_number'] = this.acNumber;
    data['trainingDate'] = this.trainingDate;
    data['trainingTime'] = this.trainingTime;
    data['trainingStatus'] = this.trainingStatus;
    data['completeTime'] = this.completeTime;
    return data;
  }

  List<String> getSelectedCategoryName() {
    List<String> selectedCategoryNameList = [];
    if (serviceCategory != null && serviceCategory.length > 0)
      serviceCategory.forEach((Category category) {
        selectedCategoryNameList.add(category.name);
      });
    return selectedCategoryNameList;
  }
}
