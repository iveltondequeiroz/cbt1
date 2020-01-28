import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  const StatCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.redAccent,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.yellow,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //Icon(Icons.supervised_user_circle, size: 50, color: Colors.white,),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}