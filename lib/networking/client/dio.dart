import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_flutter/networking/models/movies_model.dart';

class DioClient {
  final baseUrl = "http://localhost/imageflutter/api";

  Future<Dio> getClient() async {
    Dio dio = new Dio();

    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'content-type': 'text/plain'
    };

    dio.options.headers = headers;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));

    return dio;
  }

  Future<Movies?> getMovies(Dio dio) async {
    Movies? movieList;

    try {
      Response movieData = await dio.get('$baseUrl/movies');
      movieList = Movies.fromJson(movieData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }

    return movieList;
  }
}
