import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/common/Utility.dart' as Utility;
import 'package:nakli_beta_service_provider/rest/APIManager.dart';
import 'package:nakli_beta_service_provider/rest/response/FAQResponse.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatefulWidget {
  static const routeName = '/helpAndSupport';

  @override
  State<StatefulWidget> createState() {
    return HelpAndSupportState();
  }
}

class HelpAndSupportState extends State<HelpAndSupport> {
  late List<FAQData> faqsList = [];
  bool isLoading = true;

  @override
  void initState() {
    getFAQs();
    super.initState();
  }


  String htmlData = """<div>
  <h1>Demo Page</h1>
  <p>This is a fantastic product that you should buy!</p>
  <h3>Features</h3>
  <ul>
    <li>It actually works</li>
    <li>It exists</li>
    <li>It doesn't cost much!</li>
  </ul>
  <!--You can pretty much put any html in here!-->
</div>""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Help And Support',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        body:
        (isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : faqsList.length > 0
                ? ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: faqsList.length,
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5, top: 10),
                                child: Text(
                                  faqsList[index].questions,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Html(
                                  data:
                                    faqsList[index].answers,
                                  onLinkTap: (link, renderContext, map, element) async {
                                    if (link != null && link.isNotEmpty) {
                                      await launch(link);
                                    }
                                  },
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
                : const Center(child: Text('No data'))));
  }

  getFAQs() async {
    Utility.checkInternetConnection().then((internet) {
      if (internet) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        APIManager apiManager = new APIManager();
        apiManager.faq().then((value) async {
          FAQResponse response = value;
          setState(() {
            isLoading = false;
            if (response.data != null) {
              faqsList.addAll(response.data);
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
                getFAQs();
              },
            ),
          ),
        );
      }
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
}
