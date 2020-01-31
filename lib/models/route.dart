//import 'package:cbt_app/constants.dart';

class CBTRoute {
  int id = -1;
  String name = 'none';
  String region= 'none';
  String imgUrl= 'photo.png';
  int creatorId=-1;
  List<Pois> pois;

  CBTRoute(this.id, this.name, this.region, this.imgUrl);
}

class Pois {
  int id;
  String poi;
  double lat;
  double lgt;
  int categoryId;
}


