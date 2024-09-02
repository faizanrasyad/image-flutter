import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_flutter/networking/models/movies_model.dart';
import 'package:path/path.dart';

class DioClient {
  final baseUrl = "http://10.132.75.76/imageflutter/api";

  Future<Dio> getClient() async {
    Dio dio = new Dio();

    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
    };

    dio.options.headers = headers;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));

    return dio;
  }

  Future<void> postMovie(String name, String prod, String image) async {
    try {
      Dio dio = await DioClient().getClient();
      Response newMovie = await dio.post('$baseUrl/movies',
          data: {'name': name, 'production': prod, 'image': image});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }
}
