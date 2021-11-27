import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  static List<CategorySelectionList> selectedCategoryList = [];
  final _controller = new TextEditingController();

  @override
  void initState() {
    if (widget.dataList.length > 0) {
      _searchResult.addAll(widget.dataList);
      // for (int i = 0; i < _searchResult.length; i++) {
      //   _searchResult[i].serviceDetails.forEach((element) {
      //     if (element.selected) {
      //       CategorySelectionList categorySelectionList = new CategorySelectionList(name: element.name, id: element.id);
      //       selectedCategoryList.add(categorySelectionList);
      //     }
      //   });
      // }
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
                Navigator.of(context).pop(selectedCategoryList);
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
          selectedCategoryList.length>0?Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 45,
              width: Get.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Chip(
                        label: Text(
                            selectedCategoryList[index].name,
                            style: TextStyle(color: Colors.grey[600],fontSize: 16)),
                        elevation: 10,
                        shadowColor: Colors.black45,
                        backgroundColor: Colors.amber.withOpacity(0.4),
                        onDeleted: () {
                          removeCheckFromList(index);
                          setState(() {
                          });
                        },
                        deleteIcon: Icon(
                          Icons.close,
                          size: 23,
                        ),
                      ),
                    );
                  },
                  itemCount: selectedCategoryList.length
                // filterController.hotelAmenitiesSelectionList.value.length,
              ),
            ),
          ):Container(),
          Expanded(
              child: ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (context, i) {
                  return new ExpansionTile(
                    leading: Icon(Icons.arrow_drop_down),
                    trailing: IconButton(
                      onPressed: () {
                        if(_searchResult[i].selected){
                          _searchResult[i].selected = !_searchResult[i].selected;
                          _searchResult[i].serviceDetails.forEach((element) {
                            element.selected = false;
                            selectedCategoryList.removeWhere((item) => item.name == element.name);
                          });
                        }else{
                          _searchResult[i].selected  = true;
                          _searchResult[i].serviceDetails.forEach((element) {
                            var name = element.name;
                            int i = selectedCategoryList.indexWhere((element) => element.name == name);
                            if(i>=0){
                              selectedCategoryList.removeAt(i);
                            }
                          });
                          _searchResult[i].serviceDetails.forEach((element) {
                            element.selected = true;
                            CategorySelectionList categorySelectionList = new CategorySelectionList(name: element.name, id: _searchResult[i].id,subCategoryId: element.id);
                            selectedCategoryList.add(categorySelectionList);
                          });
                        }
                        int detailLength = _searchResult[i]
                            .serviceDetails
                            .where((element) => element.selected == true)
                            .length;
                        _searchResult[i].checkedCount = detailLength;
                        setState(() {
                        });
                      },
                      icon: Icon(_searchResult[i].selected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                          color: (_searchResult[i].selected
                              ? Colors.grey.shade600
                              : Colors.grey.shade600)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Flexible(child: Text(
                        _searchResult[i].subcategoryName,
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,),
                      )),
                      _searchResult[i].checkedCount==0?Container():Text(
                        " ("+_searchResult[i].checkedCount.toString()+")",
                        style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,),
                      )
                    ],),
                    collapsedBackgroundColor: Colors.grey[100],
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    children: <Widget>[
                      new Column(
                        children:
                        _buildExpandableContent(_searchResult[i], i),
                      ),
                    ],
                  );
                },
              )),
        ],
      )
          : const Center(child: Text('No data')),
    );
  }

  _buildExpandableContent(SearchCategoryData categoryData, int index) {
    List<Widget> columnContent = [];
    categoryData.serviceDetails.forEach((element) {
      columnContent.add(
        new CheckboxListTile(
          title: new Text(
            element.name,
            style: new TextStyle(fontSize: 18.0,color: Colors.grey[700]),
          ),
          // value: categoryData,
          onChanged: (val) {
            element.selected = val!;
            int servicelength =
                _searchResult[index].serviceDetails.length;
            int detailLength = _searchResult[index]
                .serviceDetails
                .where((element) => element.selected == true)
                .length;
            if (servicelength == detailLength) {
              _searchResult[index].selected = true;
            }else{
              _searchResult[index].selected = false;
            }
            selectItem(index,element);
          },
          activeColor: Colors.amber,
          value: element.selected,
          // leading: new Icon(vehicle.icon),
        ),
      );
    });
    return columnContent;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      _searchResult.addAll(widget.dataList);
    } else {
      widget.dataList.forEach((data) {
        if (data.subcategoryName.toUpperCase().contains(text.toUpperCase())){
          _searchResult.add(data);
        }else{
          data.serviceDetails.forEach((element) {
            if (element.name.toUpperCase().contains(text.toUpperCase())){
              _searchResult.add(data);
            }
          });
        }
      });
    }
    setState(() {});
  }

  void selectItem(int index, ServiceDetails element) {
    setState(() {
      if (element.selected) {
        CategorySelectionList categorySelectionList = new CategorySelectionList(name: element.name, id: _searchResult[index].id,subCategoryId: element.id);
        selectedCategoryList.add(categorySelectionList);
      } else {
        selectedCategoryList.removeWhere((item) => item.name == element.name);
      }
      int detailLth = _searchResult[index]
          .serviceDetails
          .where((element) => element.selected == true)
          .length;
      _searchResult[index].checkedCount = detailLth;
    });
  }

  void removeCheckFromList(int index) {
    var id = selectedCategoryList[index].id;
    var name = selectedCategoryList[index].name;
    var abc = _searchResult.firstWhere((element) => element.id == id);
    var ab = abc.serviceDetails.firstWhere((element) => element.name == name);
    ab.selected = false;
    selectedCategoryList.removeAt(index);
    int i = _searchResult.indexWhere((element) => element.id == id);
    int servicelength =
        _searchResult[i].serviceDetails.length;
    int detailLength = _searchResult[i]
        .serviceDetails
        .where((element) => element.selected == true)
        .length;
    _searchResult[i].checkedCount = detailLength;
    if (servicelength == detailLength) {
      _searchResult[i].selected = true;
    }else{
      _searchResult[i].selected = false;
    }
  }
}

class SearchCategoryData {
  int id;
  bool selected = false;
  String subcategoryName;
  int checkedCount;
  List<ServiceDetails> serviceDetails;

  SearchCategoryData(
      this.id, this.subcategoryName, this.serviceDetails, this.selected,this.checkedCount);
}

class ServiceDetails {
  ServiceDetails(
      {required this.name, required this.id, required this.selected});

  String name;
  int id;
  bool selected = false;
}

class CategorySelectionList {
  CategorySelectionList(
      {required this.name, required this.id,required this.subCategoryId});

  String name;
  int id;
  int subCategoryId;
}
