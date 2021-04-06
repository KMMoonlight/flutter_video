import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_video/models/main_data.dart';
import 'package:flutter_video/network/api.dart';

class LauncherFragment extends StatefulWidget {
  @override
  _LauncherFragmentState createState() => _LauncherFragmentState();
}

class _LauncherFragmentState extends State<LauncherFragment> {
  MainDataModel mainDataModel;

  @override
  void initState() {
    super.initState();

    //获取首页数据
    getMainPageData().then((value) {
      setState(() {
        mainDataModel = MainDataModel.formHTML(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              onPressed: () => {
                    // 点击跳转到搜索
                  })
        ],
        brightness: Brightness.dark,
      ),
      body: mainDataModel == null
          ? Center(
              child: Text('加载中......'),
            )
          : ListView(
              children: [
                Container(
                  child: Swiper(
                    itemCount: mainDataModel.bannerModelList.length,
                    viewportFraction: 0.9,
                    scale: 0.9,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                          mainDataModel.bannerModelList[index].bannerImg,
                          fit: BoxFit.fill);
                    },
                    layout: SwiperLayout.STACK,
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(right: 20),
                        builder: SwiperPagination.fraction),
                    itemWidth: 380,
                    autoplay: true,
                    onTap: (index) {
                      //点击某个轮播图
                    },
                  ),
                  height: 160,
                  margin: EdgeInsets.all(10.0),
                ),
                VideoGroupTitle(groupTitle: '热播推荐'),
                Container(
                  margin: EdgeInsets.all(10),
                  child: VideoCardGroup(
                    videoModelList: mainDataModel.hotModelList,
                  ),
                ),
                VideoGroupTitle(groupTitle: '电影'),
                Container(
                  margin: EdgeInsets.all(10),
                  child: VideoCardGroup(
                    videoModelList: mainDataModel.movieModelList,
                  ),
                ),
                VideoGroupTitle(groupTitle: '剧集'),
                Container(
                  margin: EdgeInsets.all(10),
                  child: VideoCardGroup(
                    videoModelList: mainDataModel.tvModelList,
                  ),
                ),
                VideoGroupTitle(groupTitle: '综艺'),
                Container(
                  margin: EdgeInsets.all(10),
                  child: VideoCardGroup(
                    videoModelList: mainDataModel.showModelList,
                  ),
                ),
                VideoGroupTitle(groupTitle: '动漫'),
                Container(
                  margin: EdgeInsets.all(10),
                  child: VideoCardGroup(
                    videoModelList: mainDataModel.cartoonModelList,
                  ),
                ),
              ],
            ),
    );
  }
}

class VideoGroupTitle extends StatelessWidget {
  final String groupTitle;

  VideoGroupTitle({this.groupTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                width: 5,
                height: 30,
                decoration: BoxDecoration(color: Colors.blue),
              ),
              left: 10,
            ),
            Positioned(
              left: 30,
              child: Text(
                groupTitle,
                style: TextStyle(color: Colors.lightBlue, fontSize: 18),
              ),
            ),
            Positioned(
              right: 10,
              child: GestureDetector(
                child: Text(
                  '更多>>',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                onTap: () {
                  //查看更多
                },
              ),
            )
          ],
        ),
      ),
      height: 30,
    );
  }
}

// 每一个大类的
class VideoCardGroup extends StatelessWidget {
  final List<VideoModel> videoModelList;

  VideoCardGroup({this.videoModelList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return VideoCard(videoModel: videoModelList[index]);
          },
          itemCount: videoModelList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics()),
    );
  }
}

// Video Item
class VideoCard extends StatelessWidget {
  final VideoModel videoModel;

  VideoCard({this.videoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
              image: NetworkImage(videoModel.videoImage), fit: BoxFit.fitWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
            )
          ]),
      child: Container(
        child: Column(
          children: [
            Text(
              videoModel.videoTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
              )
            ),
            Text(
              videoModel.videoInfo,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
              )
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        decoration: BoxDecoration(
          color: Color(0x33000000)
        ),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
