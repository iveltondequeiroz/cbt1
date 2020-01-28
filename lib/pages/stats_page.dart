import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../widgets/stats_card.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List usersData, routesData, booksData;

  int usersTotal =-1, routesTotal = -1, booksTotal = -1;

  @override
  void initState() {
    super.initState();
    getUsersTotal();
    getRoutesTotal();
    getBooksTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text('Stats'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            StatCard('Users', usersTotal),
            StatCard('Routes', routesTotal),
            StatCard('Books', booksTotal),
          ],
        ),
      ),
    );
  }

  getUsersTotal() async {
    print("GET users total");

    final String url = 'http://10.0.2.2:3334/stats/users';

    http.Response response = await http.get(url);
    usersData = json.decode(response.body);
    print(usersData[0]["users_total"].runtimeType);

    if(usersData != null) {
      setState(() {
        usersTotal = int.parse(usersData[0]["users_total"]);
      });
    }
    print("usersTotal:");
    print(usersTotal);
  }

  getRoutesTotal() async {
    print("GET routes");

    final String url = 'http://10.0.2.2:3334/stats/routes';

    http.Response response = await http.get(url);
    routesData = json.decode(response.body);
    print(routesData[0]["routes_total"].runtimeType);

    if(routesData != null) {
      setState(() {
        routesTotal = int.parse(routesData[0]["routes_total"]);
      });
    }
    print("routesTotal:");
    print(routesTotal);
  }

  getBooksTotal() async {
    print("GET books total");

    final String url = 'http://10.0.2.2:3334/stats/books';

    http.Response response = await http.get(url);
    booksData = json.decode(response.body);

    print(booksData[0]["books_total"].runtimeType);

    if(booksData != null) {
      setState(() {
        booksTotal = int.parse(booksData[0]["books_total"]);
      });
    }
    print("booksTotal:");
    print(booksTotal);
  }
}


