import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:nakli_beta_service_provider/rest/request/AcceptJobRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/BaseRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/JobDetailRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/JobRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/KycRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/LoginRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/QualificationRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/QuotationRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/ReferenceRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/TrainingScheduleRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/UpdatePersonalDetailsRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/FAQResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/HighestQualificationResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/JobAcceptResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/JobDetailsResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/JobResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/LogoutResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/MyJobResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/NextJobResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/NotificationResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/PaymentResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/ProfileResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/QuotationResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/RefreshResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/RegistrationResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/ReviewResponse.dart';

import 'CustomException.dart';
import 'request/DeclineRequest.dart';
import 'request/LoginRequest.dart';
import 'request/LogoutRequest.dart';
import 'request/OTPVerificationRequest.dart';
import 'request/ProfileRequest.dart';
import 'request/RegistrationRequest.dart';
import 'response/BaseResponse.dart';
import 'response/CityResponse.dart';
import 'response/LoginResponse.dart';
import 'response/OTPVerificationResponse.dart';
import 'response/ServicesResponse.dart';

class APIManager {
  //dev url
  // static const String BASE_URL = 'https://jobbanko.com/api/api/';

  //live url
   static const String BASE_URL = 'https://naklibeta.com/api/api/';

  static const String LOGIN = BASE_URL + 'serviceprovider/first';
  static const String LOGOUT = BASE_URL + 'serviceprovider/logout';
  static const String FAQ = BASE_URL + 'serviceprovider/faq';
  static const String REFRESH = BASE_URL + 'serviceprovider/refresh';
  static const String REVIEWS = BASE_URL + 'serviceprovider/reviews';
  static const String PROFILE = BASE_URL + 'serviceprovider/profile';
  static const String REFERENCE = BASE_URL + 'serviceprovider/reference';
  static const String TRAINING = BASE_URL + 'serviceprovider/setTraining';
  static const String PROFILE_QUALIFICATION =
      BASE_URL + 'serviceprovider/qualification';
  static const String KYC = BASE_URL + 'serviceprovider/kyc';
  static const String UPLOAD_IMAGE =
      BASE_URL + 'serviceprovider/uploadProviderImage';
  static const String VERIFY_OTP = BASE_URL + 'serviceprovider/second';
  static const String REGISTER = BASE_URL + 'serviceprovider/third';
  static const String UPDATE_PROFILE = BASE_URL + 'serviceprovider/profile';
  static const String SERVICES = BASE_URL + 'service/findall';
  static const String CITIES = BASE_URL + 'list/findCityByState/30';
  static const String QUALIFICATION = BASE_URL + 'list/qualification';
  static const String JOBS = BASE_URL + 'jobs/getJobs';
  static const String ACCEPT_JOB = BASE_URL + 'jobs/accept';
  static const String SEND_QUOTATION = BASE_URL + 'jobs/putQuot';
  static const String PAYMENT_COMPLETE =
      BASE_URL + 'serviceprovider/completepayment';
  static const String PAYMENT_PENDING =
      BASE_URL + 'serviceprovider/pendingpayment';
  static const String JOB_DETAIL = BASE_URL + 'jobs/find';
  static const String START_JOB = BASE_URL + 'jobs/start';
  static const String END_JOB = BASE_URL + 'jobs/end';
  static const String PAYMENT_RECEIVED_JOB = BASE_URL + 'jobs/done';
  static const String DECLINE_JOB = BASE_URL + 'jobs/declined';
  static const String MY_JOBS = BASE_URL + 'jobs/myJobs';
  static const String NOTIFICATION = BASE_URL + 'jobs/notification';
  static const String NEW_QUOTATION = BASE_URL + 'jobs/newQuotation';

  Future<NotificationResponse> notification(BaseRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(NOTIFICATION),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + NOTIFICATION);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        NotificationResponse responseData =
            NotificationResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<MyJobResponse> myJob(JobRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(MY_JOBS),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + MY_JOBS);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        MyJobResponse responseData =
            MyJobResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<NextJobResponse> declineJob(DeclineRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(DECLINE_JOB),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + DECLINE_JOB);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        NextJobResponse responseData =
            NextJobResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<NextJobResponse> nextJob(int type, JobDetailRequest request) async {
    String URL = '';
    switch (type) {
      case 1:
        URL = START_JOB;
        break;
      case 2:
        URL = END_JOB;
        break;
      case 3:
        URL = PAYMENT_RECEIVED_JOB;
        break;
    }
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + URL);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        NextJobResponse responseData =
            NextJobResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<JobDetailsResponse> jobDetail(JobDetailRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(JOB_DETAIL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + JOB_DETAIL);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        JobDetailsResponse responseData =
            JobDetailsResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<PaymentResponse> paymentComplete(BaseRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(PAYMENT_COMPLETE),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + PAYMENT_COMPLETE);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        PaymentResponse responseData =
            PaymentResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<PaymentResponse> paymentPending(BaseRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(PAYMENT_PENDING),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + PAYMENT_PENDING);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        PaymentResponse responseData =
            PaymentResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<QuotationResponse> sendQuotation(
      bool isUpdate, QuotationRequest request) async {
    var responseJson;
    String URL = isUpdate ? NEW_QUOTATION : SEND_QUOTATION;
    try {
      final response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + URL);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        QuotationResponse responseData =
            QuotationResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<JobAcceptResponse> acceptJob(AcceptJobRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(ACCEPT_JOB),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );
      print('URL =>> ' + ACCEPT_JOB);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        JobAcceptResponse responseData =
            JobAcceptResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<JobResponse> getJob(JobRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(JOBS),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('URL =>> ' + JOBS);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        JobResponse responseData =
            JobResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<LoginResponse> loginUser(LoginModel user) async {
    var responseJson;
    try {
      LoginRequest loginRequest = new LoginRequest(providerModel: user);

      final response = await http.post(
        Uri.parse(LOGIN),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(loginRequest.toJson()),
      );
      print('URL =>> ' + LOGIN);
      print("RESPONSE =>> ${response.body}");
      print('REQUEST =>> ${json.encode(loginRequest.toJson()).toString()}');

      if (response.statusCode == 200) {
        LoginResponse responseData =
            LoginResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<LogoutResponse> logout(LogOutModel user) async {
    var responseJson;
    try {
      LogoutRequest loginRequest = new LogoutRequest(providerModel: user);

      final response = await http.post(
        Uri.parse(LOGOUT),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(loginRequest.toJson()),
      );

      print('URL =>> ' + LOGOUT);
      print("RESPONSE =>> ${response.body}");
      print('REQUEST =>> ${json.encode(loginRequest.toJson()).toString()}');

      if (response.statusCode == 200) {
        LogoutResponse responseData =
            LogoutResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<FAQResponse> faq() async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(FAQ),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('URL =>> ' + FAQ);
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        FAQResponse responseData =
            FAQResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<RefreshResponse> refresh(BaseRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(REFRESH),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );
      print('URL =>> ' + REFRESH);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        RefreshResponse responseData =
            RefreshResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<ReviewResponse> review(BaseRequest request) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(REVIEWS),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );
      print('URL =>> ' + REVIEWS);
      print('REQUEST =>> ${json.encode(request.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        ReviewResponse responseData =
            ReviewResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<ProfileResponse> profile(ProfileModel user) async {
    var responseJson;
    try {
      ProfileRequest profileRequest = new ProfileRequest(providerModel: user);

      final response = await http.post(
        Uri.parse(PROFILE),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(profileRequest.toJson()),
      );
      print('URL =>> ' + PROFILE);
      print('REQUEST =>> ${json.encode(profileRequest.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        ProfileResponse responseData =
            ProfileResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> reference(Reference request) async {
    var responseJson;
    try {
      ReferenceRequest profileRequest =
          new ReferenceRequest(reference: request);

      final response = await http.post(
        Uri.parse(REFERENCE),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(profileRequest.toJson()),
      );
      print('URL =>> ' + REFERENCE);
      print('REQUEST =>> ${json.encode(profileRequest.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse responseData =
            BaseResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> trainingSchedule(TrainingModel request) async {
    var responseJson;
    try {
      TrainingScheduleRequest trainingScheduleRequest =
          new TrainingScheduleRequest(trainingModel: request);

      final response = await http.post(
        Uri.parse(TRAINING),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(trainingScheduleRequest.toJson()),
      );
      print('URL =>> ' + TRAINING);
      print(
          'REQUEST =>> ${json.encode(trainingScheduleRequest.toJson()).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse responseData =
            BaseResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> qualification(
      QualificationRequest qualificationRequest) async {
    var responseJson;
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          PROFILE_QUALIFICATION,
        ),
      );
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields['providerId'] = qualificationRequest.providerId;
      request.fields['education'] = qualificationRequest.education;
      request.fields['aboutUs'] = qualificationRequest.aboutUs;
      request.fields['degree'] = qualificationRequest.degree;
      request.fields['occupation'] = qualificationRequest.occupation;
      request.fields['gstin'] = qualificationRequest.gstin;
      if(qualificationRequest.certificate!=null)
      request.files.add(
        http.MultipartFile.fromBytes(
          "certificate",
          qualificationRequest.certificate.readAsBytesSync(),
          filename:
              "certificate.${qualificationRequest.certificate.path.split(".").last}",
          contentType: MediaType("image",
              "${qualificationRequest.certificate.path.split(".").last}"),
        ),
      );
      // request.files.add(
      //   http.MultipartFile.fromBytes(
      //     "profilePhoto",
      //     qualificationRequest.profilePhoto.readAsBytesSync(),
      //     filename:
      //         "profilePhoto.${qualificationRequest.profilePhoto.path.split(".").last}",
      //     contentType: MediaType("image",
      //         "${qualificationRequest.profilePhoto.path.split(".").last}"),
      //   ),
      // );

      http.Response response =
          await http.Response.fromStream(await request.send());

      print('URL =>> ' + PROFILE_QUALIFICATION);
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse qualificationResponse =
            BaseResponse.fromJson(jsonDecode(response.body));
        if (qualificationResponse.statusCode == 200) {
          return qualificationResponse;
        } else {
          throw AppAPIException(qualificationResponse.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> kyc(KycRequest kycRequest) async {
    var responseJson;
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          KYC,
        ),
      );
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields['providerId'] = kycRequest.providerId;
      request.fields['name'] = kycRequest.name;
      request.fields['bankName'] = kycRequest.bankName;
      request.fields['ifsc'] = kycRequest.ifsc;
      request.fields['branchName'] = kycRequest.branchName;
      request.fields['acNumber'] = kycRequest.acNumber;
      // request.fields['gstin'] = kycRequest.gstin;

      if(kycRequest.aadharFront!=null)
      request.files.add(
        http.MultipartFile.fromBytes(
          "aadharFront",
          kycRequest.aadharFront.readAsBytesSync(),
          filename:
              "aadharFront.${kycRequest.aadharFront.path.split(".").last}",
          contentType: MediaType(
              "image", "${kycRequest.aadharFront.path.split(".").last}"),
        ),
      );

      if(kycRequest.aadharBack!=null)
      request.files.add(
        http.MultipartFile.fromBytes(
          "aadharBack",
          kycRequest.aadharBack.readAsBytesSync(),
          filename: "aadharBack.${kycRequest.aadharBack.path.split(".").last}",
          contentType: MediaType(
              "image", "${kycRequest.aadharBack.path.split(".").last}"),
        ),
      );

      if(kycRequest.panCard!=null)
      request.files.add(
        http.MultipartFile.fromBytes(
          "panCard",
          kycRequest.panCard.readAsBytesSync(),
          filename: "panCard.${kycRequest.panCard.path.split(".").last}",
          contentType:
              MediaType("image", "${kycRequest.panCard.path.split(".").last}"),
        ),
      );

      http.Response response =
          await http.Response.fromStream(await request.send());

      print('URL =>> ' + KYC);
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse qualificationResponse =
            BaseResponse.fromJson(jsonDecode(response.body));
        if (qualificationResponse.statusCode == 200) {
          return qualificationResponse;
        } else {
          throw AppAPIException(qualificationResponse.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> uploadProviderImage(File file, String providerID) async {
    var responseJson;
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          UPLOAD_IMAGE,
        ),
      );
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields['providerId'] = providerID;
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          file.readAsBytesSync(),
          filename: "file.${file.path.split(".").last}",
          contentType: MediaType("image", "${file.path.split(".").last}"),
        ),
      );

      http.Response response =
          await http.Response.fromStream(await request.send());
      print("Provider =>> $providerID");
      print('URL =>> ' + UPLOAD_IMAGE);
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse qualificationResponse =
            BaseResponse.fromJson(jsonDecode(response.body));
        if (qualificationResponse.statusCode == 200) {
          return qualificationResponse;
        } else {
          throw AppAPIException(qualificationResponse.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<OTPVerificationResponse> verifyOTP(OTPVerificationModel user) async {
    var responseJson;
    try {
      OTPVerificationRequest otpVerificationRequest =
          new OTPVerificationRequest(providerModel: user);
      final response = await http.post(
        Uri.parse(VERIFY_OTP),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(otpVerificationRequest.toJson()),
      );
      print('URL =>> ' + VERIFY_OTP);
      print('REQUEST =>> ${json.encode(otpVerificationRequest).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        OTPVerificationResponse responseData =
            OTPVerificationResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<RegistrationResponse> registerUser(RegistrationModel user) async {
    var responseJson;
    try {
      RegistrationRequest registrationRequest =
          new RegistrationRequest(providerModel: user);

      final response = await http.post(
        Uri.parse(REGISTER),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(registrationRequest.toJson()),
      );
      print('URL =>> ' + REGISTER);
      print('REQUEST =>> ${json.encode(registrationRequest).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        RegistrationResponse responseData =
            RegistrationResponse.fromJson(jsonDecode(response.body));

        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<BaseResponse> updateProfile(
      UpdatePersonalDetailsModel providerModel) async {
    var responseJson;
    try {
      UpdatePersonalDetailsRequest request =
          new UpdatePersonalDetailsRequest(providerModel: providerModel);
      final response = await http.post(
        Uri.parse(UPDATE_PROFILE),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );
      print('URL =>> ' + UPDATE_PROFILE);
      print('REQUEST =>> ${json.encode(request).toString()}');
      print("RESPONSE =>> ${response.body}");

      if (response.statusCode == 200) {
        BaseResponse responseData =
            BaseResponse.fromJson(jsonDecode(response.body));

        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<ServicesResponse> getServices() async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(SERVICES),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print('URL =>> ' + SERVICES);
      print("RESPONSE =>> ${response.body}");
      if (response.statusCode == 200) {
        ServicesResponse responseData =
            ServicesResponse.fromJson(jsonDecode(response.body));
        if (responseData.statusCode == 200) {
          return responseData;
        } else {
          throw AppAPIException(responseData.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<CityResponse> getCities() async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(CITIES),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print('URL =>> ' + CITIES);
      print("RESPONSE =>> ${response.body}");
      if (response.statusCode == 200) {
        CityResponse cityResponse =
            CityResponse.fromJson(jsonDecode(response.body));
        if (cityResponse.statusCode == 200) {
          return cityResponse;
        } else {
          throw AppAPIException(cityResponse.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<HighestQualificationResponse> getQualificationList() async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(QUALIFICATION),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('URL =>> ' + QUALIFICATION);
      print("RESPONSE =>> ${response.body}");
      if (response.statusCode == 200) {
        HighestQualificationResponse highestQualificationResponse =
            HighestQualificationResponse.fromJson(jsonDecode(response.body));
        if (highestQualificationResponse.statusCode == 200) {
          return highestQualificationResponse;
        } else {
          throw AppAPIException(highestQualificationResponse.message);
        }
      } else {
        responseJson = _response(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      // case 200:
      //   var responseJson = json.decode(response.body.toString());
      //   return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
