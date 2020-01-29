import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';


class UserProfilePage extends StatefulWidget {
  final User user;
  //final int userid;

  UserProfilePage({this.user});
  //UserProfilePage({this.userid});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  List userData, routesData, booksData;
  int routesTotal = -1, booksTotal = -1;
  String userName = 'None';
  String image = 'male.jpg';
  String gender = 'M';
  String email = 'None';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
    //getRoutesByUserIdTotal(widget.user.id);
    getRoutesByUserIdTotal(widget.user.id);
    getBooksByUserIdTotal();
    //getUserData(widget.user.id);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Book Tour'),
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: _isLoading ? Center(child: CircularProgressIndicator()) :
      Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.red[900],
            ),
            clipper: GetClipper(),
          ),
          Positioned(
            width: 400.0,
            top: MediaQuery.of(context).size.height / 8,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        //image: AssetImage('images/$image'),
                        image: NetworkImage('${kSimulatorUrl}/images/$image'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Badge(
                        child: RaisedButton(
                          child: Text("Routes", style: kBadgeTextStyle),
                          onPressed: (){},
                        ),
                        badgeContent: Text(routesTotal.toString(), style: kBadgeContentStyle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Badge(
                        child: RaisedButton(
                          child: Text('Books', style: kBadgeTextStyle),
                          onPressed: (){},
                        ),
                        badgeContent: Text(booksTotal.toString(), style: kBadgeContentStyle),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100.0,
                ),
                /*Container(
                  height: 30.0,
                  width: 95.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    shadowColor: Colors.redAccent,
                    color: Colors.red,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  getUserData() async {
    print("GET user object data");
    print(widget.user.username);
    print(widget.user.gender);
    print(widget.user.email);
    print(widget.user.imgUrl);
    //final String url = 'http://10.0.2.2:3334/users/${widget.user.id}';
    //print("url");
    //print(url);

    //http.Response response = await http.get(url);

    //print("print user data");
    //userData = json.decode(response.body);
    //print(userData);

    //if(widget.user.username != 'none') {
    setState(() {
      userName = widget.user.username; // userData[0]["username"];
      email = widget.user.email; // userData[0]["email"];
      gender = widget.user.gender; // userData[0]["gender"];
      if(widget.user.imgUrl != null) {
        image = widget.user.imgUrl;
      } else {
        image = gender == 'M' ? 'male.png':'female.png';
      }
      //_isLoading = false;

    });
  }

  getRoutesByUserIdTotal(int id) async {
    setState(() {
      _isLoading = true;
    });

    print("USER_ROUTES>GET ROUTES BY USER ID");
    print('widget.user.id');
    print(widget.user.id);


    print("GET routes by user id");

    final String url = 'http://10.0.2.2:3334/stats/routes/${widget.user.id}';

    http.Response response = await http.get(url);
    routesData = json.decode(response.body);
    print(routesData[0]["routes_total"].runtimeType);

    if(routesData != null) {
      setState(() {
        routesTotal = int.parse(routesData[0]["routes_total"]);
      });
    }
    print("routesTotal:");
    print(routesTotal);setState(() {
      _isLoading = false;
    });

  }

  getBooksByUserIdTotal() async {
    print("GET books total");
    setState(() {
      _isLoading = true;
    });


    final String url = 'http://10.0.2.2:3334/stats/books/1';

    http.Response response = await http.get(url);
    booksData = json.decode(response.body);

    //print(routesData[0]["books_total"].runtimeType);

    if(booksData != null) {
      setState(() {
        booksTotal = int.parse(booksData[0]["books_total"]);
      });
    }
    print("booksTotal:");
    print(booksTotal);
    setState(() {
      _isLoading = false;
    });

  }

}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int offset = 400;
    var path = Path();
    path.lineTo(0.0, size.height - offset  -100);
    var controlPoint = Offset(50, size.height - offset);
    var endPoint = Offset(size.width/2, size.height - offset);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height - offset);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}



/*
class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

 */