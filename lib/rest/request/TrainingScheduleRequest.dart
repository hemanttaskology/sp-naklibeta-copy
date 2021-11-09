class TrainingScheduleRequest {
  late TrainingModel trainingModel;

  TrainingScheduleRequest({required this.trainingModel});

  TrainingScheduleRequest.fromJson(Map<String, dynamic> json) {
    trainingModel = (json['trainingModel'] != null
        ? new TrainingModel.fromJson(json['trainingModel'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trainingModel != null) {
      data['trainingModel'] = this.trainingModel.toJson();
    }
    return data;
  }
}

class TrainingModel {
  late String providerId;
  late String date;
  late String time;

  TrainingModel(
      {required this.providerId, required this.date, required this.time});

  TrainingModel.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
