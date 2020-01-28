import '../constants.dart';

class User {
  int id = -1;
  String username = 'none';
  String email = 'none';
  String gender ='U';
  String imgUrl = 'none';

  int accessLevel = kUnauthorized;

  User(this.id, this.username, this.email, this.gender, this.imgUrl, this.accessLevel);
}
