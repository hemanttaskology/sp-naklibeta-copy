import 'package:nakli_beta_service_provider/rest/request/Category.dart';

class RegistrationRequest {
  late RegistrationModel providerModel;

  RegistrationRequest({required this.providerModel});

  RegistrationRequest.fromJson(Map<String, dynamic> json) {
    providerModel = (json['providerModel'] != null
        ? new RegistrationModel.fromJson(json['providerModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providerModel != null) {
      data['providerModel'] = this.providerModel.toJson();
    }
    return data;
  }
}

class RegistrationModel {
  late int id;
  late String name;
  late String emailId;
  late String mobile;
  late String address;
  late String city;
  late String cityId;
  late String state;
  late String stateId;
  late List<Category> serviceCategory = [];

  RegistrationModel(
      {required this.id,
      required this.name,
      required this.emailId,
      required this.mobile,
      required this.address,
      required this.city,
      required this.cityId,
      required this.state,
      required this.stateId,
      required this.serviceCategory});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emailId = json['emailId'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    cityId = json['cityId'];
    state = json['state'];
    stateId = json['stateId'];
    if (json['serviceCategory'] != null) {
      serviceCategory = <Category>[];
      json['serviceCategory'].forEach((v) {
        serviceCategory.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['city'] = this.city;
    data['cityId'] = this.cityId;
    data['state'] = this.state;
    data['stateId'] = this.stateId;
    data['serviceCategory'] =
        this.serviceCategory.map((v) => v.toJson()).toList();
    return data;
  }
}
