import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nakli_beta_service_provider/Controllers/JobCountResponse.dart';
import 'package:nakli_beta_service_provider/common/Globals.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';

class JobCountService{
  static String jobCountUrl = "jobs/myJobsCount";
  static getJobCount() async {
    var dio = Dio();
    Response response = await dio.post(APIManager.BASE_URL + jobCountUrl,
      data: {"providerId": Globals.providerId,
      },
    );
    if (response.statusCode == 200) {
     return JobCountResponse.fromJson(jsonDecode(response.data));
    }
  }
}