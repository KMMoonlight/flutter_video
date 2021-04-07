import 'package:flutter_video/network/dio_client.dart';

Future<String> getMainPageData() async {
  var response = await DioClient.getInstance().get('/?btwaf=26217660');
  return response.data.toString();
}


Future<String> getFilterPageData(String targetUrl) async {
  var response = await DioClient.getInstance().get(targetUrl);
  return response.data.toString();
}