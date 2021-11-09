class ProfileRequest {
  late ProfileModel providerModel;

  ProfileRequest({required this.providerModel});

  ProfileRequest.fromJson(Map<String, dynamic> json) {
    providerModel = (json['providerModel'] != null
        ? new ProfileModel.fromJson(json['providerModel'])
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

class ProfileModel {
  late int id;
  late String name;
  late String emailId;
  late String mobile;
  late String city;
  late String state;
  late String address;
  late String occupation;
  late String education;
  late String aboutUs;
  late String degree;
  late List<Map> serviceCategory;

  ProfileModel(
      {required this.id,
      required this.name,
      required this.emailId,
      required this.mobile,
      required this.city,
      required this.state,
      required this.address,
      required this.occupation,
      required this.education,
      required this.aboutUs,
      required this.degree,
      required this.serviceCategory});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emailId = json['emailId'];
    mobile = json['mobile'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    occupation = json['occupation'];
    education = json['education'];
    aboutUs = json['aboutUs'];
    degree = json['degree'];
    serviceCategory = json['serviceCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['state'] = this.state;
    data['address'] = this.address;
    data['occupation'] = this.occupation;
    data['education'] = this.education;
    data['aboutUs'] = this.aboutUs;
    data['degree'] = this.degree;
    data['serviceCategory'] = this.serviceCategory;
    return data;
  }
}
