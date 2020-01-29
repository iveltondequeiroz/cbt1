import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../constants.dart';
import '../pages/user_profile_page.dart';
import '../pages/user_routes_page.dart';
import '../pages/stats_page.dart';
import '../models/user.dart';

class NavBar extends StatefulWidget {
  final User user;

  NavBar({this.user});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  GlobalKey _bottomNavigationKey = GlobalKey();

  int pageIndex = 0;
  UserProfilePage _profile;
  UserRoutesPage _routes;
  final StatsPage _stats = StatsPage();


  Widget _showPage; // = UserProfilePage();

  @override
  void initState() {
    super.initState();
    setState(() {
      _profile = UserProfilePage(user: widget.user);
      _routes = UserRoutesPage(user: widget.user);
      _showPage = _profile;
    });
  }


  Widget pageChooser(int page) {
    switch(page){
      case 0 :
        return _profile;
        break;

      case 1 :
        return _routes;
        break;

      case 4 :
        return _stats;
        break;

      default:
        return Container(
          child: Text('No Page Found'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Tooltip(message: 'Perfil', child: Icon(Icons.perm_identity, size: 30), ),
            Tooltip(message: 'Rotas', child: Icon(Icons.map, size: 30)),
            Tooltip(message: 'Livros', child: Icon(Icons.import_contacts, size: 30)),
            Tooltip(message: 'Outros', child: Icon(Icons.fastfood, size: 30)),
            Tooltip(message: 'Estatisticas', child: Icon(Icons.filter_9, size: 30)),
          ],
          color: kBarBackground,
          buttonBackgroundColor: kBarBackground,
          backgroundColor: Color(0xff990100),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (tappedIndex) {
            setState(() {
              _showPage = pageChooser(tappedIndex);
            });
          },
          /*onTap: (index) {
            setState(() {
              _page = index;
            });
          },*/
        ),
        body: Container(
          color: kBackgroundColor,
          child: _showPage,
          /*child: Center(
            child: Column(
              children: <Widget>[
                Text(_page.toString(), textScaleFactor: 10.0),
                RaisedButton(
                  //child: Text('Go To Page of index 1'),
                  onPressed: () {
                    final CurvedNavigationBarState navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState.setPage(1);
                  },
                )
              ],
            ),
          ),*/
        ));
  }
}
