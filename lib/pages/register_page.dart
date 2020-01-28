import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cbt1/constants.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../widgets/loader.dart';

//import 'dart:convert';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  User user;
  String _inputUsername = '';
  String _inputPwd = '';
  String _inputEmail = '';
  String _inputGender = 'Masculino';
  bool _isLoading = false;

  List _genders = ['Masculino', 'Feminino', 'LGBTQ'];

  File avatarImage;
  String uploadMessage;

  Future _getImage(BuildContext context, int option) async {
    ImageSource _source = option == kImageSourceGallery
        ? ImageSource.gallery
        : ImageSource.camera;
    File picture = await ImagePicker.pickImage(
        source: _source, maxWidth: 200.0, maxHeight: 200);
    setState(() {
      avatarImage = picture;
    });
    Navigator.of(context).pop();
  }


  Future<void> _imageChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kForegroundTransparentColor,
            elevation: 20,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        _getImage(context, kImageSourceGallery);
                      },
                      icon: Icon(Icons.image, size: 36,),
                      label: Text('Gallery', style: TextStyle(fontSize: 30))),
                  SizedBox(
                    height: 5,
                  ),
                  FlatButton.icon(
                    label: Text('Camera', style: TextStyle(fontSize: 30),),
                    icon: Icon(Icons.camera, size: 36,),
                    onPressed: () {
                      _getImage(context, kImageSourceCamera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget CBTPicker(BuildContext context) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _imageChoiceDialog(context);
            },
            child: avatarImage != null
                ? Image.file(
                    avatarImage,
                    width: 110,
                    height: 130,
                  )
                : Column(
                    children: <Widget>[
                      Icon(Icons.account_circle,
                          size: 80, color: Colors.deepOrange),
                      Text('Pick an Image'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/viewmap_girl.png'),
                fit: BoxFit.fitHeight),
          ),
          child: _isLoading == true ?
          Center(
            child: Container(
              color: kWhiteTransparentColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Text('Criando sua Conta', style: TextStyle(fontSize: 30),),
                  Loader(),
                ],
          ),
            ),):
          ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                height: 100,
                child: Image.asset('images/logo_app.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 360,
                decoration: BoxDecoration(
                    color: kForegroundTransparentColor,
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
                          Row(
                            children: <Widget>[
                              Container(
                                width: 200,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.only(bottom: 70),
                                child: TextFormField(
                                    //autofocus: true,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        errorStyle: kInputTextError,
                                        labelText: 'Usuario *',
                                        hintText: 'Nome do Usuario',
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CBTPicker(context),
                              ),
                            ],
                          ),
                          TextFormField(
                              //autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  errorStyle: kInputTextError,
                                  labelText: 'Email *',
                                  hintText: 'email valido',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email requerido.';
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  _inputEmail = value;
                                });
                              }),
                          TextFormField(
                            obscureText: true,
                            style: TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              errorStyle: kInputTextError,
                              labelText: 'Senha *',
                              hintText: 'Minimo 8 caracters',
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
                          Container(
                            alignment: Alignment.topLeft,
                            //color: Colors.blue,
                            child: DropdownButton<String>(
                              style: TextStyle(color: kBackgroundColor),
                              items: _genders.map((dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (valueSelected) {
                                setState(() {
                                  _inputGender = valueSelected;
                                });
                              },
                              value: _inputGender,
                              icon: Icon(Icons.face),
                            ),
                          ),
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
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: FlatButton(
                          child: Text(
                            'REGISTRE',
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
                              register(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Ja tem sua conta ? ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Acesse",
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
      ),
    );
  }

  imageUpload() async {
    print('image uploading....');

    if(avatarImage == null) {
      setState(() {
        uploadMessage = kUploadingImageError;
      });
      return;
    }

    setState(() {
      uploadMessage = kUploadingImage;
      _isLoading = true;
    });

    String fileName = '${_inputUsername}.jpg'; //avatarImage.path.split('/').last;

    var base64Image = base64Encode(avatarImage.readAsBytesSync());

    Map imageData = {
      'image': base64Image,
      'name': fileName,
      'email': _inputEmail
    };

    final String url = 'http://10.0.2.2:3334/image';
    http.Response response = await http.post(url, body: imageData);

    if (response.statusCode == 200) {
      print('imagem enviada OK');
    } else {
      print('ERRO AO ENVIAR A MSG: ${response.statusCode}');
    };

    setState(() {
      uploadMessage = kUploadingImage;
      //_isLoading = false;
    });

    Timer timer = new Timer(const Duration(milliseconds: 10000), () {
      setState(() {
        _isLoading = false;
      });
    });


    //Navigator.of(context).pop();

  }


  register(context) async {
    print('register user');
    String _gender;

    switch(_inputGender){
      case 'Masculino': _gender = 'M'; break;
      case 'Feminino': _gender = 'F'; break;
      case 'LGBTQ': _gender = 'X'; break;
      default: _gender = 'U';
    }

    Map data = {
      'username': _inputUsername,
      'email': _inputEmail,
      'password': _inputPwd,
      'gender': _gender,
      'level': kGuestAccessLevel,
      'img  url': '${_inputUsername}.jpg'
    };

    var userData;
    final String url = 'http://10.0.2.2:3334/users';
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Sua conta foi criada",
        desc: "Favor ativar sua conta atraves do email enviado.",
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
      ).show().then((val){
        imageUpload();
        //Navigator.pop(context);
      });
      //Navigator.of(context).pop();

    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Erro ao criar conta",
        desc: "Erro ao criar a conta.",
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
}
