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
import 'package:nakli_beta_service_provider/rest/request/KycRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserKyc extends StatefulWidget {
  const UserKyc({Key? key}) : super(key: key);
  static const routeName = '/UserKyc';



  @override
  State<StatefulWidget> createState() {
    return UserKycState();
  }
}

class UserKycState extends State<UserKyc> {
  final _textAccountHolderName = TextEditingController();
  final _textBankName = TextEditingController();
  final _textBankIFSC = TextEditingController();
  final _textBranchName = TextEditingController();
  final _textAccountNumber = TextEditingController();
  final _textReenterAccountNumber = TextEditingController();

  // final _textFirmName = TextEditingController();
  // final _textGSTNumber = TextEditingController();

  bool validateAccountHolderName = false;
  bool validateBankName = false;
  bool validateBankIFSC = false;
  bool validateBranchName = false;
  bool validateAccountNumber = false;
  bool validateReenterAccountNumber = false;

  // bool validateFirmName = false;
  // bool validateGSTNumber = false;
  late Data userData;
  final picker = ImagePicker();
  var _frontImage = null, _backImage= null, _panCardImage= null;
    // late const _frontImage=null;
  //these for camera selection
  bool frontImageSelected = false;
  bool backImageSelected = false;
  bool panCardImageSelected = false;
  //these for serve image path come or not
  bool isFIFromServ = false;
  bool isBIFromServ = false;
  bool isPCFromServ = false;


  @override
  void initState() {
    getUserData();
    super.initState();
  }

  // getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   userData = Data.fromJson(
  //       json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
  // }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null) {
      _textAccountHolderName.value = _textAccountHolderName.value.copyWith(
        text: userData.acName,
      );
      _textBankName.value = _textBankName.value.copyWith(
        text: userData.bank,
      );
      _textBankIFSC.value = _textBankIFSC.value.copyWith(text: userData.ifsc);
      _textBranchName.value =
          _textBranchName.value.copyWith(text: userData.branch);
      _textAccountNumber.value =
          _textAccountNumber.value.copyWith(text: userData.acNumber);
      _textReenterAccountNumber.value =
          _textReenterAccountNumber.value.copyWith(text: userData.acNumber);

      setState(() {
        _textAccountHolderName.value = _textAccountHolderName.value.copyWith(
          text: userData.acName,
        );
      });
      if (userData.aadharCardFront != null&&userData.aadharCardFront != "") {
        setState(() {
          isFIFromServ = true;
         // _frontImage=File(userData.aadharCardFront);
        });
      }
      if (userData.aadharCardBack != null&&userData.aadharCardBack != "") {
        setState(() {
          isBIFromServ = true;
         // _backImage=File(userData.aadharCardBack);
        });
      }
      if (userData.pancard != null&&userData.pancard != "") {
        setState(() {
          isPCFromServ = true;
        //  _panCardImage=File(userData.pancard);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("KYC", style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: _textAccountHolderName,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Account Holder Name',
                    hintText: 'Enter name ',
                    errorText:
                        validateAccountHolderName ? 'Name is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _textBankName,
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    hintText: 'Enter bank name ',
                    errorText:
                        validateBankName ? 'Bank name  is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  controller: _textBankIFSC,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                    hintText: 'Enter IFSC Code ',
                    errorText: validateBankIFSC ? 'IFSC Code is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _textBranchName,
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    hintText: 'Enter Branch Name ',
                    errorText:
                        validateBranchName ? 'Branch Name is missing' : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _textAccountNumber,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Bank Account Number',
                    hintText: 'Enter Account Number ',
                    errorText: validateAccountNumber
                        ? 'Account Number is missing'
                        : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _textReenterAccountNumber,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.grey.shade900),
                  decoration: InputDecoration(
                    labelText: 'Re-enter Bank Account Number',
                    hintText: 'Enter Account Number ',
                    errorText: validateReenterAccountNumber
                        ? 'Account Number did not matched'
                        : null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorStyle:
                        TextStyle(color: Colors.red.shade500, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aadhaar Card (Front/Back Photo)",
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
                                  _showSelectionDialog(1);
                                },
                                child: (isFIFromServ==true&&frontImageSelected==false?Image.network(
                                  userData.aadharCardFront,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                    
                                )
                                    :frontImageSelected
                                        ? Image.file(
                                            _frontImage,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                            size: 120,
                                          )
                                    // Image.asset(
                                    //         'images/camera.jpg',
                                    //         height: 200,
                                    //         width: 200,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 10),
                              child: TextButton(
                                onPressed: () {
                                  _showSelectionDialog(2);
                                },
                                child: (isBIFromServ==true&&backImageSelected==false?Image.network(
                                  userData.aadharCardBack,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ):backImageSelected
                                        ? Image.file(
                                            _backImage,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                            size: 120,
                                          )
                                    // Image.asset(
                                    //         'images/camera.jpg',
                                    //         height: 200,
                                    //         width: 200,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    ),
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PAN Card (Front Photo)",
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
                                  _showSelectionDialog(3);
                                },
                                child: (isPCFromServ==true&&panCardImageSelected==false?Image.network(
                                  userData.pancard,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,

                                ):panCardImageSelected
                                        ? Image.file(
                                            _panCardImage,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                            size: 120,
                                          )
                                    // Image.asset(
                                    //         'images/camera.jpg',
                                    //         height: 200,
                                    //         width: 200,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    onPressed: () async {
                      if (_textAccountHolderName.text.toString().isNotEmpty &&
                          _textBankName.text.toString().isNotEmpty &&
                          _textBankIFSC.text.toString().isNotEmpty &&
                          _textBranchName.text.toString().isNotEmpty &&
                          _textAccountNumber.text.toString().isNotEmpty &&
                          _textReenterAccountNumber.text
                              .toString()
                              .isNotEmpty &&
                          frontImageSelected &&
                          backImageSelected &&
                          panCardImageSelected||frontImageSelected==false&&isFIFromServ==true&&backImageSelected==false&&isBIFromServ==true&&panCardImageSelected==false&&isPCFromServ==true||
                          frontImageSelected==true&&isFIFromServ==true||backImageSelected==true&&isBIFromServ==true||panCardImageSelected==true&&isPCFromServ==true) {
                        String accountNumber =
                            _textAccountNumber.text.toString();
                        String reAccountNumber =
                            _textReenterAccountNumber.text.toString();

                        if (accountNumber.compareTo(reAccountNumber) == 0) {
                          uploadKYC(new KycRequest(
                              providerId: userData.providerId,
                              aadharFront: _frontImage,
                              aadharBack: _backImage,
                              panCard: _panCardImage,
                              name: _textAccountHolderName.text,
                              bankName: _textBankName.text,
                              branchName: _textBranchName.text,
                              ifsc: _textBankIFSC.text,
                              acNumber: _textAccountNumber.text,
                              gstin: ''));
                        } else
                          snackBar("Account number did not match", Colors.red);
                      } else {
                        snackBar("Missing something", Colors.red);
                      }
                      setState(() {
                        validateAccountHolderName =
                            _textAccountHolderName.text.toString().isEmpty
                                ? true
                                : false;
                        validateBankName = _textBankName.text.toString().isEmpty
                            ? true
                            : false;
                        validateBankIFSC = _textBankIFSC.text.toString().isEmpty
                            ? true
                            : false;
                        validateBranchName =
                            _textBranchName.text.toString().isEmpty
                                ? true
                                : false;
                        validateAccountNumber =
                            _textAccountNumber.text.toString().isEmpty
                                ? true
                                : false;
                        validateReenterAccountNumber =
                            _textReenterAccountNumber.text.toString().isEmpty
                                ? true
                                : false;

                        if(!(isFIFromServ==true&&isBIFromServ==true))
                        if (!(frontImageSelected && backImageSelected)) {
                          snackBar("Aadhaar Card photo missing", Colors.red);
                        }
                        if(!isPCFromServ==true)
                        if (!panCardImageSelected) {
                          snackBar("Pan Card photo missing", Colors.red);
                        }
                      });
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
          ),
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource, int type) async {
    final pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 60);

    setState(() {
      if (pickedFile != null) {
        String path = pickedFile.path;
        print("asha === $path");

        if (type == 1) {
          frontImageSelected = true;
          _frontImage = File(pickedFile.path);

        } else if (type == 2) {
          backImageSelected = true;
          _backImage = File(pickedFile.path);
        } else {
          panCardImageSelected = true;
          _panCardImage = File(pickedFile.path);
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

  void uploadKYC(KycRequest kycRequest) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.kyc(kycRequest).then((value) async {
          Navigator.pop(context);
          BaseResponse baseResponse = value;
          if (baseResponse.data != null) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(
                AppConstants.USER_DETAIL, json.encode(baseResponse.data));
          }
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
        snackBar(AppConstants.INTERNET_ERROR, Colors.red);
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
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
