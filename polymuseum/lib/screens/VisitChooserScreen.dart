import 'package:flutter/material.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/DBHelper.dart';

class VisitChooserScreen extends StatefulWidget {
  @override
  VisitChooserScreenState createState() {
    return new VisitChooserScreenState();
  }
}

class VisitChooserScreenState extends State<VisitChooserScreen> {
  int _seed = -1;
  String _DEFAULT_INVALID_INPUT_MSG = "La seed est un nombre";
  String _DEFAULT_ERROR_MSG = "La seed est invalide";
  String _DEFAULT_SUCCESS_MSG = "Visite chargée";
  String _DEFAULT_WAITING_MSG = "Chargement...";

  String _msg = "";
  bool _bad_seed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Visite personnalisée',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Column(children: <Widget>[
        Container(
          margin: new EdgeInsets.fromLTRB(50, 25, 50, 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: TextField(
            decoration: !_bad_seed
                ? InputDecoration(hintText: 'Seed')
                : InputDecoration(
                    hintText: 'Seed',
                    filled: true,
                    fillColor: Colors.redAccent[100]),
            onChanged: (text) {
              setState(() {
                print("changing 2");
                try {
                  _seed = int.parse(text);
                  _bad_seed = false;
                  _msg = "";
                } catch (e) {
                  _msg = _DEFAULT_INVALID_INPUT_MSG;
                  _bad_seed = true;
                }
              });
            },
            textAlign: TextAlign.center,
          ),
        ),
        RaisedButton(
          child: Text("Charger la check list de la visite"),
          onPressed: () async {
            setState(() {
              _msg = _DEFAULT_WAITING_MSG;
            });

            Map<String, dynamic> visit =
                await DBHelper.instance.getVisit(_seed);
            if (visit == null) {
              setState(() {
                _msg = _DEFAULT_ERROR_MSG;
                _bad_seed = true;
              });
              return;
            }

            global.instance.initCheckList();

            var objectsIds = visit["objects"];

            for (var id in objectsIds) {
              Map<String, dynamic> obj =
                  await DBHelper.instance.getObject(int.parse(id));
              global.instance.addCheckListObject(obj);
            }

            setState(() {
              _msg = _DEFAULT_SUCCESS_MSG;
            });
          },
        ),
        Text(_msg)
      ]),
    );
  }
}
