import 'dart:io';
import 'package:audio_player/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:audio_player/myauido.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';

void main() async  {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
       home: Splash(),

    );
  }
}

class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:  EdgeInsets.only(top : 180),
        child: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: new MyAppp(),
            title: new Text('',
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),),
            image: Image.asset('assets/images/Logo.png'),
            backgroundColor: Colors.black,
            styleTextUnderTheLoader: new TextStyle(fontSize: 0),
            photoSize: 150.0,
            onClick: ()=>print("Flutter Egypt"),
            loaderColor: Colors.black
        ),
      ),
    );
  }
}




class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
    ..badCertificateCallback = 
    (X509Certificate cert,String host,int port)=> true;
  
  }
}

