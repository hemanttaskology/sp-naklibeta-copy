import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
  } on SocketException catch (err) {
    return false;
  }
  return false;
}

snackBar(String? message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message!),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}
