import 'package:detect_flowers/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  MySplash({Key key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                stops: [0.004, 1],
                colors: [Color(0XFF8a063), Color(0XFF56ab2f)])),
        child: SplashScreen(
          seconds: 2,
          navigateAfterSeconds: Home(),
          title: Text(
            "Detect Flowers",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xFFE99600)),
          ),
          image: Image.asset("assets/images/flowers.png"),
          backgroundColor: Colors.black,
          photoSize: 50,
          loaderColor: Color(0XFFEEDA28),
        ),
      ),
    );
  }
}
