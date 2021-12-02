import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/JobCountService.dart';

class MyJobCountController extends GetxController{
  var myJobCount = 0.obs;
  bool isFistimeLoad = true;
  @override
  void onInit() {
    if(isFistimeLoad){
      getJobCount();
      isFistimeLoad = false;
      Timer.periodic(Duration(seconds: 5), (Timer timer) {
        getJobCount();
      });
    }else{
      Timer.periodic(Duration(seconds: 5), (Timer timer) {
        getJobCount();
      });
    }
    super.onInit();
  }

  getJobCount() async {
    try{
      var result =  await JobCountService.getJobCount();
      if(result.statusCode==200){
        myJobCount.value = result.data;
      }
    }catch(e){
      myJobCount.value = 0;
    }
  }
}