import 'package:flutter/material.dart';
import 'pages/login_page.dart';
//import 'constants.dart';

void main() {
  runApp(CbtApp());
}

class CbtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Book Tour',
      theme: ThemeData(
        //primaryColor: kForegroundColor,
        //accentColor: kBackgroundTransparentColor,
        fontFamily: 'Yanone',
      ),
      home: LoginPage(),
    );
  }
}