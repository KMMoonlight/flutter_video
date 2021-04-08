import 'package:flutter/material.dart';
import 'package:flutter_video/models/detail_data.dart';
import 'package:flutter_video/network/api.dart';
import 'package:flutter_video/pages/player.dart';

class DetailFragment extends StatefulWidget {
  final String url;

  DetailFragment(this.url);

  @override
  _DetailFragmentState createState() => _DetailFragmentState();
}

class _DetailFragmentState extends State<DetailFragment> {
  DetailDataModel dataModel;

  @override
  void initState() {
    super.initState();

    getDetailPageData(widget.url).then((value) {
      setState(() {
        dataModel = DetailDataModel.fromHtml(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
        brightness: Brightness.dark,
      ),
      body: dataModel == null
          ? Center(
              child: Text('Loading..... QAQ'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //上层的视频信息
                Container(
                  margin: EdgeInsets.all(10),
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.network(
                          dataModel.videoImage,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataModel.videoTitle,
                                style: TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                dataModel.videoType,
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                dataModel.videoActor,
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                dataModel.videoDirector,
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                dataModel.videoUpdate,
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                dataModel.videoInfo,
                                style:
                                TextStyle(fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(left: 5),
                        )
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFE3E3E3),
                ),
                Padding(
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 30,
                        decoration: BoxDecoration(color: Colors.blue),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        '不卡超清',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFE3E3E3),
                ),
                Expanded(
                  child: Padding(
                    child: VideoCardList(dataModel.videoList),
                    padding: EdgeInsets.all(10),
                  ),
                )
              ],
            ),
    );
  }
}



class VideoCardList extends StatelessWidget {

  final List<ChapterItem> chapterItemList;

  VideoCardList(this.chapterItemList);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: chapterItemList.length,
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
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
            child: Text(
              chapterItemList[index].chapterTitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return WebViewFragment('${chapterItemList[index].chapterUrl}-1-${index+1}');
              }));
            },
          );
        },
    );
  }
}














