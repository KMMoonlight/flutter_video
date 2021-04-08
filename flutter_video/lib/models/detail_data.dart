import 'package:html/parser.dart' show parse;

class DetailDataModel {

  String videoTitle;

  String videoImage;

  String videoType;

  String videoActor;

  String videoDirector;

  String videoUpdate;

  String videoInfo;

  List<ChapterItem> videoList;


  DetailDataModel.fromHtml(String html) {

    var document = parse(html);

    //视频图片
    videoImage = document.getElementsByClassName('stui-vodlist__thumb')[0].getElementsByTagName('img')[0].attributes['data-original'];



    var videoContent = document.getElementsByClassName('stui-content__detail')[0];

    //标题
    videoTitle = videoContent.getElementsByTagName('h1')[0].text.trim();

    var info = videoContent.getElementsByTagName('p');
    //类型
    videoType = info[0].text.trim().replaceAll('\n', ' ').replaceAll('\t', '');
    //主演
    videoActor = info[1].text.trim().replaceAll('\n', ' ').replaceAll('\t', '');
    //导演
    videoDirector = info[2].text.trim().replaceAll('\n', ' ').replaceAll('\t', '');
    //更新时间
    videoUpdate = info[3].text.trim().replaceAll('\n', ' ').replaceAll('\t', '');
    //简介
    videoInfo = info[4].text.trim().replaceAll('\n', ' ').replaceAll('\t', '');


    //剧集列表
    var chapterList = document.getElementsByClassName('stui-content__playlist')[0].getElementsByTagName('a');
    videoList = chapterList.map((e) {
      return ChapterItem(e.text.trim(), e.attributes['href']);
    }).toList();
  }

}


class ChapterItem {

  String chapterTitle;

  String chapterUrl;

  ChapterItem(this.chapterTitle, this.chapterUrl);

}