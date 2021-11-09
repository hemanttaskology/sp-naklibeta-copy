import 'package:flutter/material.dart';

class SearchCategoryPage extends StatefulWidget {
  static const routeName = '/searchCategoryPage';
  late String title;
  late List<SearchCategoryData> dataList;

  SearchCategoryPage({
    required this.title,
    required this.dataList,
  });

  @override
  State<StatefulWidget> createState() {
    return SearchCategoryPageState();
  }
}

class SearchCategoryPageState extends State<SearchCategoryPage> {
  late List<SearchCategoryData> _searchResult = [];
  final List<String> selectedCategoryList = [];

  final _controller = new TextEditingController();

  @override
  void initState() {
    if (widget.dataList.length > 0) {
      _searchResult.addAll(widget.dataList);
      for (int i = 0; i < _searchResult.length; i++) {
        if (_searchResult[i].selected) {
          selectedCategoryList.add(_searchResult[i].name);
        }
      }
    }

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
              if (selectedCategoryList != null &&
                  selectedCategoryList.length > 0) {
                Navigator.of(context).pop(selectedCategoryList.join(','));
              }
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
                //after select category
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    (selectedCategoryList.length > 0
                        ? selectedCategoryList.join(', ')
                        : ''),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: 0),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        onTap: () {
                          selectItem(index);
                        },
                        leading: Icon(
                          _searchResult[index].selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: (_searchResult[index].selected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600),
                        ),
                        title: Text(
                          _searchResult[index].subcategoryName+" : "+_searchResult[index].name,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16),
                        ),
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
      widget.dataList.forEach((data) {
        if ((data.name.toUpperCase().contains(text.toUpperCase()))||(data.subcategoryName.toUpperCase().contains(text.toUpperCase())))
          _searchResult.add(data);
      });
    }
    setState(() {});
  }

  void selectItem(int index) {
    setState(() {
      _searchResult[index].selected = !_searchResult[index].selected;
      if (_searchResult[index].selected) {
        selectedCategoryList.add(_searchResult[index].name);
      } else {
        selectedCategoryList.remove(_searchResult[index].name);
      }
    });
  }
}

class SearchCategoryData {
  int id;
  String name;
  bool selected = false;

  String subcategoryName;
  SearchCategoryData(this.id,this.subcategoryName, this.name, this.selected);
}
