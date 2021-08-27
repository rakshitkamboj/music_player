import 'dart:io';
import 'package:audio_player/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player/myauido.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
       home: MyAppp(),

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

