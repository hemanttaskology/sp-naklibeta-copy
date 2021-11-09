import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nakli_beta_service_provider/pages/PaymentsComplete.dart';

import 'PaymentsPending.dart';

class Payments extends StatefulWidget {
  static const routeName = 'payments';

  @override
  State<StatefulWidget> createState() {
    return PaymentsState();
  }
}

class PaymentsState extends State<Payments>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                unselectedLabelColor: Theme.of(context).primaryColor,
                labelColor: Colors.white,
                labelPadding: EdgeInsets.all(5.0),
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      "Complete",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Pending",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [PaymentsComplete(), PaymentsPending()],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
