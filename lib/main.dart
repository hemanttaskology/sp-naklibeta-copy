// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/localization/form_builder_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nakli_beta_service_provider/pages/Dashboard.dart';
import 'package:nakli_beta_service_provider/pages/HelpAndSupport.dart';
import 'package:nakli_beta_service_provider/pages/Home.dart';
import 'package:nakli_beta_service_provider/pages/JobDetails.dart';
import 'package:nakli_beta_service_provider/pages/JobList.dart';
import 'package:nakli_beta_service_provider/pages/Login.dart';
import 'package:nakli_beta_service_provider/pages/MyJobs.dart';
import 'package:nakli_beta_service_provider/pages/Notifications.dart';
import 'package:nakli_beta_service_provider/pages/OTPVerification.dart';
import 'package:nakli_beta_service_provider/pages/Payments.dart';
import 'package:nakli_beta_service_provider/pages/PaymentsComplete.dart';
import 'package:nakli_beta_service_provider/pages/PaymentsPending.dart';
import 'package:nakli_beta_service_provider/pages/ProfileQualification.dart';
import 'package:nakli_beta_service_provider/pages/Quotation.dart';
import 'package:nakli_beta_service_provider/pages/References.dart';
import 'package:nakli_beta_service_provider/pages/Registration.dart';
import 'package:nakli_beta_service_provider/pages/Reviews.dart';
import 'package:nakli_beta_service_provider/pages/SearchPage.dart';
import 'package:nakli_beta_service_provider/pages/SelectCategoryPage.dart';
import 'package:nakli_beta_service_provider/pages/Settings.dart';
import 'package:nakli_beta_service_provider/pages/Splash.dart';
import 'package:nakli_beta_service_provider/pages/Training.dart';
import 'package:nakli_beta_service_provider/pages/UserKYC.dart';
import 'package:nakli_beta_service_provider/theme/custom_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    localizationsDelegates: [
      FormBuilderLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', ''),
    ],
    home: Splash(),
    routes: <String, WidgetBuilder>{
      Splash.routeName: (context) => new Splash(),
      Login.routeName: (context) => new Login(),
      OTPVerification.routeName: (context) => new OTPVerification(),
      Registration.routeName: (context) => Registration(),
      Dashboard.routeName: (context) => Dashboard(),
      Home.routeName: (context) => Home(),
      MyJobs.routeName: (context) => MyJobs(),
      Notifications.routeName: (context) => Notifications(),
      Settings.routeName: (context) => Settings(),
      ProfileQualification.routeName: (context) => ProfileQualification(),
      UserKyc.routeName: (context) => UserKyc(),
      References.routeName: (context) => References(),
      Training.routeName: (context) => Training(),
      Payments.routeName: (context) => Payments(),
      HelpAndSupport.routeName: (context) => HelpAndSupport(),
      Reviews.routeName: (context) => Reviews(),
      JobDetails.routeName: (context) => JobDetails(
            orderId: '',
          ),
      Quotation.routeName: (context) => Quotation(
            orderId: '',
            detail: '',
            preferredDate: '',
            taxPercentage: 0,
            providerPercentage: 0,
            updateQuotation: false,
          ),
      JobList.routeName: (context) => JobList(
            title: '',
            dataList: [],
          ),
      PaymentsComplete.routeName: (context) => PaymentsComplete(),
      PaymentsPending.routeName: (context) => PaymentsPending(),
      SearchCategoryPage.routeName: (context) => SearchCategoryPage(
            title: '',
            dataList: [],
          ),
      SearchSelectPage.routeName: (context) => SearchSelectPage(
            title: '',
            dataList: [],
            isRadioSelected: -1,
          ),
    },
  ));
}
/*
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
 */
