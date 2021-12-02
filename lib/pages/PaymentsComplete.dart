import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/BaseRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/PaymentResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsComplete extends StatefulWidget {
  static const routeName = 'paymentsComplete';

  @override
  State<StatefulWidget> createState() {
    return PaymentsCompleteState();
  }
}

class PaymentsCompleteState extends State<PaymentsComplete> {
  late List<Payment> paymentsList = [];
  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : paymentsList.length > 0
              ? ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemCount: paymentsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Theme.of(context).backgroundColor,
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    paymentsList[index].date != null
                                        ? paymentsList[index].date
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order ID : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    paymentsList[index].orderId,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Amount : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    paymentsList[index].totalAmount.toString() +
                                        '/-',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Your Earning : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    paymentsList[index].yourEarning.toString() +
                                        '/-',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            paymentsList[index].status==9||paymentsList[index].status==10?Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Status : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "Refunded",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    color: Theme.of(context).backgroundColor,
                    height: 8,
                  ),
                )
              : const Center(child: Text('No data')),
    );
  }

  Future<void> getData() async {
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
          apiManager.paymentComplete(request).then((value) async {
            PaymentResponse response = value;
            setState(() {
              isLoading = false;
              paymentsList.addAll(response.data);
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
}
