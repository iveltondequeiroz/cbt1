//import 'package:cbt_app/constants.dart';

class CBTRoute {
  int id = -1;
  String name = 'none';
  String region= 'none';
  String img_url= 'photo.png';
  int creator_id=-1;
  List<Pois> pois;

  CBTRoute(this.id, this.name, this.region, this.img_url);
}

class Pois {
  int id;
  String poi;
  double lat;
  double lgt;
  int category_id;
}


