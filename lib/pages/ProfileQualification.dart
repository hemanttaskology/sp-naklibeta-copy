import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/QualificationRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/HighestQualificationResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileQualification extends StatefulWidget {
  static const routeName = '/PersonalDetails';

  @override
  State<StatefulWidget> createState() {
    return ProfileQualificationState();
  }
}

class ProfileQualificationState extends State<ProfileQualification> {
  final _textDegreeName = TextEditingController();
 // final _textHighestDegree = TextEditingController();
  final _textOccupation = TextEditingController();
  final _textGSTIN = TextEditingController();
  final _textAboutYourself = TextEditingController();

  bool validateDegreeName = false;
  bool validateHighestDegree = false;
  bool validateAddress = false;
  bool validateOccupation = false;
  bool validateGSTIN = false;
  bool validateAboutYourself = false;
  var selectedQualificationValue ;
  bool isCPFromServ = false;

  //bool imageSelected = false;
  bool qualificationCertificateImageSelected = false;

  //late File userImage, qualificationCertificateImage;
  var qualificationCertificateImage;
  late Data userData;
  final picker = ImagePicker();
  final List<HighestQualificationData> qualificationListItems = [];
  bool setQualificationListItems = false;
  late int isRadioSelected = -1;
  late String highestDegree;

  @override
  void initState() {
    getUserData();
    getQualificationList();
    super.initState();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    userData.photo = "";
    if (userData != null) {
      _textDegreeName.value =
          _textDegreeName.value.copyWith(text: userData.degree);
      _textOccupation.value =
          _textOccupation.value.copyWith(text: userData.occupation);
      _textAboutYourself.value =
          _textAboutYourself.value.copyWith(text: userData.aboutUs);
      _textGSTIN.value=_textGSTIN.value.copyWith(text:userData.gstin);
      highestDegree = userData.education;
      selectedQualificationValue = highestDegree;
      setState(() {});
      if (userData.certificate != null&&userData.certificate != "") {
        setState(() {
          isCPFromServ = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Professional Details",
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: setQualificationListItems
              ? SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    // Container(
                    //   padding: EdgeInsets.only(top: 20),
                    //   child: InkWell(
                    //     onTap: () => _showSelectionDialog(1),
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       radius: 70.0,
                    //       child: ClipOval(
                    //         child: CircleAvatar(
                    //           radius: 68,
                    //           backgroundColor: Colors.white,
                    //           child: (userData.photo != null &&
                    //                   userData.photo.isNotEmpty
                    //               ? CachedNetworkImage(
                    //                   imageUrl: userData.photo,
                    //                   imageBuilder: (context, imageProvider) =>
                    //                       Container(
                    //                     decoration: BoxDecoration(
                    //                       image: DecorationImage(
                    //                         image: imageProvider,
                    //                         fit: BoxFit.fill,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   placeholder: (context, url) =>
                    //                       CircularProgressIndicator(),
                    //                   errorWidget: (context, url, error) =>
                    //                       Icon(
                    //                     Icons.error,
                    //                     color: Colors.red,
                    //                   ),
                    //                 )
                    //               : (imageSelected
                    //                   ? Image.file(
                    //                       userImage,
                    //                       fit: BoxFit.cover,
                    //                       width: 140.0,
                    //                       height: 140.0,
                    //                     )
                    //                   : Icon(
                    //                       Icons.camera_alt,
                    //                       color: Colors.grey,
                    //                       size: 50,
                    //                     ))),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 15),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: _textDegreeName,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Highest Degree Name',
                          hintText: 'Enter highest degree name ',
                          errorText: validateDegreeName
                              ? 'Degree name is missing'
                              : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Highest Qualification ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            ListTile(
                              tileColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              onTap: () {
                                showAlert().then((value) => (setState(() {
                                      selectedQualificationValue =
                                          value as String;
                                    })));
                              },
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              title: Text(
                                (selectedQualificationValue != null
                                    ? selectedQualificationValue
                                    : 'Select Highest Qualification'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Highest Qualification Certificate",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 10),
                                    child: TextButton(
                                      onPressed: () {
                                        _showSelectionDialog(2);
                                      },
                                      child:
                                          (isCPFromServ==true&&qualificationCertificateImageSelected==false?Image.network(
                                            userData.certificate,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ):qualificationCertificateImageSelected
                                              ? Image.file(
                                                  qualificationCertificateImage,
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey,
                                                  size: 120,
                                                )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: _textOccupation,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Occupation / Business Name',
                          hintText: 'Enter Occupation ',
                          errorText: validateOccupation
                              ? 'Occupation/Business Name is missing'
                              : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: _textGSTIN,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'GSTIN(Optional)',
                          hintText: 'Enter GSTIN (Optional)',
                          errorText: validateGSTIN ? 'GSTIN' : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: _textAboutYourself,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Tell Us about yourself',
                          hintText: 'About yourself ',
                          errorText: validateAboutYourself
                              ? 'Detail is missing'
                              : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // validateDegreeName =
                              //     _textDegreeName.text.toString().isEmpty
                              //         ? true
                              //         : false;
                              //
                              // validateOccupation =
                              //     _textOccupation.text.toString().isEmpty
                              //         ? true
                              //         : false;
                              // validateAboutYourself =
                              //     _textAboutYourself.text.toString().isEmpty
                              //         ? true
                              //         : false;
                              //
                              // if (selectedQualificationValue
                              //     .toString()
                              //     .isEmpty) {
                              //   snackBar("Please select highest qualification",
                              //       Colors.red);
                              // }

                              // if (!imageSelected) {
                              //   snackBar(
                              //       "Please select profile image", Colors.red);
                              // }

                              // if (isCPFromServ==false&&qualificationCertificateImageSelected==true) {
                              //   snackBar(
                              //       "Please select highest qualification certificate",
                              //       Colors.red);
                              // }
                            });
                            // if (_textDegreeName.text.toString().isNotEmpty &&
                            //     _textOccupation.text.toString().isNotEmpty &&
                            //     _textAboutYourself.text.toString().isNotEmpty &&
                            //     selectedQualificationValue
                            //         .toString()
                            //         .isNotEmpty &&
                            //     qualificationCertificateImageSelected||isCPFromServ==true&&qualificationCertificateImageSelected==false||
                            //     isCPFromServ==true&&qualificationCertificateImageSelected==true) {
                            //
                            // }
                            QualificationRequest request =
                            new QualificationRequest(
                                providerId: userData.providerId,
                                //  profilePhoto: userImage,
                                occupation: _textOccupation.text,
                                education: selectedQualificationValue,
                                aboutUs: _textAboutYourself.text,
                                degree: _textDegreeName.text,
                                certificate:
                                qualificationCertificateImage,
                                gstin: _textGSTIN.text);
                            uploadProfile(request);
                          },
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource, int type) async {
    final pickedFile =
        await ImagePicker.pickImage(source: imageSource, imageQuality: 60);

    setState(() {
      if (pickedFile != null) {
        String path = pickedFile.path;
        print("asha === $path");
        if (type == 1) {
          //  imageSelected = true;
          userData.photo = '';
          //  userImage = File(pickedFile.path);
        } else {
          qualificationCertificateImageSelected = true;
          qualificationCertificateImage = File(pickedFile.path);
        }
      } else
        print('No photo was selected or taken');
    });
  }

  Future _showSelectionDialog(int type) async {
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
                        selectOrTakePhoto(ImageSource.gallery, type);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      selectOrTakePhoto(ImageSource.camera, type);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  uploadProfile(QualificationRequest qualificationRequest) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.qualification(qualificationRequest).then((value) async {
          Navigator.pop(context);
          BaseResponse baseResponse = value;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              AppConstants.USER_DETAIL, json.encode(baseResponse.data));
          Fluttertoast.showToast(
              msg: baseResponse.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              fontSize: 16.0);
          Navigator.pop(context, true);
        }).onError((error, stackTrace) {
          Navigator.pop(context);
          snackBar(error.toString(), Colors.red);
        });
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        snackBar(AppConstants.INTERNET_ERROR, Colors.red);
      }
    });
  }

  getQualificationList() {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        APIManager apiManager = new APIManager();
        apiManager.getQualificationList().then((value) async {
          HighestQualificationResponse highestQualificationResponse = value;
          if (highestQualificationResponse.data != null)
            qualificationListItems.addAll(highestQualificationResponse.data);

          setState(() {
            setQualificationListItems = true;
          });
        }).onError((error, stackTrace) {
          snackBar(error.toString(), Colors.red);
        });
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppConstants.INTERNET_ERROR,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            duration: Duration(minutes: 10),
            action: SnackBarAction(
              label: 'REFRESH',
              onPressed: () {
                getQualificationList();
              },
            ),
          ),
        );
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

  snackBar(String? message, MaterialColor colors) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: colors,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> showAlert() async {
    var index = qualificationListItems.indexWhere((element) => element.name==highestDegree);
    setState(() {
      isRadioSelected = index;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            child: AlertDialog(
              title: Text('Select Highest Qualification',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              actions: <Widget>[
                TextButton(
                  child: Text('Done',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(qualificationListItems[isRadioSelected].name);
                  },
                ),
              ],
              content: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: qualificationListItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title:
                                      Text(qualificationListItems[index].name),
                                  value: index,
                                  groupValue: isRadioSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      isRadioSelected = index;
                                    });
                                  });
                            }),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onWillPop: () async {
              return false;
            },
          );
        });
      },
    );
  }
}
