import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/JobStatusType.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/JobRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/MyJobResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JobDetails.dart';

class MyJobs extends StatefulWidget {
  static const routeName = 'myJobs';

  @override
  State<StatefulWidget> createState() {
    return MyJobsState();
  }
}

class MyJobsState extends State<MyJobs> {
  late List<MyJobData> myJobsList = [];
  late Data userData;
  bool ascending = true;
  bool isLoading = true;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (myJobsList.length > 0
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                          icon: Icon(
                              ascending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 30,
                              color: Colors.grey.shade600),
                          label: Text(
                            "Sort By Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            setState(() {
                              sortList();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: myJobsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              color: Theme.of(context).backgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              myJobsList[index].title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              JobStatusType
                                                  .values[
                                                      myJobsList[index].status]
                                                  .name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 10),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Icon(
                                                Icons.circle,
                                                color: JobStatusType
                                                    .values[myJobsList[index]
                                                        .status]
                                                    .color,
                                                size: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      child: Text(
                                        "Preferred Date : " +
                                            myJobsList[index].date,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Text(
                                        myJobsList[index].detail,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              openJobDetail(myJobsList[index].id);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('No data'),
                )),
    );
  }

  void openJobDetail(String id) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => JobDetails(
                  orderId: id,
                )))
        .then((val) => (val != null && val) ? getUserData() : null);
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null && userData.providerId.isNotEmpty) {
      getData();
    }
  }

  void getData() {
    if (userData != null && userData.providerId.isNotEmpty) {
      setState(() {
        isLoading = true;
        myJobsList.clear();
      });
      JobRequest request = new JobRequest(
          orderModel: new OrderModel(providerId: userData.providerId));
      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          APIManager apiManager = new APIManager();
          apiManager.myJob(request).then((value) async {
            MyJobResponse jobResponse = value;

            setState(() {
              isLoading = false;
              if (jobResponse.data != null) {
                if (jobResponse.data != null) {
                  myJobsList.addAll(jobResponse.data);
                  addDateTime();
                }
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
                  getData();
                },
              ),
            ),
          );
        }
      });
    }
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

  void sortList() {
    setState(() {
      if (ascending) {
        myJobsList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        ascending = false;
      } else {
        myJobsList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        ascending = true;
      }
    });
  }

  void addDateTime() {
    for (int i = 0; i < myJobsList.length; i++) {
      DateTime dateTime =
          new DateFormat("yyyy-MM-dd").parse(myJobsList[i].date);
      myJobsList[i].dateTime = dateTime;
    }
  }
}
