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
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';



_backgroundTaksentrypoint(){
  AudioServiceBackground.run(() => AudioPlayerTask());
}


class AudioPlayerTask extends BackgroundAudioTask {

   Album albumm;
  fetchDataA() async {
    albumm = await Music().fetchmusicinfo();

  }

  AudioPlayerTask(){
    fetchDataA();
    print("g");
  }

  MediaItem mediaItem = MediaItem(title:"Song name");

  final audiop = AudioPlayer();
  @override

  Future<void> onStart(Map<String, dynamic> params) async{

    
    AudioServiceBackground.setState(
      controls: [MediaControl.pause,MediaControl.stop],
          playing: true,
      processingState: AudioProcessingState.connecting,

    );

    await audiop.setUrl(params["url"]);
    audiop.play('https://hetstamcafe.stream-server.nl/stream');
    AudioServiceBackground.setMediaItem(mediaItem);
    AudioServiceBackground.setState(
      controls: [MediaControl.pause,MediaControl.stop],
      playing: true,
      processingState: AudioProcessingState.ready,


    );
    return super.onStart(params);
  }
  @override
  Future<void> onStop() async {

    AudioServiceBackground.setState(
      controls: [],
      playing: false,
      processingState: AudioProcessingState.stopped,

    );
    await audiop.stop();

    return super.onStop();
  }
  @override
  Future<void> onPause() async {

    AudioServiceBackground.setState(
      controls: [MediaControl.play,MediaControl.stop],
      playing: false,
      processingState: AudioProcessingState.ready,


    );
    await audiop.pause();
    return super.onPause();
  }
  @override
  Future<void> onPlay() async {

    AudioServiceBackground.setState(
      controls: [MediaControl.pause,MediaControl.stop],
      playing: true,
      processingState: AudioProcessingState.ready,

    );
    await audiop.play('https://hetstamcafe.stream-server.nl/stream');
    return super.onPlay();
  }

}
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
  void initState() {
    super.initState();
    initPlatformState();
    initaudiostate();

    fetchData();
  }
  initaudiostate() async{
    await AudioService.connect();

  }


  Album album;
  fetchData() async {
    album = await Music().fetchmusicinfo();
    setState(() {});
  }

  bool play_pause = false;
  void switchh() {
    setState(() {
      // ignore: unnecessary_statements
      if (play_pause == false) {
        play_pause = true;
        MyAudio().playAudio();
      } else {
        play_pause = false;
        MyAudio().pauseAudio()();

      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    AudioService.disconnect();
    super.dispose();
  }

  final url = "https://hetstamcafe.stream-server.nl/stream";


  @override
  Widget build(BuildContext context) {
    final url = "https://hetstamcafe.stream-server.nl/stream";
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;
    return Consumer<MyAudio>(
      builder: (_, myAudioModel, child) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {


                if (album != null) {
                  return StreamBuilder(
                    stream: AudioService.playbackStateStream,
                    builder:(context,snapshot) {
                      final playing = snapshot.data?.playing ?? false;
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
                                    album.title,
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
                                  Image.asset(
                                    'assets/images/Logo.png',
                                    width: widht * 0.4,
                                  ),
                                  SizedBox(
                                    width: widht * 0.05,
                                  ),
                                  Image.asset(
                                    "assets/images/Spotify.png",
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
                                    "assets/images/Insyagram.png",
                                    width: widht * 0.083,
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),
                                  Image.asset(
                                    "assets/images/email.png",
                                    width: widht * 0.083,
                                  ),
                                  SizedBox(
                                    width: widht * 0.01,
                                  ),
                                  Image.asset(
                                    "assets/images/Website.png",
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
                                left: widht * 0.25,
                                top: height * 0.27,
                                child: CircleAvatar(
                                  radius: widht * 0.25,
                                  backgroundImage: NetworkImage(album.bg),
                                )),

                            Positioned(
                              left: widht * 0.35,
                              top: height * 0.68,
                              child: GestureDetector(
                                  onTap: () {


                                    if(playing){
                                      //isplaying = true;

                                      AudioService.pause();

                                    }else{
                                     // isplaying = false;
                                        if(AudioService.running){
                                          AudioService.play();
                                        }else{
                                          AudioService.start(backgroundTaskEntrypoint: _backgroundTaksentrypoint,params: {"url":url,"image":album.bg});
                                        }
                                     // playing = false;
                                    }


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
                                  Image.asset(
                                    'assets/images/Share1.png',
                                    width: widht * 0.09,
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
                } else {
                  return Container(
                    child: Container(
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
                            left: widht * 0.01,
                            top: height * 0.57,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Please wait....",
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
                                Image.asset(
                                  'assets/images/Logo.png',
                                  width: widht * 0.4,
                                ),
                                SizedBox(
                                  width: widht * 0.05,
                                ),
                                Image.asset(
                                  "assets/images/Spotify.png",
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
                                  "assets/images/Insyagram.png",
                                  width: widht * 0.083,
                                ),
                                SizedBox(
                                  width: widht * 0.01,
                                ),
                                Image.asset(
                                  "assets/images/email.png",
                                  width: widht * 0.083,
                                ),
                                SizedBox(
                                  width: widht * 0.01,
                                ),
                                Image.asset(
                                  "assets/images/Website.png",
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
                              left: widht * 0.25,
                              top: height * 0.27,
                              child: CircleAvatar(
                                radius: widht * 0.25,
                                backgroundImage: NetworkImage(""),
                              )),

                          Positioned(
                            left: widht * 0.35,
                            top: height * 0.68,
                            child: GestureDetector(
                                onTap: () {
                                  myAudioModel.audioState == "Playing"
                                      ? myAudioModel.pauseAudio()
                                      : myAudioModel.playAudio();
                                },
                                child: Icon(
                                  myAudioModel.audioState == "Playing"
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
                                Image.asset(
                                  'assets/images/Share1.png',
                                  width: widht * 0.09,
                                ),
                              ],
                            ),
                          ),
                          //Container
                        ], //<Widget>[]
                      ), //SizedBox
                    ),
                  );
                }
              }),
        ),

        //,
      ),
    );
  }
}
