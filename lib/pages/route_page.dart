import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {

  GoogleMapController _controller;

  void mapCreated(controller){
    setState(() {
      _controller = controller;
    });
  }

  double zoomVal = 12;
  double current_lat;
  double current_long;

  int _current_slide = 0;

  LatLng manaus = LatLng(-3.1019400, -60.0250000);
  LatLng santuario = LatLng(-2.0505556, -59.92916667);
  LatLng current_latlng = LatLng(-2.0505556, -59.92916667);
  //LatLng current_latlng = LatLng(-3.1019400, -60.0250000);


  List<String> imgList = [
    'images/santuario.jpg',
    'images/pedrafurada.jpg',
    'images/mutum.jpg',
    'images/iracema.jpg',
    'images/maroaga2.jpg'
  ];

/*  List<String> imgList = [
    'images/manaus.jpg',
    'images/teatro2.jpeg',
    'images/teatroamazonas.jpg',
  ];
*/

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
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
            title: Text('Cachoeira do Santuario', style: kBarTitle,),
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
      body: Container(
        color: kBackgroundColor,
        child: Column(
          children: <Widget>[
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
                      markers: {maruagaMarker, santuarioMarker},
                    ),
                  ),
                ),
                _zoomIn(),
                _zoomOut(),
                _poisContainer()
              ],
            ),
            SizedBox(height: 10,),
            CarouselSlider(
              height: 180,
              initialPage: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              onPageChanged: (index){
                setState(() {
                  _current_slide = index;
                });
              },
              items: imgList.map((imgUrl){
                return Builder(
                  builder: (BuildContext context){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        //border: Border.all(
                        //  color: Colors.black,
                        //  width: 1,
                        //),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.asset(imgUrl, fit: BoxFit.fill,),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(
                imgList,
                    (index, url) {
                  return Container(
                    width: 12.0,
                    height: 12.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current_slide == index
                            ? Colors.red
                            : Colors.grey[400]),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }


  void _goToLocation(double lat, double long){
    setState(() {
      current_latlng = LatLng(lat, long);
    });
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, long),
            zoom: 15,
            tilt: 50,
            bearing: 45
        )
      )
    );
  }


  Widget _poisContainer(){
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 20,),
            Padding(
              padding: EdgeInsets.all(8),
              child: _boxes('images/maruaga.jpg', -3.1303, -60.0234, 'Caverna Maruaga')
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String img, double lat, double lgt, String poiName ){
    return GestureDetector(
      onTap: (){
        _goToLocation(lat, lgt);
      },
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14,
            borderRadius: BorderRadius.circular(24),
            shadowColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(img),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: myDetailsContainer(poiName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDetailsContainer(String poiName){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(poiName, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _zoomIn(){
    print('zoom in');
    print(zoomVal);
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.zoom_in, size: 40,),
        onPressed: (){
          zoomVal++;
          //_minus(zoomVal);
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(-2.0505556, -59.92916667),
                    zoom: zoomVal,
                  )
              )
          );
        },
      ),
    );
  }

  Widget _zoomOut(){
    print('zoom out');
    print(zoomVal);

    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.zoom_out, size: 40,),
        onPressed: (){
          zoomVal--;
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(-2.0505556, -59.92916667),
                    zoom: zoomVal,
                  )
              )
          );
        },
      ),
    );
  }


  Marker maruagaMarker = Marker(
    markerId: MarkerId('maruagaMarker'),
    position: LatLng(-2.045609, -59.970285),
    infoWindow: InfoWindow(title: 'Comunidade Maruaga'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
  );

  Marker santuarioMarker = Marker(
      markerId: MarkerId('Cachoeira Santuario'),
      position: LatLng(-2.055247, -59.928809),

      infoWindow: InfoWindow(title: 'Cachoeira Santuario'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
  );

}
