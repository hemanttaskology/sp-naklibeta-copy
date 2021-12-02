import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Terms extends StatefulWidget {
  static const routeName = '/terms';
  const Terms({Key? key}) : super(key: key);

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Terms & Conditions", style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: WebView(
        initialUrl: 'https://naklibeta.com/pages/sp-terms.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        // navigationDelegate: (NavigationRequest request) {
        //   if (request.url.startsWith('https://www.youtube.com/')) {
        //     print('blocking navigation to $request}');
        //     return NavigationDecision.prevent;
        //   }
        //   print('allowing navigation to $request');
        //   return NavigationDecision.navigate;
        // },
        // onPageStarted: (String url) {
        //   print('Page started loading: $url');
        // },
        // onPageFinished: (String url) {
        //   print('Page finished loading: $url');
        // },
        gestureNavigationEnabled: true,
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
