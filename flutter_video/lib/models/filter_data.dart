import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;


class FilterDataModel {

  int hotOrNew = 0;

  List<FilterItem> hotOrNewList = [];

  List<FilterGroup> categoryList = [];

  //当前分页索引
  String pageIndex = '';

  //总共页数
  String pageTotal = '';

  //当前视频列表
  List<VideoModel> videoModelList = [];

  //上一页路径
  String preUrl = '';

  //下一页路径
  String nextUrl = '';



  FilterDataModel.formHTML(String html) {
    var document = parse(html);

    // Filter Header
    categoryList = [];
    var filters = document.getElementsByClassName('stui-screen__list');
    for (int i = 0; i < filters.length; i++) {
      if (i == 0) {
        // hot or new
        var categories = filters[i].getElementsByTagName('li');
        hotOrNewList = categories.asMap().entries.map((entry) {
          int index = entry.key;
          Element element = entry.value;
          var currentItem = element.getElementsByTagName('a')[0];
          var targetUrl = currentItem.attributes['href'];
          var title = currentItem.text.trim();
          if (element.attributes['class'] != null && element.attributes['class'].contains('active')) {
            hotOrNew = index;
          }
          return FilterItem(targetUrl: targetUrl, title: title);
        }).toList();
      } else {
        // filter 选项列表
        var categories = filters[i].getElementsByTagName('li');

        int currentIndex = 0;
        var tempList = categories.asMap().entries.map((entry) {
          int index = entry.key;
          Element element = entry.value;
          if (index == 0) {
            //标题
            return FilterItem(title: element.text.trim(), targetUrl: '');
          }else {
            //可选项
            var currentItem = element.getElementsByTagName('a')[0];
            var targetUrl = currentItem.attributes['href'];
            var title = currentItem.text.trim();
            if (element.attributes['class'] != null && element.attributes['class'].contains('active')) {
              currentIndex = index;
            }
            return FilterItem(targetUrl: targetUrl, title: title);
          }
        }).toList();

        categoryList.add(FilterGroup(filterList: tempList, currentIndex: currentIndex));
      }
    }


    // Video List
    var videos = document.getElementsByClassName('stui-vodlist__thumb');

    videoModelList = videos.map((element) {
      var targetUrl = element.attributes['href'];
      var videoTitle = element.attributes['title'].trim();
      var videoImage = element.attributes['data-original'];
      var videoInfo = element.text.trim();

      return VideoModel(videoTitle: videoTitle, videoImage: videoImage, videoUrl: targetUrl, videoInfo: videoInfo);
    }).toList();


    // now page index
    var pages = document.getElementsByClassName('stui-page')[0].getElementsByTagName('li');

    if (pages.length > 8) {
      preUrl = pages[1].getElementsByTagName('a')[0].attributes['href'];
      var pageInfoStr = pages[7].text;
      pageIndex = pageInfoStr.split('/')[0];
      pageTotal = pageInfoStr.split('/')[1];
      nextUrl = pages[8].getElementsByTagName('a')[0].attributes['href'];
    }else {
      pageIndex = '1';
      pageTotal = '1';
      preUrl = '';
      nextUrl = '';
    }
  }

}


class FilterGroup {
  List<FilterItem> filterList;

  int currentIndex;

  FilterGroup({ this.filterList, this.currentIndex});
}






//筛选项
class FilterItem {
  String title;

  String targetUrl;

  FilterItem({this.title, this.targetUrl});
}




class VideoModel {

  String videoTitle;

  String videoUrl;

  String videoInfo;

  String videoImage;

  VideoModel({this.videoTitle, this.videoUrl, this.videoInfo, this.videoImage});
}