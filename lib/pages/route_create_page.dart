import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:convert';
import '../constants.dart';
import '../models/route.dart';
import '../credentials.dart';
import '../models/manaus_pois.dart';


class RouteCreatePage extends StatefulWidget {
  @override
  _RouteCreatePageState createState() => _RouteCreatePageState();
}

class _RouteCreatePageState extends State<RouteCreatePage> {
  bool _routeCreated = false;
  String _appbar_title = 'CRIAR ROTA';


  List<Marker> allMarkers = [];
  PageController _pageController;
  int previousPage;


  List routeData;
  final _formKey = GlobalKey<FormState>();
  final _route = CBTRoute(-1,'','','photo.png');

  GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Map<String, Marker> markers = {};

  static const LatLng _center = const LatLng(-3.1019400, -60.0250000);
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  LatLng manaus = LatLng(-3.1019400, -60.0250000);
  // teatro -3.129935, -60.023508
  LatLng santuario = LatLng(-2.0505556, -59.92916667);
  double zoomVal = 12;

  @override
  void initState() {
    super.initState();
    pointsOfInterest.forEach((e){
      allMarkers.add(
        Marker(
          markerId: MarkerId(e.name),
          draggable: false,
          infoWindow: InfoWindow(title: e.name, snippet: e.description,),
          position: e.location
        )
      );
    });

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(_onScroll);
  }

  void _onScroll(){
    if(_pageController.page.toInt() != previousPage){
      previousPage = _pageController.page.toInt();
      moveCamera();
    }

  }

  moveCamera(){
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: pointsOfInterest[_pageController.page.toInt()].location,
          zoom: 15,
          bearing: 45.0,
          tilt: 45.0
        ),
      )
    );
  }

  _poisList(index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1-(value.abs() * 0.3) + 0.6).clamp(0.0,1.0);
        }
        return Center(
          child: SizedBox(
            child: widget,
            height: Curves.easeInOut.transform(value)*125.0,
            width: Curves.easeInOut.transform(value)*350.0,
          ),
        );
      },
      child: InkWell(
        onTap: (){
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
                      blurRadius: 10.0
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
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
                            image: NetworkImage(
                              pointsOfInterest[index].imgUrl
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pointsOfInterest[index].name,
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            pointsOfInterest[index].address,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 170,
                            child: Text(
                              pointsOfInterest[index].description,
                              style: TextStyle(
                                fontSize: 11,
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
          ],
        ),

      ),
    );
  }


  void _onMapCreated(controller){
    setState(() {
      _controller = controller;
    });
  }

  void _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  void _onMapType(){
    print('_onMapTypedButtonPressed');
    print(_currentMapType );

    setState(() {
      _currentMapType = _currentMapType != MapType.normal ?  MapType.normal : MapType.satellite ;
    });

  }

  void _onAddMarker(){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a title',
            snippet: 'This is a snippet'
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
     });
  }

  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  //Future<void>
  void _moveToPosition(Position pos) {
    //final GoogleMapController mapController = await _controller.future;
    //if(mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 15.0,
          tilt: 50,
          bearing: 30,
        )
    )
    );
  }
  void _showLocationInfo(){

  }

  /*void _onGetLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('currentLocation');
    print(currentLocation);

    setState(() {
      markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      markers["Current Location"] = marker;
    });
  }
*/
  void _onGetLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    var currentAddress = await _getAddress(currentLocation);
    await _moveToPosition(currentLocation);

    setState(() {
      markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: currentAddress),
      );
      markers["Current Location"] = marker;
    });
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
          title: Text(_appbar_title, style: kBarTitle,),
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
          ]
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-50,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12
              ),
              mapType: _currentMapType,
              markers: Set.from(allMarkers),
              /*circles: Set<Circle>()
                ..add(Circle(
                  circleId: CircleId('hi2'),
                  center: LatLng(-3.1019400, -60.0250000),
                  radius: 100,
                  strokeWidth: 100,
                  strokeColor: Colors.black,
                )),*/
              //markers: _markers,
              //markers: markers.values.toSet(),
              onCameraMove: _onCameraMove,
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
                }
              ),
            ),
          ),
          _routeCreated ? Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  button(_onMapType, Icons.zoom_in),
                  SizedBox(height: 16),
                  button(_onMapType, Icons.zoom_out),
                  SizedBox(height: 16,),
                  button(_onAddMarker, Icons.add_location),
                  //SizedBox(height: 16,),
                  //button(_onGetLocation, Icons.flag),
                ],
              ),
            ),
          ) : Padding(
            padding: EdgeInsets.all(10),
          ),
          SizedBox(height: 300,),
          _routeCreated ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Container(
                    child: TextField(
                      onTap: () async {
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: PLACES_API_KEY,
                          language: "pt",
                          components: [
                            Component(Component.country, "br")
                          ],
                        );
                      },
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (values){
                        //appState.sendRequest(value);
                      },
                      decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            width: 10,
                            height: 10,
                            child: Icon(
                              Icons.add_location,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'LOCAL',
                          hintStyle: kHintTextStyle,
                          //border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, top: 15)
                      ),
                    ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 34,
                  child: FlatButton(
                    color: Color(0xff990100),
                    onPressed: (){},
                    child: Text('Double Tap para inserir Local de Interesse', style: kButtonTextStyle),
                  ),
                ),
              ],
            ),
          ) :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.white,
                height: 240,
                child: Builder(
                  builder: (context) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment,
                        children: <Widget>[
                          TextFormField(
                            style: kInputTextStyle,
                            decoration: InputDecoration(
                                errorStyle: kInputTextError,
                                labelText: 'Nome da Rota',
                                labelStyle: kInputLabelStyle
                            ),
                            validator: (value){
                              if(value.isEmpty) {
                                return "Favor informar o nome da rota.";
                              }
                            },
                            onSaved: (value){
                              setState(() {
                                _route.name = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Color.fromRGBO(100, 0, 0, 0.7),
                            height: 60,
                            width: 180,
                            child: Row(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.map, color: kForegroundColor, size:  30,), //`Icon` to display
                                  label: Text('Criar Rota', style: kButtonTextStyle),
                                  onPressed: (){
                                    final form = _formKey.currentState;
                                    if(form.validate()){
                                      form.save();
                                      createRoute();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget button(Function function, IconData icon ){
    return FloatingActionButton(
      onPressed: function,
      heroTag: "btn${icon.hashCode}",
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.red,
      child: Icon(icon, size: 36,),
    );
  }

  createRoute() async {
    print("CREATE ROUTE");

    final String url = 'http://10.0.2.2:3334/routes';
    final body = {
      "name": _route.name,
      "region": _route.region,
      "creator": _route.creator_id.toString(),
      "img_url": _route.img_url
    };

    print(body);



    http.Response response = await http.post(url, body: body);


    if(response.statusCode == 200) {
      print('ok');
      var alertStyle = AlertStyle(
        //overlayColor: Colors.blue[400],
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Color.fromRGBO(91, 55, 185, 1.0),
        ),
      );


      Alert(
        context: context,
        style: alertStyle,
        type: AlertType.info,
        title: "Nova Rota",
        desc: "Rota criada com sucesso.",
        buttons: [
          DialogButton(
            child: Text(
              "COOL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(91, 55, 185, 1.0),
            radius: BorderRadius.circular(10.0),
          ),
        ],
      ).show();
    }


    setState(() {
      routeData = json.decode(response.body);
      _routeCreated = true;
      _appbar_title = _route.name;
      print(routeData);
    });
  }
}


/*
Column(
        children: <Widget>[
          Container(
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                height: 300,
                child: Builder(
                  builder: (context) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            style: kInputTextStyle,
                            decoration: InputDecoration(
                              errorStyle: kInputTextError,
                              icon: Icon(Icons.photo, color: Colors.red,),
                                labelText: 'Nome da Rota',
                                labelStyle: kInputLabelStyle
                            ),
                            validator: (value){
                              if(value.isEmpty) {
                                return "Favor informar o nome da rota.";
                              }
                            },
                            onSaved: (value){
                              setState(() {
                                _route.name = value;
                              });
                            },
                          ),
                          TextFormField(
                            style: kInputTextStyle,
                            decoration: InputDecoration(
                                errorStyle: kInputTextError,
                                icon: Icon(Icons.photo, color: Colors.red,),
                                labelText: 'Regiao',
                                labelStyle: kInputLabelStyle
                            ),
                            validator: (value){
                              if(value.isEmpty) {
                                return "Favor informar a regiao.";
                              }
                            },
                            onSaved: (value){
                              setState(() {
                                _route.region = value;
                              });
                            },
                          ),
                          TextFormField(
                            style: kInputTextStyle,
                            decoration: InputDecoration(
                                icon: Icon(Icons.photo, color: Colors.red,),
                                labelText: 'Picture',
                                labelStyle: kInputLabelStyle
                            ),
                            onSaved: (value){
                              setState(() {
                                if(value !='') {
                                  _route.img_url = value;
                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            color: Color.fromRGBO(100, 0, 0, 0.7),
                            height: 60,
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.map, color: kForegroundColor, size:  30,), //`Icon` to display
                                  label: Text('Criar Rota', style: kButtonTextStyle),
                                  onPressed: (){
                                    final form = _formKey.currentState;
                                    if(form.validate()){
                                      form.save();
                                      createRoute();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: (MediaQuery.of(context).size.height/2)+20,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: current_latlng,
                      zoom: zoomVal,
                    ),
                    onMapCreated: mapCreated,
                    //markers: {maruagaMarker, santuarioMarker},
                  ),
                ),
              ),
              //_zoomIn(),
              //_zoomOut(),
              //_poisContainer()
            ],
          ),
        ],
      ),
 */