class JobResponse {
  late String message;
  late int statusCode;
  late JobData data;

  JobResponse(
      {required this.message, required this.statusCode, required this.data});

  JobResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = (json['data'] != null ? new JobData.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['data'] = this.data.toJson();
    return data;
  }
}

class JobData {
  late int status;
  late int is_active;
  late List<Job> today;
  late List<Job> upcoming;
  late List<Job> category;

  JobData(
      {required this.today, required this.upcoming, required this.category});

  JobData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    is_active = json['is_active'];
    if (json['today'] != null) {
      today = <Job>[];
      json['today'].forEach((v) {
        today.add(new Job.fromJson(v));
      });
    }
    if (json['upcoming'] != null) {
      upcoming = <Job>[];
      json['upcoming'].forEach((v) {
        upcoming.add(new Job.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Job>[];
      json['category'].forEach((v) {
        category.add(new Job.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today'] = this.today.map((v) => v.toJson()).toList();
    data['upcoming'] = this.upcoming.map((v) => v.toJson()).toList();
    data['category'] = this.category.map((v) => v.toJson()).toList();
    data['status'] = this.status;
    data['is_active'] = this.is_active;

    return data;
  }
}

class Job {
  late int id;
  late int userId;
  late int serviceId;
  late int status;
  late String requirement;
  late String date;
  late int assignStatus;
  late String orderId;
  late DateTime dateTime;
  late String title;

  Job(
      {required this.id,
      required this.userId,
      required this.title,
      required this.serviceId,
      required this.status,
      required this.requirement,
      required this.date,
      required this.assignStatus,
      required this.orderId});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    status = json['status'];
    requirement = json['requirement'];
    date = json['date'];
    assignStatus = json['assign_status'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['requirement'] = this.requirement;
    data['date'] = this.date;
    data['assign_status'] = this.assignStatus;
    data['orderId'] = this.orderId;
    return data;
  }
}
