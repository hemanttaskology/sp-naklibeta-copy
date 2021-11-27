import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/JobStatusType.dart';
import 'package:nakli_beta_service_provider/common/JobType.dart';
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/Dashboard.dart';
import 'package:nakli_beta_service_provider/pages/Quotation.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/AcceptJobRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/DeclineRequest.dart';
import 'package:nakli_beta_service_provider/rest/request/JobDetailRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/JobAcceptResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/JobDetailsResponse.dart';
import 'package:nakli_beta_service_provider/rest/response/NextJobResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends StatefulWidget {
  static const routeName = '/jobDetails';
  final String orderId;

  const JobDetails({required this.orderId});

  @override
  State<StatefulWidget> createState() {
    return JobDetailsState();
  }
}

class JobDetailsState extends State<JobDetails> {
  late ScreenArguments args;
  late JobType jobType;
  late JobDetailData jobDetailData = new JobDetailData();
  bool isLoading = true;
  late Data userData;
  late String name = '', phone = '';
  bool validateQuotation = false;
  bool validateTotalAmount = false;
  final _validateQuotation = TextEditingController();
  final _validateTotalAmount = TextEditingController();
  double yourEarning = 0;

  @override
  void initState() {
    getUserData();
    getJobDetail();
    super.initState();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Job Detail",
              style: Theme.of(context).appBarTheme.titleTextStyle),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        // bottomNavigationBar: Dashboard(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (jobDetailData != null && jobDetailData.id != -1)
                ? SingleChildScrollView(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                              child: Text(
                                jobDetailData.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            getImageWidget(context),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                jobDetailData.detail,
                                maxLines: 30,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                'Preferred Date : ' + jobDetailData.date,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            (userData.status == 1)
                                ? getAddress()
                                : SizedBox.shrink(),
                            (name.isNotEmpty && phone.isNotEmpty)
                                ? getCustomerDetail()
                                : SizedBox.shrink(),
                            getQuotation(),
                            getButton(),
                            (jobDetailData.status == 1)
                                ? Center(
                                    child: Text(
                                    'Before sending a quotation',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                                : Center(child: Text('')),
                            (jobDetailData.status == 1)
                                ? Center(
                                    child: Text(
                                        'Kindly Call the customer first to understand the complete requirement'
                                        ' or call & schedule a meeting to understand the complete requirement of the customer.'))
                                : Center(child: Text('')),
                          ],
                        )),
                  )
                : Center(child: Text('No data')));
  }

  getImageWidget(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1.0,
      crossAxisSpacing: 1.0,
      children: List.generate(
        1,
        (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Image.network(
              jobDetailData.url,
            ),
          );
        },
      ),
    );
  }

  void getJobDetail() {
    if (widget.orderId != null && widget.orderId.isNotEmpty) {
      JobDetailRequest request = new JobDetailRequest(
          orderModel: new JobDetailModel(orderId: widget.orderId));
      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          APIManager apiManager = new APIManager();
          apiManager.jobDetail(request).then((value) async {
            JobDetailsResponse jobDetailsResponse = value;
            setState(() {
              isLoading = false;
              if (jobDetailsResponse.data != null) {
                jobDetailData = jobDetailsResponse.data;
                name = jobDetailData.name;
                phone = jobDetailData.phone;
              }
            });
          }).onError((error, stackTrace) {
            setState(() {
              isLoading = false;
            });
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
                  getJobDetail();
                },
              ),
            ),
          );
        }
      });
    }
  }

  void openNextPage() {
    if (jobDetailData.status == JobStatusType.OPEN.index) {
      AcceptJobRequest request = new AcceptJobRequest(
          orderModel: new OrderModel(
              providerId: userData.providerId, orderId: widget.orderId));
      acceptJob(request);
    } else if (jobDetailData.status == JobStatusType.PENDING.index ||
        jobDetailData.status == JobStatusType.REJECTED.index) {
      openQuotationPage(false);
    } else if (jobDetailData.status == JobStatusType.ACCEPTED.index) {
      //start job
      nextJob(1);
    } else if (jobDetailData.status == JobStatusType.START_JOB.index) {
      //end job
      nextJob(2);
    } else if (jobDetailData.status == JobStatusType.END_JOB.index) {
      //payment done
      nextJob(3);
    }
  }

  getQuotation() {
    if ((jobDetailData.quotation != null &&
            jobDetailData.quotation.details.isNotEmpty &&
            jobDetailData.quotation.amount.isNotEmpty) &&
        (jobDetailData.status >=
            JobStatusType.QUOTATION_PENDING_APPROVAL.index)) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Quotation : ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                jobDetailData.quotation.details,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Total Amount : Rs.' + jobDetailData.quotation.amount + '/-',
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
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

  getButton() {
    if (userData.status == 1) {
      if (jobDetailData.status ==
              JobStatusType.QUOTATION_PENDING_APPROVAL.index ||
          jobDetailData.status == JobStatusType.PAYMENT_RECEIVED.index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Text(
            JobStatusType.values[jobDetailData.status].buttonText,
            style: TextStyle(
                color: JobStatusType.values[jobDetailData.status].color,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        );
      } else if (jobDetailData.status == JobStatusType.REJECTED.index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 50,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    openNextPage();
                  },
                  child: Text(
                    (JobStatusType.PENDING.buttonText),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 120,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    declineJob();
                  },
                  child: Text(
                    ('DECLINE'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (jobDetailData.status == JobStatusType.ACCEPTED.index ||
          jobDetailData.status == JobStatusType.START_JOB.index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 50,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    openNextPage();
                  },
                  child: Text(
                    (JobStatusType.values[jobDetailData.status].buttonText),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    openQuotationPage(true);
                  },
                  child: Text(
                    ("UPDATE QUOTATION"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: TextButton(
              onPressed: () {
                openNextPage();
              },
              child: Text(
                (JobStatusType.values[jobDetailData.status].buttonText),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }
    } else
      return SizedBox.shrink();
  }

  void acceptJob(AcceptJobRequest request) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.acceptJob(request).then((value) async {
          Navigator.pop(context);
          JobAcceptResponse baseResponse = value;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              AppConstants.JOB_ACCEPT_DETAIL, json.encode(baseResponse.data));
          // Fluttertoast.showToast(
          //     msg: baseResponse.message,
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     textColor: Colors.white,
          //     backgroundColor: Theme.of(context).accentColor,
          //     fontSize: 16.0);
          setState(() {
            jobDetailData.status = baseResponse.data.status;
            name = baseResponse.data.userName;
            phone = baseResponse.data.mobile;
          });
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

  void openQuotationPage(bool update) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => Quotation(
                  orderId: widget.orderId,
                  detail: jobDetailData.detail,
                  preferredDate: jobDetailData.date,
                  taxStatus: jobDetailData.taxStatus,
                  taxPercentage: jobDetailData.taxPercentage,
                  providerPercentage: jobDetailData.providerPercentage,
                  updateQuotation: update,
                  amount: jobDetailData.quotation.amount,
                  taxable_amount: jobDetailData.quotation.taxable_amount,
                  taxPercentage2: jobDetailData.taxPercentage2,
                  taxPercentage3: jobDetailData.taxPercentage3,
                  text: jobDetailData.quotation.details,
                )))
        .then((val) => val ? Navigator.pop(context, true) : refreshUI());
  }

  getCustomerDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, 10),
          child: Divider(
            height: 2,
            color: Colors.grey.shade200,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text(
                'Customer Name :',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Phone Number :',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: InkWell(
                onTap: () {
                  launch("tel://" + phone);
                },
                child: Text(
                  phone,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void nextJob(int type) {
    JobDetailRequest request = new JobDetailRequest(
        orderModel: new JobDetailModel(orderId: widget.orderId));
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.nextJob(type, request).then((value) async {
          Navigator.pop(context);
          NextJobResponse response = value;
          Fluttertoast.showToast(
              msg: response.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              fontSize: 16.0);
          setState(() {
            jobDetailData.status = response.data.status;
          });
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

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      int totalAmount = int.parse(text);
      yourEarning = (totalAmount * jobDetailData.providerPercentage) / 100;
      setState(() {});
    }
  }

  refreshUI() {
    setState(() {
      isLoading = true;
    });
    getJobDetail();
  }

  void declineJob() {
    DeclineRequest request = new DeclineRequest(
        orderModel: new DeclineModel(
            orderId: widget.orderId, providerId: userData.providerId));
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager.declineJob(request).then((value) async {
          Navigator.pop(context);
          NextJobResponse response = value;
          Fluttertoast.showToast(
              msg: response.message,
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

  getAddress() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Text(
              'Address : ',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Text(
              jobDetailData.address,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
