import 'dart:io';
import 'package:audio_player/home_page.dart';
import 'package:audio_player/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player/myauido.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:splashscreen/splashscreen.dart';
void main() async  {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

            // Loading is done, return the app:
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash(),
            );
          }
          // },

  }

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
    ..badCertificateCallback = 
    (X509Certificate cert,String host,int port)=> true;
  
  }
}
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.black,

      seconds: 3,
      navigateAfterSeconds:  MyAppp(),
      image:  Image.asset("assets/images/Logo.png"),
        loaderColor: Colors.yellow,
      photoSize: 200.0,

    );
  }
}

