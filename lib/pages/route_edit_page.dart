import 'package:cbt1/widgets/loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/loader_screen.dart';
import '../constants.dart';
import '../models/user.dart';
import '../models/route.dart';
import '../models/poi.dart';


class RouteEditPage extends StatefulWidget {
  final User user;
  final CBTRoute route;

  RouteEditPage({this.user, this.route});

  @override
  _RouteEditPageState createState() => _RouteEditPageState();
}

class _RouteEditPageState extends State<RouteEditPage> {
  GoogleMapController _controller;

  LatLng center;// = LatLng(-3.1019400, -60.0250000);
  double zoom = 14;

  List poisData = [];
  List<Poi> pointsOfInterest = [];
    /*Poi(
        name:'Teatro Amazonas',
        address: 'Centro',
        description: 'Teatro Amazonas o Mais famoso',
        imgUrl: 'https://www.acritica.com/uploads/news/image/764841/show_Teatro-Amazonas_7CA1F2E6-6360-42C4-83BD-EAE462B85E36.jpg',
        location: LatLng(-3.1302888, -60.0256082)
    ),*/

  List<Marker> allMarkers = [];

  PageController _pageController;
  int previousPage;

  @override
  void initState() {
    super.initState();
    getLocation();
    getPois();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(_onScroll);
  }

  getPois() async {
    print('RouteEditPage getPois()');

    String url = 'http://10.0.2.2:3334/pois/${widget.route.id}';

    try{
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        poisData = json.decode(response.body);

        //add markers
        poisData.forEach((e){
          allMarkers.add(
              Marker(
                  markerId: MarkerId(e['name']),
                  draggable: false,
                  infoWindow: InfoWindow(title: e['name'], snippet: e['route_id'].toString(),),
                  position: LatLng(e['lat'], e['lgt'])
              )
          );

          pointsOfInterest.add(
              Poi(
                  name: e['name'],
                  address: 'endereco',
                  description: 'desc',
                  imgUrl: e['img_url'],
                  location: LatLng(e['lat'], e['lgt'])
              )
          );
        });
        print('-----------allMarkers-----------');
        print(allMarkers);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'images/logo_app.png',
              height: 35.0,
            ),
          ),
          title: Text(widget.route.name, style: kBarTitle),
          backgroundColor: kBarBackground,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Sair',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
      body: Stack(
        children: <Widget>[
          Container(
            child: center == null ? LoaderScreen(title:'Carregando rota...') :
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: zoom,
              ),
              markers: allMarkers.toSet(),
              onMapCreated: _onMapCreated,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  button(_zoomIn, Icons.zoom_in),
                  SizedBox(height: 16),
                  button(_zoomOut, Icons.zoom_out),
                  SizedBox(
                    height: 16,
                  ),
                  //button(_onAddMarker, Icons.add_location),
                  //SizedBox(height: 16,),
                  //button(_onGetLocation, Icons.flag),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: pointsOfInterest.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _poisList(index);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  _poisList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.6).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            child: widget,
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          //moveCamera();
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                height: 125,
                width: 275,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 90.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: pointsOfInterest[index].imgUrl == null ?
                              AssetImage('images/image.png'):
                              NetworkImage(pointsOfInterest[index].imgUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              pointsOfInterest[index].name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              pointsOfInterest[index].address,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 170,
                              child: Text(
                                pointsOfInterest[index].description,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (_pageController.page.toInt() != previousPage) {
      previousPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  moveCamera() {
    center = pointsOfInterest[_pageController.page.toInt()].location;
    setState(() {
      zoom = 15;
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: pointsOfInterest[_pageController.page.toInt()].location, //_currentPos, //
          zoom: 15,
          bearing: 45.0,
          tilt: 45.0),
    ));
  }



  Future<Position> getLocation() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      center = LatLng(position.latitude, position.longitude);
    });
    print('position: ${position}');
  }

  void _zoomIn() {
    print('zoomIn');
    setState(() {
      if(zoom<21) zoom++;
      print(zoom);
    });
    _zoomTo();
  }

  void _zoomOut() {
    print('zoomOut');

    setState(() {
      if(zoom>0) zoom--;
      print(zoom);
    });
    _zoomTo();
  }

  void _zoomTo() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: center,
        zoom: zoom,
      ),
    ));
  }

  void _onMapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      heroTag: "btn${icon.hashCode}",
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.red,
      child: Icon(
        icon,
        size: 36,
      ),
    );
  }




}
