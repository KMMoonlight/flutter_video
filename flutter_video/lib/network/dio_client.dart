import 'package:dio/dio.dart';

//创建DioClient的单例
class DioClient{

  static var dioClient;


  static Dio getInstance() {
    if (dioClient == null) {

      //设置请求头
      Map<String, String> headers = {
        'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1 Edg/89.0.4389.114'
      };

      var options = BaseOptions(
        baseUrl: 'https://www.zhenbuka.com',
        connectTimeout: 5000,
        receiveTimeout: 5000,
        headers: headers
      );

      dioClient = Dio(options);
    }


    return dioClient;

  }


}


