import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nakli_beta_service_provider/pages/Terms.dart';
class About extends StatefulWidget {
  static const routeName = '/about';
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("About Us", style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5,left: 5,bottom: 5),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Terms.routeName,
                );
              },
              title: Text(
                'Terms & Conditions',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
