class ReferenceRequest {
  late Reference reference;

  ReferenceRequest({required this.reference});

  ReferenceRequest.fromJson(Map<String, dynamic> json) {
    reference = (json['reference'] != null
        ? new Reference.fromJson(json['reference'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reference != null) {
      data['reference'] = this.reference.toJson();
    }
    return data;
  }
}

class Reference {
  late String providerId;
  late String name1;
  late String mobile1;
  late String name2;
  late String mobile2;

  Reference(
      {required this.providerId,
      required this.name1,
      required this.mobile1,
      required this.name2,
      required this.mobile2});

  Reference.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    name1 = json['name1'];
    mobile1 = json['mobile1'];
    name2 = json['name2'];
    mobile2 = json['mobile2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    data['name1'] = this.name1;
    data['mobile1'] = this.mobile1;
    data['name2'] = this.name2;
    data['mobile2'] = this.mobile2;
    return data;
  }
}
