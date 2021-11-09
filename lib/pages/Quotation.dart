import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/ScreenArguments.dart';
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/request/QuotationRequest.dart';
import 'package:nakli_beta_service_provider/rest/response/QuotationResponse.dart';

class Quotation extends StatefulWidget {
  static const routeName = '/quotation';
  final String orderId;
  final String detail;
  final String preferredDate;
  final int taxPercentage;
  final int providerPercentage;
  final bool updateQuotation;
  final int taxStatus;

  const Quotation(
      {required this.orderId,
      required this.detail,
      required this.preferredDate,
      required this.taxPercentage,
      required this.providerPercentage,
      required this.updateQuotation,
      required this.taxStatus,
      });

  @override
  State<StatefulWidget> createState() {
    return QuotationState();
  }
}

class QuotationState extends State<Quotation> {
  late ScreenArguments args;
  bool validateQuotation = false;
  bool validateAmount = false;
  bool validategst = false;
  bool validateSGST = false;
  final _validateQuotation = TextEditingController();
  final _validateAmount = TextEditingController(text: "0");
  final _validategst = TextEditingController(text: "0");
  final _validateSGST = TextEditingController(text: "0");
  double yourEarning = 0, partnerShare = 0, tax = 0,tax1=0, totalAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quotation",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Text(
                      widget.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      'Preferred Date : ' + widget.preferredDate,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: TextField(
                      controller: _validateQuotation,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      style: TextStyle(color: Colors.grey.shade900),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10, 10, 12),
                        labelText: '',
                        hintText: 'Quotation Description :',
                        errorText:
                            validateQuotation ? 'Quotation is missing' : null,
                        labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        errorStyle:
                            TextStyle(color: Colors.red.shade500, fontSize: 12),
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
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "Amount : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade900,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _validateAmount,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                onChanged: (value){
                                  if (value.isNotEmpty) {
                                    int amount = int.parse(value);
                                    tax = (amount * double.parse(_validategst.value.text)) / 100;
                                    tax1 = (amount * double.parse(_validateSGST.value.text)) / 100;
                                    // tax = (amount * widget.taxPercentage) / 100;
                                    totalAmount = amount + tax+tax1;
                                    // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                    // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
                                    setState(() {});
                                  }else{
                                    _validateAmount.text = "0";
                                  }
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Amount',
                                  errorText: validateAmount
                                      ? 'Amount is missing'
                                      : null,
                                  errorStyle: TextStyle(
                                      color: Colors.red.shade500, fontSize: 14),
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "CGST @ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _validategst,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                onChanged: (value){
                                  if (value.isNotEmpty) {
                                    int amount = int.parse(_validateAmount.text);
                                    tax = (amount * int.parse(value)) / 100;
                                    tax1 = (amount * double.parse(_validateSGST.value.text)) / 100;
                                    // tax = (amount * widget.taxPercentage) / 100;
                                    totalAmount = amount + tax+tax1;
                                    // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                    // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
                                    setState(() {});
                                  }else{
                                    _validategst.text = "0";
                                  }
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter your gst%',
                                  errorText: validategst
                                      ? 'gst% missing'
                                      : null,
                                  errorStyle: TextStyle(
                                      color: Colors.red.shade500, fontSize: 14),
                                  hintStyle:
                                  TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "SGST @ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _validateSGST,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                onChanged: (value){
                                  if (value.isNotEmpty) {
                                    int amount = int.parse(_validateAmount.text);
                                    tax = (amount *  double.parse(_validategst.value.text)) / 100;
                                    tax1 = (amount * double.parse(value)) / 100;
                                    // tax = (amount * widget.taxPercentage) / 100;
                                    totalAmount = amount + tax+tax1;
                                    // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                    // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
                                    setState(() {});
                                  }else{
                                    _validateSGST.text = "0";
                                  }
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter your gst%',
                                  errorText: validateSGST
                                      ? 'SGST% missing'
                                      : null,
                                  errorStyle: TextStyle(
                                      color: Colors.red.shade500, fontSize: 14),
                                  hintStyle:
                                  TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListTile(
                                minVerticalPadding: 2,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "Total Amount : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                                subtitle: Text(
                                  "* Inclusive of all taxes ",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  totalAmount.toString() + '/-',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   '( Your Earning  :  ' +
                        //       yourEarning.toString() +
                        //       '/- )',
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //       letterSpacing: 0.2,
                        //       fontSize: 14),
                        // ),
                        // Text(
                        //   '( Company Share  :  ' +
                        //       partnerShare.toString() +
                        //       '/- )',
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //       letterSpacing: 0.2,
                        //       fontSize: 14),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            validateQuotation =
                                _validateQuotation.text.toString().isEmpty
                                    ? true
                                    : false;

                            validateAmount =
                                _validateAmount.text.toString().isEmpty
                                    ? true
                                    : false;

                            if (!validateQuotation && !validateAmount) {
                              QuotationRequest request = new QuotationRequest(
                                  orderModel: new Quotations(
                                      orderId: widget.orderId,
                                      quotation:
                                          _validateQuotation.text.toString(),
                                      amount: _validateAmount.text.toString(),gst: _validategst.text.toString(),sgst: _validateSGST.text.toString()));
                              submitQuotation(request);
                            }
                          });
                        },
                        child: Text(
                          ("SUBMIT"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  void submitQuotation(QuotationRequest request) {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        buildShowDialog(context);
        APIManager apiManager = new APIManager();
        apiManager
            .sendQuotation(widget.updateQuotation, request)
            .then((value) async {
          Navigator.pop(context);
          QuotationResponse response = value;
          Fluttertoast.showToast(
              msg: response.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              fontSize: 16.0);
          Navigator.pop(context, !widget.updateQuotation);
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

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      int amount = int.parse(text);
      tax = (amount * int.parse(_validategst.value.text)) / 100;
      tax1 = (amount * int.parse(_validateSGST.value.text)) / 100;
      // tax = (amount * widget.taxPercentage) / 100;
      totalAmount = amount + tax+tax1;
      yourEarning = (totalAmount * widget.providerPercentage) / 100;
      partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
      setState(() {});
    }
  }
}
