import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final String text;
  final String amount;
  final String taxable_amount;
  final String preferredDate;
  final int taxPercentage;
  final int taxPercentage2;
  final int taxPercentage3;
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
      required this.amount,
      required this.taxable_amount,
      required this.taxPercentage2,
      required this.taxPercentage3,
      required this.text});

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
  final _validateIGST = TextEditingController(text: "0");
  final _showCGST = TextEditingController(text: "0");
  final _showSGST = TextEditingController(text: "0");
  final _showIGST = TextEditingController(text: "0");
  final _focusNodeCGST = FocusNode();
  final _focusNodeSGST = FocusNode();
  final _focusNodeAmount = FocusNode();
  final _focusNodeIGST = FocusNode();
  double yourEarning = 0, partnerShare = 0, tax = 0, tax1 = 0, totalAmount = 0;
  late bool gstEnable;
  late bool igstEnable;

  @override
  void initState() {
    if (widget.updateQuotation) {
      _validateQuotation.text = widget.text;
      _validategst.text = widget.taxPercentage.toString();
      _validateSGST.text = widget.taxPercentage2.toString();
      _validateIGST.text = widget.taxPercentage3.toString();
      _validateAmount.text = widget.taxable_amount;
      totalAmount = double.parse(widget.amount);
      if (widget.taxPercentage > 0) {
        gstEnable = true;
        igstEnable = false;
        tax = (double.parse(widget.taxable_amount) *
            double.parse(
                _validategst.value.text)) /
            100;
        _showCGST.text = tax.toString();
        _showSGST.text = tax.toString();
      } else if (widget.taxPercentage3 > 0) {
        gstEnable = false;
        igstEnable = true;
        tax = (double.parse(widget.taxable_amount) *
            double.parse(
                _validateIGST.value.text)) /
            100;
        _showIGST.text = tax.toString();
      } else {
        gstEnable = true;
        igstEnable = true;
      }
    } else {
      gstEnable = false;
      igstEnable = false;
    }
    _focusNodeCGST.addListener(() {
      if (_focusNodeCGST.hasFocus) {
        _validategst.selection = TextSelection(
            baseOffset: 0, extentOffset: _validategst.text.length);
      }
    });
    _focusNodeSGST.addListener(() {
      if (_focusNodeSGST.hasFocus) {
        _validateSGST.selection = TextSelection(
            baseOffset: 0, extentOffset: _validateSGST.text.length);
      }
    });
    _focusNodeAmount.addListener(() {
      if (_focusNodeAmount.hasFocus) {
        _validateAmount.selection = TextSelection(
            baseOffset: 0, extentOffset: _validateAmount.text.length);
      }
    });
    _focusNodeIGST.addListener(() {
      if (_focusNodeIGST.hasFocus) {
        _validateIGST.selection = TextSelection(
            baseOffset: 0, extentOffset: _validateIGST.text.length);
      }
    });
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
                      maxLines: 6,
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
                                focusNode: _focusNodeAmount,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    gstEnable = true;
                                    igstEnable = true;
                                    int amount = int.parse(value);
                                    tax = (amount *
                                            double.parse(
                                                _validategst.value.text)) /
                                        100;
                                    tax1 = (amount *
                                            double.parse(
                                                _validateSGST.value.text)) /
                                        100;
                                    // tax = (amount * widget.taxPercentage) / 100;
                                    totalAmount = amount + tax + tax1;
                                    // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                    // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
                                    setState(() {});
                                  } else {
                                    totalAmount = 0.0;
                                    gstEnable = false;
                                    igstEnable = false;
                                    _validateAmount.text = "0";
                                    _validateAmount.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _validateAmount.text.length);
                                    setState(() {});
                                  }
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 16),
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
                            Flexible(
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
                            Flexible(
                                child: TextField(
                              controller: _validategst,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              focusNode: _focusNodeCGST,
                              enabled: gstEnable,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  igstEnable = false;
                                  _validateIGST.text = "0";
                                  _showIGST.text = "0";
                                  int amount = int.parse(_validateAmount.text);
                                  if (amount > 0) {
                                    tax = (amount * int.parse(value)) / 100;
                                    // tax1 = (amount * int.parse(value)) / 100;
                                    // tax1 = (amount *
                                    //         double.parse(
                                    //             _validateSGST.value.text)) /
                                    //     100;
                                    // tax = (amount * widget.taxPercentage) / 100;
                                    totalAmount = amount + tax + tax;
                                    _validateSGST.text = value.toString();
                                    _showCGST.text = tax.toString();
                                    _showSGST.text = tax.toString();
                                  }

                                  // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                  // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;

                                  setState(() {});
                                } else {
                                  igstEnable = true;
                                  int amount = int.parse(_validateAmount.text);
                                  _validategst.text = "0";
                                  _validateSGST.text = "0";
                                  _showCGST.text = "0";
                                  _showSGST.text = "0";
                                  totalAmount = amount.toDouble();
                                  _validategst.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _validategst.text.length);
                                  setState(() {});
                                }
                              },
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade900,
                                  fontSize: 16),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your gst%',
                                errorText: validategst ? 'gst% missing' : null,
                                errorStyle: TextStyle(
                                    color: Colors.red.shade500, fontSize: 14),
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                suffixIcon: Icon(
                                  FontAwesomeIcons.percent,
                                  size: 13, //Icon Size
                                  color: Colors.grey, //Color Of Icon
                                ),
                              ),
                            )),
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextField(
                                  controller: _showCGST,
                                  textAlign: TextAlign.start,
                                  enabled: false,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade900,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      hintText: 'Enter your gst%',
                                      errorText:
                                          validategst ? 'gst% missing' : null,
                                      errorStyle: TextStyle(
                                          color: Colors.red.shade500,
                                          fontSize: 14),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
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
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 2.0),
                                      )),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
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
                            Flexible(
                              child: TextField(
                                controller: _validateSGST,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                focusNode: _focusNodeSGST,
                                enabled: gstEnable,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    igstEnable = false;
                                    _validateIGST.text = "0";
                                    _showIGST.text = "0";
                                    int amount =
                                        int.parse(_validateAmount.text);
                                    if (amount > 0) {
                                      tax = (amount * int.parse(value)) / 100;
                                      // tax = (amount *
                                      //         double.parse(
                                      //             _validategst.value.text)) /
                                      //     100;
                                      // tax1 = (amount * double.parse(value)) / 100;
                                      // tax = (amount * widget.taxPercentage) / 100;
                                      totalAmount = amount + tax + tax;
                                      _validategst.text = value.toString();
                                      _showCGST.text = tax.toString();
                                      _showSGST.text = tax.toString();
                                      // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                      // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
                                    }
                                    setState(() {});
                                  } else {
                                    igstEnable = true;
                                    int amount =
                                        int.parse(_validateAmount.text);
                                    _validategst.text = "0";
                                    _validateSGST.text = "0";
                                    _showCGST.text = "0";
                                    _showSGST.text = "0";
                                    totalAmount = amount.toDouble();
                                    _validateSGST.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _validateSGST.text.length);
                                    setState(() {});
                                  }
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter your gst%',
                                  errorText:
                                      validateSGST ? 'SGST% missing' : null,
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
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0),
                                  ),
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.percent,
                                    size: 13, //Icon Size
                                    color: Colors.grey, //Color Of Icon
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TextField(
                                controller: _showSGST,
                                textAlign: TextAlign.start,
                                enabled: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    hintText: 'Enter your gst%',
                                    errorText:
                                        validateSGST ? 'SGST% missing' : null,
                                    errorStyle: TextStyle(
                                        color: Colors.red.shade500,
                                        fontSize: 14),
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
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2.0),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "IGST @ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Flexible(
                                child: TextField(
                              controller: _validateIGST,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              focusNode: _focusNodeIGST,
                              enabled: igstEnable,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  gstEnable = false;
                                  _validateSGST.text = "0";
                                  _validategst.text = "0";
                                  _showCGST.text = "0";
                                  _showSGST.text = "0";
                                  int amount = int.parse(_validateAmount.text);
                                  tax = (amount * int.parse(value)) / 100;
                                  // tax1 = (amount * int.parse(value)) / 100;
                                  // tax1 = (amount *
                                  //         double.parse(
                                  //             _validateSGST.value.text)) /
                                  //     100;
                                  // tax = (amount * widget.taxPercentage) / 100;
                                  totalAmount = amount + tax;
                                  _showIGST.text = tax.toString();
                                  // yourEarning = (totalAmount * widget.providerPercentage) / 100;
                                  // partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;

                                  setState(() {});
                                } else {
                                  gstEnable = true;
                                  int amount = int.parse(_validateAmount.text);
                                  _validateIGST.text = "0";
                                  _showIGST.text = "0";
                                  totalAmount = amount.toDouble();
                                  _validateIGST.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _validateIGST.text.length);
                                  setState(() {});
                                }
                              },
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade900,
                                  fontSize: 16),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your gst%',
                                errorText: validategst ? 'gst% missing' : null,
                                errorStyle: TextStyle(
                                    color: Colors.red.shade500, fontSize: 14),
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2.0),
                                ),
                                suffixIcon: Icon(
                                  FontAwesomeIcons.percent,
                                  size: 13, //Icon Size
                                  color: Colors.grey, //Color Of Icon
                                ),
                              ),
                            )),
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextField(
                                  controller: _showIGST,
                                  textAlign: TextAlign.start,
                                  enabled: false,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade900,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      hintText: 'Enter your gst%',
                                      errorText:
                                          validategst ? 'gst% missing' : null,
                                      errorStyle: TextStyle(
                                          color: Colors.red.shade500,
                                          fontSize: 14),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
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
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 2.0),
                                      )),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 4,
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
                                  "\u20B9" + totalAmount.toString() + '/-',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                      fontSize: 16),
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
                                      amount: _validateAmount.text.toString(),
                                      gst: _validategst.text.toString(),
                                      sgst: _validateSGST.text.toString(),
                                      igst: _validateIGST.text.toString(),
                                      taxType: gstEnable));
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
      totalAmount = amount + tax + tax1;
      yourEarning = (totalAmount * widget.providerPercentage) / 100;
      partnerShare = (totalAmount * (100 - widget.providerPercentage)) / 100;
      setState(() {});
    }
  }
}
