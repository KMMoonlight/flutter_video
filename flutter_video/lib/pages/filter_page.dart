import 'package:flutter/material.dart';
import 'package:flutter_video/models/filter_data.dart';
import 'package:flutter_video/network/api.dart';
import 'package:flutter_video/pages/detail_page.dart';

// ignore: must_be_immutable
class FilterFragment extends StatefulWidget {
  String url = '';

  FilterFragment({this.url});

  @override
  _FilterFragmentState createState() => _FilterFragmentState();
}

class _FilterFragmentState extends State<FilterFragment> {
  FilterDataModel filterDataModel;

  void tapEvent(String url) {
    setState(() {
      filterDataModel = null;
      widget.url = url;
    });
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    getFilterPageData(widget.url).then((value) {
      setState(() {
        filterDataModel = FilterDataModel.formHTML(value);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更多'),
        brightness: Brightness.dark,
      ),
      body: filterDataModel == null
          ? Center(
              child: Text('Now Loading.....'),
            )
          : ListView(
              children: [
                FilterHeader(
                  filterDataModel: filterDataModel,
                  tapFilterCallback: tapEvent,
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFE3E3E3),
                ),
                VideoCardList(filterDataModel: filterDataModel),
                Divider(
                  height: 1,
                  color: Color(0xFFE3E3E3),
                ),
                FilterFooter(
                  filterDataModel: filterDataModel,
                  tapFilterCallback: tapEvent,
                )
              ],
            ),
    );
  }
}

class FilterHeader extends StatelessWidget {
  final Function tapFilterCallback;
  final FilterDataModel filterDataModel;

  FilterHeader({this.tapFilterCallback, this.filterDataModel});

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryList = [];

    categoryList.add(Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            child: GestureDetector(
              child: Center(
                child: Text(
                  filterDataModel.hotOrNewList[0].title,
                  style: TextStyle(
                      color: filterDataModel.hotOrNew == 0
                          ? Colors.white
                          : Colors.black,
                      backgroundColor: filterDataModel.hotOrNew == 0
                          ? Colors.orange
                          : Colors.white,
                      fontSize: 14),
                ),
              ),
              onTap: () {
                tapFilterCallback(filterDataModel.hotOrNewList[0].targetUrl);
              },
            ),
            width: 80,
          ),
          Container(
            child: GestureDetector(
              child: Center(
                child: Text(
                  filterDataModel.hotOrNewList[1].title,
                  style: TextStyle(
                      color: filterDataModel.hotOrNew == 1
                          ? Colors.white
                          : Colors.black,
                      backgroundColor: filterDataModel.hotOrNew == 1
                          ? Colors.orange
                          : Colors.white,
                      fontSize: 14),
                ),
              ),
              onTap: () {
                tapFilterCallback(filterDataModel.hotOrNewList[1].targetUrl);
              },
            ),
            width: 80,
          )
        ],
      ),
      margin: EdgeInsets.all(5),
    ));

    filterDataModel.categoryList.forEach((item) {
      categoryList.add(CategoryList(filterGroup: item, tapFilterCallback: tapFilterCallback));
    });

    return Container(
      child: Column(
        children: categoryList,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

class CategoryList extends StatelessWidget {

  final FilterGroup filterGroup;
  final Function tapFilterCallback;

  CategoryList({this.filterGroup, this.tapFilterCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.all(5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var currentItem = filterGroup.filterList[index];
          return currentItem.targetUrl == ''
              ? Container(
                  child: Center(
                    child: Text(
                      currentItem.title,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  width: 60)
              : Container(
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        currentItem.title,
                        style: TextStyle(
                            fontSize: 14,
                            color: filterGroup.currentIndex == index
                                ? Colors.white
                                : Colors.black,
                            backgroundColor: filterGroup.currentIndex == index
                                ? Colors.orange
                                : Colors.white),
                      ),
                    ),
                    onTap: () {
                      tapFilterCallback(currentItem.targetUrl);
                    },
                  ),
                  width: 60,
                );
        },
        itemCount: filterGroup.filterList.length,
      ),
    );
  }
}

class VideoCardList extends StatelessWidget {
  final FilterDataModel filterDataModel;

  VideoCardList({this.filterDataModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
      ),
      itemCount: filterDataModel.videoModelList.length,
      itemBuilder: (BuildContext context, int index) {
        var currentModel = filterDataModel.videoModelList[index];
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: !currentModel.videoImage.startsWith('https')
                        ? NetworkImage('https:${currentModel.videoImage}')
                        : NetworkImage(currentModel.videoImage),
                    fit: BoxFit.fill,
                    onError: (o, error) {

                    }
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                  )
                ]),
            margin: EdgeInsets.all(10),
            child: Container(
              child: Column(
                children: [
                  Text(
                    currentModel.videoTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    currentModel.videoInfo,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
              ),
              decoration: BoxDecoration(color: Color(0x33000000)),
              padding: EdgeInsets.all(5),
            ),
          ),
          onTap: () {
            // 跳转到详情页
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return DetailFragment(currentModel.videoUrl);
            }));
          },
        );
      },
    );
  }
}

class FilterFooter extends StatelessWidget {
  final FilterDataModel filterDataModel;
  final Function tapFilterCallback;

  FilterFooter({this.filterDataModel, this.tapFilterCallback});

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];

    if (filterDataModel.preUrl != '') {
      widgetList.add(ElevatedButton(
        child: Text(
          '上一页',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        onPressed: () {
          tapFilterCallback(filterDataModel.preUrl);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(0),
            side: MaterialStateProperty.all(BorderSide(
                color: Color(0xFFEEEEEE),
                width: 1
            ))
        ),
      ));
    }

    widgetList.add(Container(
      width: 100,
      height: 40,
      child: Center(
        child: Text(
          '${filterDataModel.pageIndex}/${filterDataModel.pageTotal}',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.orange),
      margin: EdgeInsets.only(left: 30, right: 30),
    ));

    if (filterDataModel.nextUrl != '') {
      widgetList.add(ElevatedButton(
        child: Text(
          '下一页',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        onPressed: () {
          tapFilterCallback(filterDataModel.nextUrl);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(0),
            side: MaterialStateProperty.all(
                BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1
                )
            )
        ),
      ));
    }


    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: widgetList,
      ),
    );
  }
}
