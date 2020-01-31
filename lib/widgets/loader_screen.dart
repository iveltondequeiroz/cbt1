import 'package:flutter/material.dart';
import 'package:cbt1/constants.dart';
import 'loader.dart';

class LoaderScreen extends StatelessWidget {
  final String title;
  LoaderScreen({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kWhiteTransparentColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 30),
            ),
            Loader(),
          ],
        ),
      ),
    );
  }
}
