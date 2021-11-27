import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nakli_beta_service_provider/Controllers/NotificationController.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/JobType.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/pages/JobList.dart';
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/JobRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/JobResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'JobDetails.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late List<Job> jobList = [];
  late List<Job> todayJobList = [];
  late List<Job> upcomingJobList = [];
  late String message = '';
  late Data userData;
  bool isLoading = true;
  bool isFistimeLoad = true;
  late Timer timer;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: UpgradeAlert(child:(isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : userData.status != 1 ?Container(
          padding: EdgeInsets.fromLTRB(40,0,40,0),
          child: const Center(
              child: Text('Welcome Naklibeta Service Partners. Please Submit Your KYC to Activate your Profile.', style: TextStyle(
                fontStyle:FontStyle.italic,

              ),)
          ),
        ):(upcomingJobList.length == 0 &&
                    jobList.length == 0 &&
                    todayJobList.length == 0)
                ? Container(
          padding: EdgeInsets.fromLTRB(40,0,40,0),
          child: const Center(
                   child: Text('Welcome Naklibeta Partner. Kindly wait for new job.', style: TextStyle(
                     fontStyle:FontStyle.italic,

                   ),)
          ),
                )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        (message.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox.shrink()),
                        (jobList.length > 0
                            ? Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            JobType.JOBS.title,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          getViewMoreButton(jobList.length,
                                              JobType.JOBS, jobList),
                                        ],
                                      ),
                                    ),
                                    getWidget(
                                        context,
                                        jobList.length > 2 ? 2 : jobList.length,
                                        jobList),
                                  ],
                                ),
                              )
                            : SizedBox.shrink()),
                        (todayJobList.length > 0
                            ? Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            JobType.TODAY.title,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          getViewMoreButton(todayJobList.length,
                                              JobType.TODAY, todayJobList),
                                        ],
                                      ),
                                    ),
                                    getWidget(
                                        context,
                                        todayJobList.length > 2
                                            ? 2
                                            : todayJobList.length,
                                        todayJobList),
                                  ],
                                ),
                              )
                            : SizedBox.shrink()),
                        (upcomingJobList.length > 0
                            ? Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            JobType.UPCOMING.title,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          getViewMoreButton(
                                              upcomingJobList.length,
                                              JobType.UPCOMING,
                                              upcomingJobList),
                                        ],
                                      ),
                                    ),
                                    getWidget(
                                        context,
                                        upcomingJobList.length > 2
                                            ? 2
                                            : upcomingJobList.length,
                                        upcomingJobList),
                                  ],
                                ),
                              )
                            : SizedBox.shrink()),
                      ],
                    ),
                  ))));
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
    if (userData != null && userData.providerId.isNotEmpty) {
      setState(() {
        jobList.clear();
        todayJobList.clear();
        upcomingJobList.clear();
        message = '';
        isLoading = true;
      });
      if(isFistimeLoad){
        getData();
        isFistimeLoad = false;
        timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
          getData();
        });
      }else{
        timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
          getData();
        });
      }
    }
  }

  void getData() {
    print("timmer start");
    jobList = [];
    todayJobList = [];
    upcomingJobList = [];
    if (userData != null && userData.providerId.isNotEmpty) {
      JobRequest request = new JobRequest(
          orderModel: new OrderModel(providerId: userData.providerId));
      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          APIManager apiManager = new APIManager();
          apiManager.getJob(request).then((value) async {
            JobResponse jobResponse = value;
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              isLoading = false;
              userData.status = jobResponse.data.status;
              prefs.setString(AppConstants.USER_DETAIL, json.encode(userData));

              message = jobResponse.message;
              if (jobResponse.data != null) {
                if (jobResponse.data.category != null) {
                  jobList.addAll(jobResponse.data.category);
                }
                if (jobResponse.data.upcoming != null) {
                  upcomingJobList.addAll(jobResponse.data.upcoming);
                }
                if (jobResponse.data.today != null) {
                  todayJobList.addAll(jobResponse.data.today);
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

  getWidget(
    BuildContext context,
    int length,
    List<Job> list,
  ) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.2,
      crossAxisSpacing: 2.0,
      children: List.generate(length, (index) {
        return GestureDetector(
          child: Card(
            color: Theme.of(context).backgroundColor,
            shape: new RoundedRectangleBorder(
                side: new BorderSide(
                    color: Theme.of(context).primaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.grey,
                        size: 40,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            (list[index].title != null &&
                                    list[index].title.isNotEmpty)
                                ? list[index].title
                                : list[index].orderId,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (Colors.black),
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, top: 5),
                      child: Text(
                        list[index].requirement,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 5),
                        child: Text(
                          'Preferred Data : ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Text(
                          list[index].date,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => JobDetails(
                          orderId: list[index].orderId,
                        )))
                .then((val) => val != null ? getUserData() : null);
          },
        );
      }),
    );
  }

  getViewMoreButton(int length, JobType jobType, List<Job> jobList) {
    if (length > 2) {
      return TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => JobList(
                        title: jobType.title,
                        dataList: jobList,
                      )))
              .then((val) => val != null ? getUserData() : null);
        },
        child: Text(
          "View More ",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      );
    } else
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
}
