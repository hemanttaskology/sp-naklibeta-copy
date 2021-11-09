import 'dart:io';

class QualificationRequest {
  late String providerId;
  late String education;
  late String degree;
  late String aboutUs;
 // late File profilePhoto;
  late File certificate;
  late String occupation;
  late String gstin;

  QualificationRequest(
      {required this.occupation,
      required this.providerId,
      //required this.profilePhoto,
      required this.education,
      required this.aboutUs,
      required this.degree,
      required this.certificate,
      required this.gstin,
      });

  QualificationRequest.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    occupation = json['occupation'];
    education = json['education'];
    aboutUs = json['aboutUs'];
    degree = json['degree'];
   // profilePhoto = json['profilePhoto'];
    certificate = json['certificate'];
    gstin = json['gstin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    data['occupation'] = this.occupation;
    data['education'] = this.education;
    data['aboutUs'] = this.aboutUs;
    data['degree'] = this.degree;
   // data['profilePhoto'] = this.profilePhoto;
    data['certificate'] = this.certificate;
    data['gstin']=this.gstin;
    return data;
  }
}
