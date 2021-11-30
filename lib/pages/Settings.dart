import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/HelpAndSupport.dart';
import 'package:nakli_beta_service_provider/pages/Login.dart';
import 'package:nakli_beta_service_provider/pages/ProfileQualification.dart';
import 'package:nakli_beta_service_provider/pages/References.dart';
import 'package:nakli_beta_service_provider/pages/Registration.dart';
import 'package:nakli_beta_service_provider/pages/Reviews.dart';
import 'package:nakli_beta_service_provider/pages/UserKYC.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/LogoutRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/LogoutResponse.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Training.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  late File userImage;
  final picker = ImagePicker();
  String version = '', name = '', email = '', imageUrl = '';
  late Data userData;
  bool kyc = false,
      profile = false,
      references = false,
      trainingSchedule = false,
      status = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: (SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: InkWell(
                      onTap: () => _showSelectionDialog(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50.0,
                        child: ClipOval(
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            child: (imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 50,
                                  )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(email,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            (status ? 'Profile Activated' : 'Inactive profile'),
                            style: TextStyle(
                                color: (status
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  child: SizedBox(
                    height: 2,
                    child: Divider(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {

                },
                leading: Icon(
                  Icons.app_registration,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text(
                  'Registration',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                   openProfileScreen();
                },
                leading: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  (profile ? Icons.check : Icons.error),
                  color: (profile ? Colors.green : Colors.grey),
                ),
                title: Text(
                  'Professional Details',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                  openKYCScreen();
                },
                leading: Icon(
                  Icons.document_scanner_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon((kyc ? Icons.check : Icons.error),
                    color: (kyc ? Colors.green : Colors.red)),
                title: Text(
                  'KYC',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                   openReferencesScreen();
                },
                leading: Icon(
                  Icons.room_preferences,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon((references ? Icons.check : Icons.error),
                    color: (references ? Colors.green : Colors.grey)),
                title: Text(
                  'References',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {

                    openTrainingScreen();
                },
                leading: Icon(
                  Icons.model_training,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon((trainingSchedule ? Icons.check : Icons.error),
                    color: (trainingSchedule ? Colors.green : Colors.grey)),
                title: Text(
                  'Training Schedule',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                  registration();
                },
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                // trailing: Icon(
                //   Icons.check,
                //   color: Colors.green,
                // ),
                title: Text(
                  'Personal Details',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                  openReviewsScreen();
                },
                leading: Icon(
                  Icons.reviews,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Reviews',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                  openHelpAndSupportScreen();
                },
                leading: Icon(
                  Icons.help,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Help and Support',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12),
                onTap: () {
                  logout();
                },
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    version,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future _showSelectionDialog() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        selectOrTakePhoto(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      selectOrTakePhoto(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await ImagePicker.pickImage(
      source: imageSource,
      imageQuality: 60,
    );

    setState(() {
      if (pickedFile != null) {
        String path = pickedFile.path;
        print("asha === $path");
        userImage = File(pickedFile.path);
        uploadProfileImage();
      } else
        print('No photo was selected or taken');
    });
  }

  getUserData() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version =
          'App Version ' + packageInfo.version + "." + packageInfo.buildNumber;
    });

    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    setState(() {
      name = userData.name;
      email = userData.emailId;
      if (userData.photo != null && userData.photo.isNotEmpty)
        imageUrl = userData.photo;


      switch (userData.status) {
        case 0:
          break;
        case 1: // training done
         // profile = true;
          if(userData.certificate!='')
            profile = true;

          if(userData.aadharCardBack!="")
             kyc = true;

          if(userData.mobile1!='')
             references = true;

          if(userData.mobile1!='')
             trainingSchedule = true;
          status = true;
          break;
        case 2:
          break;
        case 3: //registration complete
          break;
        case 4:
          profile = true;
          break;
        case 5:
          profile = true;
          kyc = true;
          break;
        case 6:
          profile = true;
          kyc = true;
          references = true;
          break;
        case 7:
          profile = true;
          kyc = true;
          references = true;
          trainingSchedule = true;
          status = false;
          break;
      }
    });
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  logout() {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        LogOutModel user = new LogOutModel(providerId: userData.providerId);
        apiManager.logout(user).then((value) async {
          LogoutResponse logoutResponse = value;
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: logoutResponse.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          Navigator.popAndPushNamed(
            context,
            Login.routeName,
          );
        }).onError((error, stackTrace) {
          print(error);
          Navigator.pop(context);
          snackBar(error.toString(), Colors.red);
        });
      } else {
        snackBar(AppConstants.INTERNET_ERROR, Colors.red);
      }
    });
  }

  snackBar(String? message, MaterialColor colors) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: colors,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void registration() {
    Navigator.pushNamed(
      context,
      Registration.routeName,
      arguments: ScreenArguments(
        'TITLE',
        'Personal Details',
      ),
    ).then((value) => value != null ? getUserData() : null);
  }

  void openProfileScreen() {
    Navigator.pushNamed(
      context,
      ProfileQualification.routeName,
    ).then((val) => val != null ? getUserData() : null);
  }

  void openKYCScreen() {
    Navigator.pushNamed(
      context,
      UserKyc.routeName,
    ).then((val) => val != null ? getUserData() : null);
  }

  void openReferencesScreen() {
    Navigator.pushNamed(
      context,
      References.routeName,
    ).then((val) => val != null ? getUserData() : null);
  }

  void openTrainingScreen() {
    Navigator.pushNamed(
      context,
      Training.routeName,
    ).then((val) => val != null ? getUserData() : null);
  }

  void openReviewsScreen() {
    Navigator.pushNamed(
      context,
      Reviews.routeName,
    );
  }

  void openHelpAndSupportScreen() {
    Navigator.pushNamed(
      context,
      HelpAndSupport.routeName,
    );
  }

  void uploadProfileImage() {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager
            .uploadProviderImage(userImage, userData.providerId)
            .then((value) async {
          Navigator.pop(context);
          BaseResponse baseResponse = value;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              AppConstants.USER_DETAIL, json.encode(baseResponse.data));
          getUserData();
          Fluttertoast.showToast(
              msg: baseResponse.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              fontSize: 16.0);
        }).onError((error, stackTrace) {
          Navigator.pop(context);
          snackBar(error.toString(), Colors.red);
        });
      } else {
        snackBar(AppConstants.INTERNET_ERROR, Colors.red);
      }
    });
  }
}
