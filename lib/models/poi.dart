import 'package:google_maps_flutter/google_maps_flutter.dart';

class Poi {
  String name;
  String address;
  String description;
  String imgUrl;
  LatLng location;

  Poi({this.name, this.address, this.description, this.imgUrl, this.location});
}


/*final List<ManausPOIs> pointsOfInterest = [
  ManausPOIs(
      name:'Teatro Amazonas',
      address: 'Centro Manaus',
      description: 'Teatro Amazonas o Mais famoso',
      imgUrl: 'https://www.acritica.com/uploads/news/image/764841/show_Teatro-Amazonas_7CA1F2E6-6360-42C4-83BD-EAE462B85E36.jpg',
      location: LatLng(-3.1302888, -60.0256082)
  ),
  ManausPOIs(
      name:'Ponta Negra',
      address: 'Ponta Negra',
      description: 'Praia de Ponta Negra',
      imgUrl: 'https://www.acritica.com/uploads/news/image/766405/show_ponta_negra_81FD2513-98B4-47B6-BC0A-9D8CBCE3FB36.JPG',
      location: LatLng(-3.0615895,-60.106551)
  ),
  ManausPOIs(
      name:'Mercado Municipal ',
      address: 'Centro',
      description: 'Mercado Mun. Adolpho Lisboa',
      imgUrl: 'https://lh5.googleusercontent.com/p/AF1QipM5F1MLmkZCCn_e7F3jUpkBdDt_aJroPKh19p32=w426-h240-k-no',
      location: LatLng(-3.139806, -60.0235566)
  )
];
*/

