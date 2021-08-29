import 'package:flutter/material.dart';


class Splashscreen extends StatelessWidget {
  const Splashscreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Image.asset("assets/images/Logo.png"),
      ),
    );
  }
}
