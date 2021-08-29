import 'dart:io';
import 'package:audio_player/musicapi.dart';
import 'package:audio_player/myauido.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'musicapi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'modal.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:just_audio_example/common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';



class MyAppp extends StatefulWidget {
  const MyAppp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppp> {
  double _sliderValue = 0.0;
  int maxVol, currentVol;

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager
        .STREAM_MUSIC); // you can change which volume you want to change.
  }
  static int ff = 0;

  updateVolumes() async {
    maxVol = await Volume.getMaxVol;
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    String temp =  album.title;
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {

      await _player.setAudioSource(AudioSource.uri(
        Uri.parse(
            'https://hetstamcafe.stream-server.nl/stream'),
        tag: MediaItem(
          id: 'only',
          album: "Het StamCafe",
          title: "$temp",
          artUri: Uri.parse(
              album.bg),
        ),
      ),);

      print('success');
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      // print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    fetchData();
  }





  Album album;
  String savedTitle="";

  fetchData() async {

    var temp  = await Music().fetchmusicinfo();
    if(temp!=null)
      album=temp;
    setState(() {});

    if(album!=null){


      if(savedTitle!=album.title && savedTitle.isNotEmpty){
        _player.dispose();
        _player = AudioPlayer();
        _init();
        _player.play();
      }
      else if(savedTitle.isEmpty){
        _init();
      }
       savedTitle =album.title;
      setState(() {

      });
    }
  }


  final url = "https://hetstamcafe.stream-server.nl/stream";
   AudioPlayer _player;
  bool isPaused=false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double widht = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {

              return StreamBuilder(
                // stream: AudioService.playbackStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    // if(ss!=album.title)
                    // AudioService.start(backgroundTaskEntrypoint: _backgroundTaksentrypoint,params: {"url":url,"image":album.bg});

                    return
                      Container(
                        height: height * 1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.overlay),
                              image: AssetImage("assets/images/bg.png"),
                              fit: BoxFit.cover,
                            )),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: widht * 0.01,
                              top: height * 0.57,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    album != null
                                        ? album.title
                                        : "Please wait..",
                                    style: TextStyle(
                                        fontSize: widht * 0.06,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                  ),
                                  Text(
                                    "Avichi",
                                    style: TextStyle(
                                        fontSize: widht * 0.04,
                                        color: Colors.grey.shade300,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: height * 0.08,
                              left: widht * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(

                                    child: Image.asset(
                                      'assets/images/Logo.png',
                                      width: widht * 0.4,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widht * 0.05,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://open.spotify.com/playlist/1HO1VrIFtG2lyZNVlhLDgf?si=bzgDCIpFQGOQ0PdLx0gsvQ"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Spotify.png",
                                      width: widht * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://www.facebook.com/hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Facebook.png",
                                      width: widht * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://www.instagram.com/hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Insyagram.png",
                                      width: widht * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap:
                                        () {
                                      print("fffffnnivn");
                                    },


                                    child: Image.asset(
                                      "assets/images/email.png",
                                      width: widht * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      launch("https://www.hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Website.png",
                                      width: widht * 0.083,
                                    ),
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
                                left: widht * 0.25,
                                top: height * 0.27,
                                child: CircleAvatar(
                                  radius: widht * 0.25,
                                  backgroundImage: NetworkImage(album!=null?album.bg:"ff"),
                                )),

                            Positioned(
                              left: widht * 0.35,
                              top: height * 0.68,
                              child: GestureDetector(
                                  onTap: () async {

                                    isPaused=!isPaused;
                                    setState(() {

                                    });
                                    if(_player.playing)
                                      await _player.pause();
                                    else
                                      await _player.play();




                                  },
                                  child: Icon(
                                    playing
                                        ? Icons.pause_circle_outline_rounded
                                        : Icons.play_circle_outline_rounded,
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
                                    'assets/images/Volume1.png',
                                    width: widht * 0.09,
                                  ),
                                  SliderTheme(
                                      data: SliderThemeData(
                                          trackHeight: 5,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 5)),
                                      child: Slider(
                                        activeColor: Colors.white,
                                        min: 0.0,
                                        max: 15.0,
                                        onChanged: (newRating) async {
                                          setState(() {
                                            _sliderValue = newRating;
                                          });
                                          await setVol(newRating.toInt());
                                          await updateVolumes();
                                        },
                                        value: _sliderValue,
                                      )),
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
                                  GestureDetector(
                                    onTap: () {
                                      Share.share("Hey, Check out this app");
                                    },
                                    child: Image.asset(
                                      'assets/images/Share1.png',
                                      width: widht * 0.09,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Container
                          ], //<Widget>[]
                        ), //SizedBox
                      );
                  }
              );

            }
    )
    );
          }


    //,

  }

