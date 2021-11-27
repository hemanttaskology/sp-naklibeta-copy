import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/Dashboard.dart';
import 'package:nakli_beta_service_provider/pages/SearchPage.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/Category.dart';
import 'package:nakli_beta_service_provider/rest/request/RegistrationRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/UpdatePersonalDetailsRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/BaseResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/CityResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/RegistrationResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/ServicesResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SelectCategoryPage.dart';

class Registration extends StatefulWidget {
  static const routeName = '/registration';

  @override
  State<StatefulWidget> createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<Registration> {
  late Data userData;
  String phone = '';
  String email = '';
  String state = "Rajasthan";
  String stateId = "30";
  final _textName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPhoneNumber = TextEditingController();
  final _textState = TextEditingController();
  final _textAddress = TextEditingController();
  bool termsAndConditionsAccepted = false;
  bool validateName = false;
  bool validateEmail = false;
  bool validatePhoneNumber = false;
  bool validateState = false;
  bool validateAddress = false;
  bool enableDisableEmail = false;
  bool enableDisablePhone = false;
  String selectedCityValue = '',selectedCityId = '', selectedCategoryValue = '';
  final List<SearchData> cityListItems = [];
  final List<SearchCategoryData> serviceListItems = [];
  late List<ServiceDetails> serviceDetailList = [];
  bool setCity = false, setService = false;
  late ScreenArguments args;
  bool isFromSettings = false;
  late String title = "";
  late ServicesResponse servicesResponse;
  String termsAndConditionUrl = 'https://www.naklibeta.com/terms-and-condition';
  List<String> finalSelectionList = [];
  List<CategorySelectionList> selectionList = [];
  late ServiceDetails serviceDetail;
  final List<CategorySelectionList> selectedCategoryList = [];

  @override
  void initState() {
    getUserData();
    getServices();

    super.initState();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null) {
      _textEmail.value = _textEmail.value.copyWith(
        text: userData.emailId,
      );
      _textPhoneNumber.value = _textPhoneNumber.value.copyWith(
        text: userData.mobile,
      );
      _textState.value = _textState.value.copyWith(
        text: state,
      );

      setState(() {
        if (isFromSettings) {
          _textName.value = _textName.value.copyWith(
            text: userData.name,
          );
          enableDisableEmail = true;
          enableDisablePhone = true;
          selectedCityValue = userData.city;
          selectedCategoryValue = userData.getSelectedCategoryName().join(',');
          _textAddress.value = _textAddress.value.copyWith(
            text: userData.address,
          );
        } else {
          enableDisableEmail = userData.emailId.isEmpty ? true : false;
          enableDisablePhone = userData.mobile.isEmpty ? true : false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    if (args.data != null) {
      title = args.data;
      if (title.compareTo(AppConstants.TITLE_REGISTRATION) != 0)
        isFromSettings = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ((setCity && setService)
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: _textName,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter full name ',
                          errorText: validateName ? 'Name is missing' : null,
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
                        controller: _textEmail,
                        enabled: enableDisableEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email ',
                          errorText: validateEmail ? 'Invalid Email ID' : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 2.0),
                          ),
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
                        keyboardType: TextInputType.phone,
                        controller: _textPhoneNumber,
                        maxLength: 10,
                        enabled: enableDisablePhone,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter Phone Number',
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 2.0),
                          ),
                          errorText: validatePhoneNumber
                              ? 'Invalid Phone Number'
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
                        controller: _textState,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'State',
                          hintText: 'Enter State ',
                          errorText: validateState ? 'State is missing' : null,
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          errorStyle: TextStyle(
                              color: Colors.red.shade500, fontSize: 12),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 2.0),
                          ),
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
                              "City ",
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
                                int selectedCityIndex = -1;
                                cityListItems.forEach((element) {
                                  if (element.name
                                          .compareTo(selectedCityValue) ==
                                      0)
                                    selectedCityIndex =
                                        cityListItems.indexOf(element);
                                });
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => SearchSelectPage(
                                              title: 'Select City',
                                              dataList: cityListItems,
                                              isRadioSelected:
                                                  selectedCityIndex,
                                            )))
                                    .then((value) => value != null
                                        ? (setState(() {
                                            selectedCityValue = value.name;
                                            selectedCityId = value.id.toString();
                                          }))
                                        : null);
                              },
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              title: Text(
                                (selectedCityValue.isNotEmpty
                                    ? selectedCityValue
                                    : 'Select City'),
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
                              "Category ",
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            new SearchCategoryPage(
                                              title: 'Select Category',
                                              dataList: serviceListItems,
                                            )))
                                    .then((value) => value != null
                                        ? (setState(() {
                                            selectionList = [];
                                            finalSelectionList = [];
                                            selectionList = value;
                                            selectionList.forEach((element) {
                                              finalSelectionList
                                                  .add(element.name);
                                            });
                                            selectedCategoryValue =
                                                finalSelectionList.join(",");
                                          }))
                                        : null);
                              },
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              title: Text(
                                (selectedCategoryValue.isNotEmpty
                                    ? selectedCategoryValue
                                    : 'Select Category'),
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: _textAddress,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey.shade900),
                        decoration: InputDecoration(
                          labelText: 'Current Address',
                          hintText: 'Enter Your Current Address ',
                          errorText: validateAddress
                              ? 'Current Address is missing'
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
                    getTermsAndCondition(),
                    Padding(
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
                              validateName = _textName.text.toString().isEmpty
                                  ? true
                                  : false;
                              validateEmail =
                                  (_textEmail.text.toString().isNotEmpty &&
                                          validatedEmail(
                                              _textEmail.text.toString()))
                                      ? false
                                      : true;
                              validatePhoneNumber = (_textPhoneNumber.text
                                          .toString()
                                          .isNotEmpty &&
                                      validateMobile(
                                          _textPhoneNumber.text.toString()))
                                  ? false
                                  : true;
                              validateState = _textState.text.toString().isEmpty
                                  ? true
                                  : false;
                              validateAddress =
                                  _textAddress.text.toString().isEmpty
                                      ? true
                                      : false;
                              if (selectedCityValue.toString().isEmpty) {
                                snackBar("Please select a city", Colors.red);
                              }

                              if (selectedCategoryValue.toString().isEmpty) {
                                snackBar("Please select service category",
                                    Colors.red);
                              }

                              if (!termsAndConditionsAccepted) {
                                snackBar(
                                    "Please make sure to check the terms and conditions",
                                    Colors.red);
                              }
                            });
                            if (_textName.text.toString().isNotEmpty &&
                                _textEmail.text.toString().isNotEmpty &&
                                validatedEmail(_textEmail.text.toString()) &&
                                _textPhoneNumber.text.toString().isNotEmpty &&
                                validateMobile(
                                    _textPhoneNumber.text.toString()) &&
                                _textState.text.toString().isNotEmpty &&
                                _textAddress.text.toString().isNotEmpty &&
                                selectedCityValue.toString().isNotEmpty &&
                                selectedCategoryValue.toString().isNotEmpty &&
                                termsAndConditionsAccepted) {
                              List<Category> categoryList = [];
                              List<String> name =
                                  selectedCategoryValue.split(",");

                              selectionList.forEach((element) {
                                // SearchCategoryData data =
                                //     serviceListItems.firstWhere((service) =>
                                //         service.name.compareTo(element) == 0);
                                // if (data != null) {
                                Category category = new Category(
                                    id: element.subCategoryId,
                                    name: element.name);
                                categoryList.add(category);
                                // }
                              });
                              if (isFromSettings) {
                                UpdatePersonalDetailsModel user =
                                    new UpdatePersonalDetailsModel(
                                        providerId: userData.providerId,
                                        name: _textName.text.toString(),
                                        emailId: _textEmail.text.toString(),
                                        mobile:
                                            _textPhoneNumber.text.toString(),
                                        address: _textAddress.text.toString(),
                                        city: selectedCityValue.toString(),
                                        cityId: selectedCityId.toString(),
                                        state: _textState.text.toString(),
                                        stateId: stateId,
                                        serviceCategory: categoryList
                                    );
                                updatePersonalDetails(user);
                              } else {
                                RegistrationModel user = new RegistrationModel(
                                    id: userData.id,
                                    name: _textName.text.toString(),
                                    emailId: _textEmail.text.toString(),
                                    mobile: _textPhoneNumber.text.toString(),
                                    address: _textAddress.text.toString(),
                                    city: selectedCityValue.toString(),
                                    cityId: selectedCityId.toString(),
                                    state: _textState.text.toString(),
                                    stateId: stateId,
                                    serviceCategory: categoryList);
                                registerUser(user);
                              }
                            }
                          },
                          child: Text(
                            (isFromSettings ? 'UPDATE' : 'SUBMIT'),
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
              )
            : Center(
                child: CircularProgressIndicator(),
              )),
      ),
    );
  }

  void registerUser(RegistrationModel user) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.registerUser(user).then((value) async {
          RegistrationResponse registrationResponse = value;
          openHomeScreen(registrationResponse);
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

  void getServices() {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        APIManager apiManager = new APIManager();
        apiManager.getServices().then((value) async {
          servicesResponse = value;
          setServiceItems();
        }).onError((error, stackTrace) {
          print(error);
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
                getServices();
              },
            ),
          ),
        );
      }
    });
  }

  void getCities() {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        APIManager apiManager = new APIManager();
        apiManager.getCities().then((value) async {
          CityResponse cityResponse = value;
          if (cityResponse.data != null)
            for (var i = 0; i < cityResponse.data.length; i++) {
              SearchData searchData = new SearchData(
                  cityResponse.data[i].id, cityResponse.data[i].city);
              cityListItems.add(searchData);
            }
          setState(() {
            setCity = true;
          });
        }).onError((error, stackTrace) {
          print(error);
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
                getCities();
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

  Future<void> openHomeScreen(RegistrationResponse registrationResponse) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstants.LOGIN, true);
    prefs.setString(
        AppConstants.USER_DETAIL, json.encode(registrationResponse.data));
    Navigator.pop(context);
    if (isFromSettings) {
      Navigator.pop(context, true);
    } else {
      Navigator.popAndPushNamed(
        context,
        Dashboard.routeName,
      );
    }
  }

  _launchURL(String url) async {
    if (await launch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool validatedEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  bool validateMobile(String value) {
    String pattern = r'([0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  getTermsAndCondition() {
    if (isFromSettings) {
      termsAndConditionsAccepted = true;
      return SizedBox.shrink();
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            Material(
              child: Checkbox(
                checkColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).accentColor,
                value: termsAndConditionsAccepted,
                onChanged: (value) {
                  setState(() {
                    termsAndConditionsAccepted = value!;
                  });
                },
              ),
            ),
            new InkWell(
                child: new Text(
                  'I have read and accept terms and conditions',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 12),
                ),
                onTap: () => _launchURL(termsAndConditionUrl)),
          ],
        ),
      );
    }
  }

  updatePersonalDetails(UpdatePersonalDetailsModel user) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.updateProfile(user).then((value) async {
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

  void setServiceItems() {
    if (servicesResponse.data != null)
      for (var i = 0; i < servicesResponse.data.length; i++) {
        serviceDetailList = [];
        bool selected = false;
        bool headerSelected = false;
        int servicelength = servicesResponse.data[i].serviceDetails.length;
        servicesResponse.data[i].serviceDetails.forEach((detail) {
          try{
            var abc = userData.serviceCategory.firstWhere((element) => element.name==detail.name);
            selected = true;
            CategorySelectionList categorySelectionList = new CategorySelectionList(name: detail.name, id: servicesResponse.data[i].subCateId, subCategoryId: detail.id);
            selectedCategoryList.add(categorySelectionList);
          }catch(e){
            selected = false;
          }
          serviceDetail = new ServiceDetails(
              id: detail.id, name: detail.name, selected: selected);
          serviceDetailList.add(serviceDetail);
        });
        int detailLength = serviceDetailList
            .where((element) => element.selected == true)
            .length;
        if (servicelength == detailLength) {
          headerSelected = true;
        }
        SearchCategoryPageState.selectedCategoryList = selectedCategoryList;
        SearchCategoryData searchData = new SearchCategoryData(
            servicesResponse.data[i].subCateId,
            servicesResponse.data[i].subCateName,
            serviceDetailList,
            headerSelected,
            detailLength);
        serviceListItems.add(searchData);
      }
    setState(() {
      setService = true;
      getCities();
    });
  }
}
