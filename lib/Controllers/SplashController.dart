import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/SplashService.dart';

class SplashController extends GetxController{
  sendToken() async{
    try{
      await SplashService.updateToken();
    }catch(e){
      e.toString();
    }
  }
}