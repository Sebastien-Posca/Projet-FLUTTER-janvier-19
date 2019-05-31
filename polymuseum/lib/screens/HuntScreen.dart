import 'package:audioplayers/audio_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';

// import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/BeaconsTool.dart';

/*
* Les fonctions présentes dans ce fichiers sont pour la plupart mockee car le client
* ne voulais pas que l'on perde du temps pour un si petit apport de valeur*/
BeaconsTool beaconsTool = BeaconsTool.instance;

class HuntScreen extends StatefulWidget {
  HuntScreen({Key key}) : super(key: key);

  @override
  _HuntScreen createState() => _HuntScreen();
}

class _HuntScreen extends State<HuntScreen> {
  String textAff = "Chargement";
  String textAff2 = "Chargement";
  bool check = false;
  bool show = false;
  String result = "Chargement";
  static AudioCache player = new AudioCache();

  _HuntScreen() : super() {
    getExhibDescription();
    getObjectDescription();
  }

  @override
  void dispose() {
    super.dispose();
    beaconsTool.dispose();
  }

  @override
  void initState() {
    super.initState();
    beaconsTool.initBeacon();
  }

  @override
  Widget build(BuildContext context) {
    print(textAff);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Chasse aux trésors',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Center(
        child:
        ListView(shrinkWrap: true, padding: EdgeInsets.all(20), children: <
            Widget>[
          !check
              ? Container(
            child: AutoSizeText(
              "Chercher l'exposition correspondant a la description suivante :",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          )
              : new Container(),
          !check
              ? Container(
            padding: EdgeInsets.all(30.0),
            child: AutoSizeText(
              textAff,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          )
              : new Container(),
          !check
              ? RaisedButton(
            child: Text('Verifier'),
            onPressed: () {
              checkPresence();
            },
          )
              : new Container(),
          check
              ? Container(
            child: AutoSizeText(
              "Maintenant trouver l'objet correspondant a la description suivante :",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          )
              : new Container(),
          check
              ? Container(
            padding: EdgeInsets.all(30.0),
            child: AutoSizeText(
              textAff2,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          )
              : new Container(),
          check
              ? Container(
            padding: EdgeInsets.only(top: 30.0),
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              icon: Icon(Icons.camera_alt),
              label: Text("Scan"),
              onPressed: _scanQR,
            ),
          )
              : new Container(),
          show
              ? Container(
            padding: EdgeInsets.all(30.0),
            child: AutoSizeText(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
              : new Container(),
          show
              ?
          Container(
            padding: EdgeInsets.only(top: 30.0, left: 70.0, right: 70.0),
            child: FloatingActionButton.extended(
              heroTag: "btn3",
              icon: Icon(Icons.arrow_back),
              label: Text("Retour"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
              : new Container(),
        ]),
      ),
    );
  }

  /*
  * Fonction permettant de recuperer dans la base de donnees la description d'une exposition
  * Elle affecte au texte a afficher (textAff) la description voulue tout en appellant setState
  * ce qui permet de recreer les widgets avec la bonne description affichee*/
  Future getExhibDescription() async {
    try {
      var desc = await DBHelper.instance.getExhibition(3);
      setState(() {
        if (desc != null) {
          textAff = desc["beacons"][0]["description"];
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /*
  * Fonction permettant de recuperer dans la base de donnees la description d'un objet
  * Elle affecte au texte a afficher (textAff2) la description voulue tout en appellant setState
  * ce qui permet de recreer les widgets avec la bonne description affichee*/
  Future getObjectDescription() async {
    try {
      var desc = await DBHelper.instance.getObject(1);
      setState(() {
        if (desc != null) {
          textAff2 = desc["description"];
        }
      });
    } catch (e) {
      print(e);
    }
  }

/*
  * Fonction permettant de verifier si l utilisateur se trouve a proximité du bon beacon
  * Elle met a jour un booleen check tout en appellant setState
  * ce qui permet de recreer les widgets avec le bon booleen*/
  void checkPresence() async {
    print("enter");
    try {
      bool b = false;
      for (int i = 0; i < 100; i++) {
        if (!b)
          b = await beaconsTool.checkPosition(1);
        else
          break;
      }
      setState(() {
        check = b;
        print(check);
      });
    } catch (e) {
      print(e);
    }
  }

  /*
  La fonction _scanQR va changé l'état du screen en fonction de ce qui est lu par le scanner.
  */
  Future _scanQR() async {
    try {
      String qrResult = await Scanner.instance.scan();

      int intId = int.parse(qrResult);

      bool checking = false;
      for (int i = 0; i < 100; i++) {
        if (!checking)
          checking = await beaconsTool.checkPosition(1);
        else
          break;
      }
      if (!checking) {
        setState(() {
          result = "Vous devez aller plus proche !";
        });
        return;
      }

      setState(() {
        if (intId == 1) {
          result = "Bravo";
          check = false;
          show = true;
          try {
            player.play('zelda.wav');
          } catch (e) {
            print(e);
          }
        }
      });
    } catch (ex) {
      print(ex);
    }
  }
}
