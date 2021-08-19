import 'package:audio_player/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audio_player/modal.dart';
class Music {
  String _url =
      'https://server-26.stream-server.nl:2000/json/stream/HetStamcafe';
  Dio _dio;
  Music() {
    _dio = Dio();
  }
  Future fetchmusicinfo() async {
    try {
      Response response = await _dio.get(_url);
      Album album = Album.fromJson(response.data);
      return album.title;
    } on DioError catch (e) {
      print(e);
    }
  }
}
