import 'package:flutter/material.dart';

class SearchSelectPage extends StatefulWidget {
  static const routeName = '/searchSelectPage';
  final String title;
  final List<SearchData> dataList;
  final int isRadioSelected;

  const SearchSelectPage(
      {required this.title,
      required this.dataList,
      required this.isRadioSelected});

  @override
  State<StatefulWidget> createState() {
    return SearchSelectPageState();
  }
}

class SearchSelectPageState extends State<SearchSelectPage> {
  late List<SearchData> _searchResult = [];
  final _controller = new TextEditingController();
  late SearchData searchData;
  late int isRadioSelected = -1;

  @override
  void initState() {
    if (widget.dataList.length > 0) _searchResult.addAll(widget.dataList);
    isRadioSelected = widget.isRadioSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            child: Text('Done',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              if (searchData != null && isRadioSelected != -1)
                Navigator.of(context).pop(searchData);
            },
          ),
        ],
        title: Text(widget.title,
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: widget.dataList.length > 0
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.search,
                        size: 20, color: Colors.grey.shade600),
                    title: new TextField(
                      controller: _controller,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      decoration: new InputDecoration(
                          hintText: 'Searchss', border: InputBorder.none),
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
                    padding: EdgeInsets.zero,
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          contentPadding: EdgeInsets.only(left: 15),
                          title: Text(_searchResult[index].name),
                          value: index,
                          groupValue: isRadioSelected,
                          onChanged: (value) {
                            setState(() {
                              isRadioSelected = index;
                              searchData = _searchResult[index];
                            });
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: 0,
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
      widget.dataList.forEach((data) {
        if (data.name.toUpperCase().contains(text.toUpperCase()))
          _searchResult.add(data);
      });
    }
    setState(() {});
  }
}

class SearchData {
  int id;
  String name;
  SearchData(this.id, this.name);
}
