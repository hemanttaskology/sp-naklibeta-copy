import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/BaseRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/ReviewResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reviews extends StatefulWidget {
  static const routeName = '/reviews';

  @override
  State<StatefulWidget> createState() {
    return ReviewsState();
  }
}

class ReviewsState extends State<Reviews> {
  late List<ReviewData> reviewsList = [];
  bool isLoading = true;

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Reviews',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        body: (isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (reviewsList.length > 0
                ? ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: reviewsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Theme.of(context).backgroundColor,
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                    size: 70,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          reviewsList[index].name != null
                                              ? reviewsList[index].name
                                              : "",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (Colors.black),
                                              fontSize: 16),
                                        ),
                                      ),
                                      RatingBarIndicator(
                                        rating:
                                            reviewsList[index].ratings != null
                                                ? reviewsList[index]
                                                    .ratings
                                                    .toDouble()
                                                : 0,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 25.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, bottom: 10),
                                child: Text(
                                  reviewsList[index].review != null
                                      ? reviewsList[index].review
                                      : '',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Theme.of(context).backgroundColor,
                    ),
                  )
                : const Center(child: Text('No data')))));
  }

  getReviews() async {
    final prefs = await SharedPreferences.getInstance();
    Data userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));

    if (userData != null && userData.providerId.isNotEmpty) {
      BaseRequest request = new BaseRequest(
          providerModel: new BaseModel(providerId: userData.providerId));

      Utility.checkInternetConnection().then((internet) {
        if (internet) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          APIManager apiManager = new APIManager();
          apiManager.review(request).then((value) async {
            ReviewResponse reviewResponse = value;
            setState(() {
              isLoading = false;
              if (reviewResponse.data != null) {
                reviewsList.addAll(reviewResponse.data);
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
                  getReviews();
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
}
