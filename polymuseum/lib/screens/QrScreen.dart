import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:flutter/services.dart';
import '../DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/BeaconsTool.dart';

import 'package:auto_size_text/auto_size_text.dart';

DBHelper dbHelper = DBHelper.instance;
BeaconsTool beaconsTool = BeaconsTool.instance;
//Beacons

class QrScreen extends StatefulWidget {
  @override
  QrScreenState createState() {
    return new QrScreenState();
  }
}

class QrScreenState extends State<QrScreen> {
  String result = "Appuyer sur le bouton pour en savoir plus sur un objet";
  String description = " ";
  String question = " ";
  String answer = " ";
  bool _question = false;
  bool _show = false;

  final questionController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    questionController.dispose();
    beaconsTool.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    beaconsTool.initBeacon();
  }
  /*
  La fonction _scanQR va changé l'état du screen en fonction de ce qui est lu par le scanner. 
  Les exceptions (tels que la permissions refusé ou le fait de ne rien scanner) sont attrapées et affiche un message à l'attention de l'utilisateur.
  */

  Future _scanQR() async {
    try {
      String qrResult = await Scanner.instance.scan();
      setState(() {
        //le message "chargement en cours..." est affiché en attendant de recevoir le résultat de la base de données et du scanner de beacon
        result = "Chargement en cours...";
        description = " ";
        question = " ";
        answer = " ";
      });
      int intId = int.parse(qrResult);
      var o = await dbHelper.getObject(intId);

      bool check = false;
      for (int i = 0; i < 100; i++) {
        if (!check) {
          //recherche du beacon correspondant à l'objet scanné
          check = await beaconsTool.checkPosition(intId);
        } else
          break;
      }
      if (!check) {
        setState(() {
          //si l'utilisateur est trop loin du beacon correspondant à l'objet scanné, il est invité à se rapprocher
          result = "Vous devez aller plus proche !";
        });
        return;
      }

      setState(() {
        if (o != null) {
          result = o["name"].toString();
          description = o["description"].toString();
          question = o["question"]["text"];
          answer = o["question"]["good_answer"];
          _question = true;
          global.instance.addScannedObject(o);
        } else {
          result = "Le QR code n'est pas valide";
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == Scanner.instance.cameraAccessDenied) {
        setState(() {
          result =
              "L'application n'a pas la permission d'utiliser la caméra du téléphone";
        });
      } else {
        setState(() {
          result = "Une erreur est survenue";
        });
      }
    } on FormatException {
      setState(() {
        result = "Vous n'avez rien scanné";
      });
    } catch (ex) {
      setState(() {
        result = "Une erreur est survenue";
      });
    }
  }

  void _showQuestion() {
    setState(() {
      if (_show) {
        setState(() {
          _show = false;
          _question = true;
        });
      } else {
        setState(() {
          _show = true;
          _question = false;
        });
      }
    });
  }

  void _validateQuestion() {
    if (Text(questionController.text).data == answer) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("BONNE REPONSE"),
            content: new Text("BRAVO"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("MAUVAISE REPONSE"),
            content: new Text("réessayer"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Text('QR Scanner',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  fontFamily: 'Broadwell')),
        ),
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 50),
                child: Text(
                  "INFORMATIONS",
                  style: new TextStyle(fontSize: 30.0, fontFamily: 'Broadwell'),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0.0),
                child: AutoSizeText(
                  result,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: AutoSizeText(
                    description,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  )),
              _show
                  ? Container(
                      padding: EdgeInsets.only(top: 30.0),
                      child: AutoSizeText(
                        question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ))
                  : new Container(),
              _show
                  ? Container(
                      margin:
                          EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: questionController,
                        decoration: InputDecoration(
                          hintText: 'Votre Réponse',
                          filled: true,
                        ),
                      ),
                    )
                  : new Container(),
              _question
                  ? Container(
                      padding: EdgeInsets.only(top: 30.0, left: 70, right: 70),
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                        icon: Icon(Icons.help_outline),
                        label: Text("Question"),
                        onPressed: _showQuestion,
                      ),
                    )
                  : new Container(),
              !_question && _show
                  ? Container(
                      padding: EdgeInsets.only(top: 30.0, left: 70, right: 70),
                      child: FloatingActionButton.extended(
                        heroTag: "btn3",
                        icon: Icon(Icons.help_outline),
                        label: Text("Valider"),
                        backgroundColor: Colors.green,
                        onPressed: _validateQuestion,
                      ),
                    )
                  : new Container(),
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 70, right: 70),
                child: FloatingActionButton.extended(
                  heroTag: "btn2",
                  icon: Icon(Icons.camera_alt),
                  label: Text("Scan"),
                  onPressed: _scanQR,
                ),
              ),
            ])));
  }
}
