import 'package:flutter/material.dart';
import '../DBHelper.dart';
import '../global.dart' as global;

class VisitGeneratorScreen extends StatelessWidget {
  VisitGeneratorScreen({Key key}) : super(key: key);
  final DBHelper dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Generateur de visite',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: global.instance.getScannedObjects().isEmpty
                ? [Text("Scanner des objets pour pouvoir créer une visite")]
                : <Widget>[
                    Text(
                      'Voici votre clé de visite :',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dbHelper
                          .addVisit(global.instance
                              .getScannedObjects()
                              .map((o) => o["id"].toString())
                              .toSet())
                          .toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
      ),
    );
  }
}
