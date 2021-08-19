import 'dart:io';
import 'package:audio_player/musicapi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/*
Future<Album> fetchAlbum() async {
  //final response = await http
  // .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  final response = await http.get(Uri.parse(
      'https://server-26.stream-server.nl:2000/json/stream/HetStamcafe'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


String url = 'https://server-26.stream-server.nl:2000/json/stream/HetStamcafe';

String currencyRequestToJson(CurrencyRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

CurrencyCommonResponseModel currencyResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return CurrencyCommonResponseModel.fromJson(jsonData);
}

// Request Model
class CurrencyRequestModel {
  String token;

  CurrencyRequestModel({
    this.token,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

class CurrencyCommonResponseModel {
  int code;
  String message;
  final List<CurrencyResponseModel> data;

  CurrencyCommonResponseModel({
    this.code,
    this.message,
    this.data,
  });

  factory CurrencyCommonResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CurrencyResponseModel> dataList =
        list.map((i) => CurrencyResponseModel.fromJson(i)).toList();

    return new CurrencyCommonResponseModel(
      code: json["code"] as int,
      message: json["message"] as String,
      data: dataList,
    );
  }
}

class CurrencyResponseModel {
  int id;
  String name;
  String code;

  CurrencyResponseModel({
    this.id,
    this.name,
    this.code,
  });

  factory CurrencyResponseModel.fromJson(Map<String, dynamic> json) {
    return new CurrencyResponseModel(
      id: json["id"] as int,
      name: json["name"] as String,
      code: json["code"] as String,
    );
  }
}
*/
class MyAppp extends StatefulWidget {
  const MyAppp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppp> {
  @override
  void initState() {
    super.initState();
  }

  bool play_pause = false;
  void switchh() {
    setState(() {
      // ignore: unnecessary_statements
      if (play_pause == false) {
        play_pause = true;
      } else {
        play_pause = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder(
            future: Music().fetchmusicinfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: height * 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.overlay),
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover,
                  )),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: height * 0.08,
                        left: widht * 0.04,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Logo.png',
                              width: widht * 0.4,
                            ),
                            SizedBox(
                              width: widht * 0.05,
                            ),
                            Image.asset(
                              "assets/images/Facebook.png",
                              width: widht * 0.083,
                            ),
                            SizedBox(
                              width: widht * 0.01,
                            ),
                            Image.asset(
                              "assets/images/Facebook.png",
                              width: widht * 0.083,
                            ),
                            SizedBox(
                              width: widht * 0.01,
                            ),
                            Image.asset(
                              "assets/images/Facebook.png",
                              width: widht * 0.083,
                            ),
                            SizedBox(
                              width: widht * 0.01,
                            ),
                            Image.asset(
                              "assets/images/Facebook.png",
                              width: widht * 0.083,
                            ),
                            SizedBox(
                              width: widht * 0.01,
                            ),
                            Image.asset(
                              "assets/images/Facebook.png",
                              width: widht * 0.083,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: height * 0.25,
                        left: widht * 0.2,
                        child: Image.asset(
                          "assets/images/Circle Pattern.png",
                          width: widht * 0.6,
                        ),
                      ),
                      Positioned(
                        left: widht * 0.12,
                        top: height * 0.21,
                        child: Image.asset(
                          "assets/images/art.png",
                          width: widht * 0.76,
                        ),
                      ),
                      Positioned(
                        left: widht * 0.34,
                        top: height * 0.57,
                        child: Text(
                          snapshot.data,
                          style: TextStyle(
                              fontSize: widht * 0.06,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: widht * 0.44,
                        top: height * 0.62,
                        child: Text(
                          "Avichi",
                          style: TextStyle(
                              fontSize: widht * 0.04,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: widht * 0.35,
                        top: height * 0.68,
                        child: GestureDetector(
                            onTap: () {
                              switchh();
                            },
                            child: Icon(
                              play_pause
                                  ? Icons.play_circle_outline_rounded
                                  : Icons.pause_circle_outline_rounded,
                              color: Colors.white,
                              size: widht * 0.28,
                            )),
                      ),
                      Positioned(
                        top: height * 0.86,
                        left: widht * 0.04,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Airplay 1.png',
                              width: widht * 0.09,
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 5,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 5)),
                              child: Slider(
                                value: 2,
                                activeColor: Colors.white,
                                inactiveColor: Color(0xff707070),
                                onChanged: (value) {},
                                min: 0,
                                max: 4,
                              ),
                            ),
                            SizedBox(
                              width: widht * 0.14,
                            ),
                            Image.asset(
                              'assets/images/Airplay 1.png',
                              width: widht * 0.09,
                            ),
                            SizedBox(
                              width: widht * 0.03,
                            ),
                            Image.asset(
                              'assets/images/Airplay 1.png',
                              width: widht * 0.09,
                            ),
                          ],
                        ),
                      ),
                      //Container
                    ], //<Widget>[]
                  ), //SizedBox
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),

      //,
    );
  }
}
