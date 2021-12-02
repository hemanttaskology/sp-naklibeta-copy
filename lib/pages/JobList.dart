import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nakli_beta_service_provider/common/AppConstants.dart'
    as AppConstants;
import 'package:nakli_beta_service_provider/rest/response/Data.dart';
import 'package:nakli_beta_service_provider/rest/response/JobResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JobDetails.dart';

class JobList extends StatefulWidget {
  static const routeName = '/jobList';
  final String title;
  final List<Job> dataList;

  const JobList({required this.title, required this.dataList});

  @override
  State<StatefulWidget> createState() {
    return JobListState();
  }
}

class JobListState extends State<JobList> {
  late List<Job> _searchResult = [];
  bool ascending = true;
  final _controller = new TextEditingController();
  late Data userData;

  @override
  void initState() {
    getUserData();
    _searchResult.addAll(widget.dataList);
    addDateTime();
    super.initState();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userData = Data.fromJson(
        json.decode(prefs.getString(AppConstants.USER_DETAIL).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            icon: Icon(ascending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 30, color: Colors.grey.shade600),
            label: Text(
              "Sort By Date",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              setState(() {
                sortList();
              });
            },
          ),
        ],
        titleSpacing: 2,
        title: Text(widget.title,
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: widget.dataList.length > 0
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.search,
                        size: 30, color: Colors.grey.shade600),
                    title: new TextField(
                      controller: _controller,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: IconButton(
                      icon: new Icon(Icons.clear,
                          size: 20, color: Colors.grey.shade600),
                      onPressed: () {
                        _controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                          color: Theme.of(context).backgroundColor,
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        _searchResult[index].orderId,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: (Colors.black),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    _searchResult[index].requirement,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
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
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 5),
                                      child: Text(
                                        _searchResult[index].date,
                                        overflow: TextOverflow.ellipsis,
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
                          openJobDetail(_searchResult[index].orderId);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: Text('No data')),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      _searchResult.addAll(widget.dataList);
    } else {
      widget.dataList.forEach((userDetail) {
        if (userDetail.requirement.toUpperCase().contains(text.toUpperCase()) ||
            userDetail.orderId.toUpperCase().contains(text.toUpperCase()))
          _searchResult.add(userDetail);
      });
    }
    setState(() {});
  }

  void sortList() {
    setState(() {
      if (ascending) {
        _searchResult.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      } else {
        _searchResult.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      }
      ascending = !ascending;
    });
  }

  void addDateTime() {
    for (int i = 0; i < _searchResult.length; i++) {
      DateTime dateTime =
          new DateFormat("yyyy-MM-dd").parse(_searchResult[i].date);
      _searchResult[i].dateTime = dateTime;

      //-------------Formatting Local date------------------------

      var stringFormat = _searchResult[i].date;
      var SplittedDate = stringFormat.split('-');
      var FormattedDate = SplittedDate[2]+'-'+SplittedDate[1]+'-'+SplittedDate[0];
      _searchResult[i].date = FormattedDate;
    }
  }

  void openJobDetail(String id) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => JobDetails(
                  orderId: id.toString(),
                )))
        .then((val) => val != null ? Navigator.pop(context, true) : null);
  }
}
