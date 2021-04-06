import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;


// 首页数据实体类
class MainDataModel {

  //Banner
  List<BannerModel> bannerModelList = [];

  //热门
  List<VideoModel> hotModelList = [];

  //电影
  List<VideoModel> movieModelList = [];

  //电视剧
  List<VideoModel> tvModelList = [];

  //综艺
  List<VideoModel> showModelList = [];

  //动漫
  List<VideoModel> cartoonModelList = [];



  MainDataModel.formHTML(String html) {

    bannerModelList.clear();
    hotModelList.clear();
    movieModelList.clear();
    tvModelList.clear();
    showModelList.clear();
    cartoonModelList.clear();
    
    

    var document = parse(html);

    // 解析轮播图
    var banners = document.getElementsByClassName('stui-banner__item');
    banners.forEach((element) {

      var bannerDom = element.getElementsByTagName('a')[0];
      var targetUrl = bannerDom.attributes['href'];
      var imageUrlStr = bannerDom.attributes['style'];
      var imageUrl = imageUrlStr.split('(')[1].split(')')[0];

      bannerModelList.add(BannerModel(bannerImg: imageUrl, bannerUrl: targetUrl));
    });
    
    
    var videos = document.getElementsByClassName('stui-vodlist');
    
    parseVideoModel(hotModelList, videos[0]);
    parseVideoModel(movieModelList, videos[1]);
    parseVideoModel(tvModelList, videos[2]);
    parseVideoModel(showModelList, videos[3]);
    parseVideoModel(cartoonModelList, videos[4]);
  }
  
  
  //解析视频HTML
  void parseVideoModel(List<VideoModel> list, Element element) {
    var videos = element.getElementsByClassName('stui-vodlist__thumb');
    videos.forEach((element) {
      var videoUrl = element.attributes['href'];
      var videoImage = element.attributes['data-original'];
      var videoTitle = element.attributes['title'];
      var videoInfo = element.text.trim();

      list.add(VideoModel(videoImage: videoImage, videoInfo: videoInfo, videoTitle: videoTitle, videoUrl: videoUrl));
    });
  }

}



// 轮播图实体类
class BannerModel {

  String bannerImg;

  String bannerUrl;

  BannerModel({this.bannerImg, this.bannerUrl});
}


// 视频实体类
class VideoModel {

  String videoTitle;

  String videoUrl;

  String videoInfo;

  String videoImage;

  VideoModel({this.videoTitle, this.videoUrl, this.videoInfo, this.videoImage});
}















