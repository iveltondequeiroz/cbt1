import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../models/user.dart';
import '../models/route.dart';
import 'route_timeline_page.dart';
import 'route_create_page.dart';


class UserRoutesPage extends StatefulWidget {
  final User user;
  UserRoutesPage({this.user});

  @override
  _UserRoutesPageState createState() => _UserRoutesPageState();
}

class _UserRoutesPageState extends State<UserRoutesPage> {
  List routesData;

  getRoutes() async {
    print("GET ROUTES");
    print(widget.user.id);

    final String url = 'http://10.0.2.2:3334/routes/user/${widget.user.id}';

    http.Response response = await http.get(url);

    setState(() {
      routesData = json.decode(response.body);
      print(routesData);
    });
  }

  @override
  void initState() {
    super.initState();
    getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(
            'images/logo_app.png',
            //fit: BoxFit.cover,
            height: 35.0,
          ),
        ),
        title: Text('MINHAS ROTAS', style: kBarTitle, textAlign: TextAlign.center,),
        backgroundColor: kBarBackground,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/washed_couple.png',
                //images/viewmap_couple2.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: getLayout(),
        ),
      ),
    );
  }

  List<Widget> getLayout() {
    bool noRoutes = true;
    if(routesData != null) {
      if(routesData.length > 0) {
        noRoutes = false;
      }
    }
    return <Widget>[
      SizedBox(
        height: 100,
      ),
      Expanded(
        child: Container(
          child: noRoutes ? Container(
                  width: 400,
                  height: 50,
                  alignment: Alignment.center,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    child: Text(
                      'Nenhuma rota existente.',
                      style: TextStyle(fontSize: 30, fontFamily: 'Yanone', fontWeight: FontWeight.bold, color: kForegroundColor),
                    ),
                  ),
                )
              : Container(
                  child: getListView(),
                ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add_location, color: kForegroundColor, size:  30,), //`Icon` to display
              label: Text('CRIAR ROTA', style: kButtonTextStyle),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RouteCreatePage())
                );
              },
            )
          ],
        ),
        height: 60,
        width:  260,
        color: Color.fromRGBO(100, 0, 0, 0.7),
      ),
      SizedBox(
        height: 100,
      ),

    ];
  }

  Widget getListView() {
    var count = routesData == null ? 0 : routesData.length;
    print('routesData.length');
    print(count);

    var listView = ListView.builder(
      itemCount: routesData == null ? 0 : routesData.length,
      itemBuilder: (BuildContext context, int index) {
        String img_url = 'photo.png';
        print(routesData[index]["img_url"].runtimeType);

        if(routesData[index]["img_url"] != null || routesData[index]["img_url"] !=''){
          print(routesData[index]["img_url"]);
          print('routesData[index] null or empty');
          img_url = routesData[index]["img_url"];
        }

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Card(
            color: kRouteCardBackground,
            child: ListTile(
              leading: Image.asset(
                'images/${img_url}',
                width: 60,
                height: 60,
              ),
              title: Text('${routesData[index]["name"]}', style: kRouteCardTitle,),
              subtitle: Text('${routesData[index]["region"]}', style: kRouteCardSubtitle),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                CBTRoute cbtroute = CBTRoute(
                    routesData[index]["id"],
                    routesData[index]["name"],
                    routesData[index]["region"],
                    routesData[index]["img_url"]
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RouteTimelinePage(route: cbtroute))
                );
              },
            ),
          ),
        );
      },
    );

    return listView;
  }
}
