import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video/network/dio_client.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewFragment extends StatefulWidget {

  final String url;

  WebViewFragment(this.url);


  @override
  _WebViewFragmentState createState() => _WebViewFragmentState();
}

class _WebViewFragmentState extends State<WebViewFragment> {


  String playUrl = '';



  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    getRealPlayUrl();
  }


  void getRealPlayUrl() {
    DioClient.getInstance().get(widget.url).then((value) {
      setState(() {
        var htmlData = value.data.toString();
        playUrl = htmlData.split('\",\"url_next\":')[0].split('\"link_pre\":\"')[1].split('\"url\":\"')[1];
        playUrl = 'https://cq.mmiyue.com/zhenbuka/player/index.php?id=$playUrl';
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: playUrl == '' ? Center(
        child: Text('Loading Video Data......'),
      ) : WebView(
        initialUrl: playUrl,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        allowsInlineMediaPlayback: true,
        userAgent: 'Mozilla/5.0 (Linux; U; Android 2.2.1; zh-cn; HTC_Wildfire_A3333 Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
      ),
    );
  }
}