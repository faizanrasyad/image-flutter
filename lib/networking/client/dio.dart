import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_flutter/networking/models/movies_model.dart';
import 'package:path/path.dart';

class DioClient {
  // Declare the baseUrl (API Url)
  final baseUrl = "http://192.168.1.29/imageflutter/api";

  // Setup your Dio Settings
  Future<Dio> getClient() async {
    Dio dio = new Dio();

    // Headers
    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
    };
    dio.options.headers = headers;

    // Timeout
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Interceptors (Logging for easier maintenance)
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));

    return dio;
  }

  // Dio POST Method
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
