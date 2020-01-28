import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import '../models/user.dart';
import '../widgets/navigation_bar.dart';
import 'register_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    User user;
    String _inputUsername = '';
    String _inputPwd = '';


    sign() async {
      //setState(() {
      //  _isLoading = true;
      //});

      print("sign username");
      Map data = {'username': _inputUsername, 'pwd': _inputPwd};
      var userData;
      final String url = 'http://10.0.2.2:3334/access';
      http.Response response = await http.post(url, body: data);
      //setState(() {
      //  _isLoading = false;
      //});

      if (response.statusCode == 200) {
        userData = json.decode(response.body);
        setState(() {
          user = User(
              userData.first['id'],
              userData.first['username'],
              userData.first['email'],
              userData.first['gender'],
              userData.first['img_url'],
              userData.first['access_level']);
        });
        //Navigator.of(context).push()
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavBar(user: user))
        );
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Acesso nao Autorizado",
          desc: "Usuario ou Senha incorretos.",
          buttons: [
            DialogButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
                color: kBackgroundColor)
          ],
        ).show();
      }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/login_bg.jpg'), fit: BoxFit.cover),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 160,
            ),
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                  color: kForegroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0),
                        blurRadius: 15.0),
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, -10.0),
                        blurRadius: 10.0),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Builder(
                  builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text("Login",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: kBackgroundColor,
                                letterSpacing: .6)),
                        SizedBox(height: 10),
                        TextFormField(
                            //autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                errorStyle: kInputTextError,
                                hintText: 'Usuario ou Email',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Usuario requerido.';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _inputUsername = value;
                              });
                            }),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(fontSize: 22),
                          decoration: InputDecoration(
                            errorStyle: kInputTextError,
                            hintText: 'Senha',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Senha requerida.';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _inputPwd = value;
                            });
                          },
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Esqueceu a Senha ?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 394,
                      height: 100,
                      child: FlatButton(
                        child: Text(
                          'ENTRE',
                          style: TextStyle(
                              color: Color(0xfffefee7),
                              fontSize: 34.0,
                              fontFamily: 'Yanone',
                              fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xff990100),
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            sign();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Novo Usuario ? ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage())
                    );
                  },
                  child: Text("Registre-se",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
