import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/theme.dart';

import 'package:forumbelajar/views/users/login.dart';
import 'package:splashscreen/splashscreen.dart';

void main(){
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new Login(),
      title: Text(
        'FORUM BELAJAR',
        style: new TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 40.0
        )),
      image: Image.asset(
        'assets/images/learning_flat.png',
        width: 150,
        height: 150,
      ),
      backgroundColor: primaryBlue,
      loadingText: Text("Silahkan tunggu...",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      onClick: () {},
      loaderColor: Colors.white
    );
  }
}