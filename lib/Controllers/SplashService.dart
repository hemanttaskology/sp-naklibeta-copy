import 'package:dio/dio.dart';
import 'package:nakli_beta_service_provider/common/Globals.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';

class SplashService {
  static String updateTokenUrl = "serviceprovider/update-device-token";

  static updateToken() async {
    var dio = Dio();
    Response response = await dio.post(APIManager.BASE_URL + updateTokenUrl,
      data: {"providerId": Globals.providerId,
        "device_token": Globals.token,
        "device_type": Globals.deviceType,
      },
      // options: Options(
      //     headers: {'jat': '${Globals.userToken}','jst': '${Globals.jst}','jpt': '${Globals.jpt}'}),
            );
    return response.data;
  }
}