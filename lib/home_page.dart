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
import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:volume_control/volume_control.dart';
import 'package:volume_watcher/volume_watcher.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';


class MyAppp extends StatefulWidget {
  const MyAppp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppp> {
  double _sliderValue = 0.0;
  int maxVol, currentVol;
  final url = "https://hetstamcafe.stream-server.nl/stream";
  AudioPlayer _player;
  bool isPaused=false;
  Album album;
  String savedTitle="";
  String _platformVersion = 'Unknown';
  double _val = 0.5;
  Timer timer;


  static int ff = 0;



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
          album:  temp.split('-').first,
          title: temp.split('-').last,
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

   initPlayer();
    fetchData();
    initAirplay();
    initVolumeState();
    VolumeWatcher.hideVolumeView = true;
  }
  Future<void> initVolumeState() async {
    if (!mounted) return;

    //read the current volume
    _val = await VolumeWatcher.getCurrentVolume;
    setState(() {

    });
  }


  initPlayer() async {
    if(_player!=null)
      _player.dispose();

    _player = AudioPlayer();
  }





  fetchData() async {
    var temp;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      temp  = await Music().fetchmusicinfo();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      temp  = await Music().fetchmusicinfo();
    }



   if(temp!=null)
      album=temp;


setState(() {});

    if(album!=null){


      if(savedTitle!=album.title && savedTitle.isNotEmpty){

       await _player.dispose();
       await Future.delayed(Duration(milliseconds: 50));

        _player = AudioPlayer();

       // await  _init();
       //  _player.play();
      }
      else if(savedTitle.isEmpty){
        await _init();
        // await _player.load();
        // await _player.play();
      }
       savedTitle =album.title;
      setState(() {

      });
    }
  }

  Future<void> initAirplay() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterToAirplay.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    // if(savedTitle.isEmpty)
    //   _player.play();


    return Scaffold(
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {

              return Container(
                        height: height * 1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.overlay),
                              image: AssetImage("assets/images/bg2.png"),
                              fit: BoxFit.cover,
                            )),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(

                              top: height * 0.57,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  album==null ?Center(
                                    child: Container(
                                      height: 25,
                                      width: 100,
                                      child: SpinKitWave(
                                        color: Colors.white,
                                        size: width * 0.125,
                                      ),
                                    ),
                                  )  :Container(
                                    width :width*0.95,


                                    child: Text(
                                      album != null
                                          ? album.title.split('-').last
                                          : "Please wait..",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  album==null?Container():Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:15),
                                      child: Text(
                                        album.title.split('-').first,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.grey.shade300,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: height * 0.08,
                              left: width * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(

                                    child: Image.asset(
                                      'assets/images/Logo.png',
                                      width: width * 0.4,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://open.spotify.com/playlist/1HO1VrIFtG2lyZNVlhLDgf?si=bzgDCIpFQGOQ0PdLx0gsvQ"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Spotify.png",
                                      width: width * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://www.facebook.com/hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Facebook.png",
                                      width: width * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          "https://www.instagram.com/hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Insyagram.png",
                                      width: width * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap:
                                        () {
                                      print("fffffnnivn");
                                    },


                                    child: Image.asset(
                                      "assets/images/email.png",
                                      width: width * 0.083,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      launch("https://www.hetstamcafe.nl/"
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/Website.png",
                                      width: width * 0.083,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: height * 0.25,
                              left: width * 0.2,
                              child: Image.asset(
                                "assets/images/Circle Pattern.png",
                                width: width * 0.6,
                              ),
                            ),
                            Positioned(
                                left: width * 0.25,
                                top: height * 0.27,
                                child: album==null?CircleAvatar(
                                  backgroundColor: Colors.black38,
                                  radius: width * 0.25,
                                  child: Center(
                                    child: SpinKitRipple(
                                      color: Colors.white,
                                      size: width * 0.35,
                                    ),
                                  ),
                                ) : CircleAvatar(
                                  radius: width * 0.25,
                                  backgroundColor: Colors.black38,
                                  backgroundImage: NetworkImage(album!=null?album.bg:"ff"),
                                )),

                            Positioned(
                              left: width * 0.35,
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
                                    _player.playing
                                        ? Icons.pause_circle_outline_rounded
                                        : Icons.play_circle_outline_rounded,
                                    color: Colors.white,
                                    size: width * 0.28,
                                  )),
                            ),
                            Positioned(
                              top: height * 0.86,

                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Volume1.png',
                                      width: width * 0.09,
                                    ),
                                    VolumeWatcher(
                                      child : SliderTheme(
                                        data: SliderThemeData(
                                            trackHeight: 5,


                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 6)),
                                        child: Center(
                                            child: Slider(
                                              inactiveColor: Color(0xff707070),
                                                activeColor: Colors.white,
                                                value:_val,min:0,max:1,divisions: 100,onChanged:(val){
                                              _val = val;
                                              setState(() {});

                                              print("val:${val}");
                                            })
                                        )

                                        ,),
                                      onVolumeChangeListener: (double volume) {
                                        ///do sth.
                                        ///

                                        _val =volume;
                                        setState(() {

                                        });
                                      },
                                    ),


                                    SizedBox(
                                      width: width * 0.075,
                                    ),
                                  AirPlayRoutePickerView(
                                    tintColor: Colors.white,
                                    activeTintColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    height: 55,
                                    width: 55,
                                  ),
                                    // GestureDetector(
                                    //   onTap: (){
                                    //
                                    //   },
                                    //   child: Image.asset(
                                    //     'assets/images/Airplay 1.png',
                                    //     width: width * 0.09,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Share.share("Hey, Check out this app");
                                      },
                                      child: Image.asset(
                                        'assets/images/Share1.png',
                                        width: width * 0.09,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Container
                          ], //<Widget>[]
                        ), //SizedBox
                      );


            }
    )
    );
          }


    //,

  }

