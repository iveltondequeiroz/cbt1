  import '../models/route.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/CBTTimeLine.dart';

class RouteTimelinePage extends StatefulWidget {
  final CBTRoute route;
  RouteTimelinePage({this.route});

  @override
  _RouteTimelinePageState createState() => _RouteTimelinePageState();
}

class _RouteTimelinePageState extends State<RouteTimelinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kForegroundColor,
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'images/logo_app.png',
              height: 35.0,
            ),
          ),
          title: Text(widget.route.name, style: kBarTitle, textAlign: TextAlign.center,),
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
          ]
      ),
      body: CBTTimeline(title: 'Rota das Cachoeiras'),
    );
  }

  //Widget _myTimelineTabView(){}

  /*Widget _myTimelinePhoneView(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 10,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text('Cachoeira do Santuario', style: TextStyle(
                                color: kBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                            Container(
                              child: Image.asset('images/santuario.jpg', height: 100,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 5,
                        color: kBackgroundColor,
                        margin: EdgeInsets.only(left: 12.5, right: 10),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 10,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text('Cachoeira de Iracema', style: TextStyle(
                                color: kBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                            Container(
                              child: Image.asset('images/iracema.jpg', height: 100,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 5,
                        color: kBackgroundColor,
                        margin: EdgeInsets.only(left: 12.5, right: 10),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 10,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text('Cachoeira do Mutum', style: TextStyle(
                                color: kBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                            Container(
                              child: Image.asset('images/mutum.jpg', height: 100,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 5,
                        color: kBackgroundColor,
                        margin: EdgeInsets.only(left: 12.5, right: 10),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 10,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text('Cachoeira Pedra Furada', style: TextStyle(
                                color: kBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                            Container(
                              child: Image.asset('images/pedrafurada.jpg', height: 100,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );

  }*/

}
/*
body: Column(
        children: <Widget>[
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image.asset('images/r1.png', height: 140,),
            ),
          )*,*/
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              if(constraints.maxWidth > 600.0) {
                return _myTimelinePhoneView();
              } else {
                return _myTimelinePhoneView();
              }
            },
          ),
        ],
      ),
 */