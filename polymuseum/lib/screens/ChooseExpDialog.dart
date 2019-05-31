import 'package:flutter/material.dart';
import 'package:polymuseum/screens/HuntScreen.dart';
import 'package:polymuseum/screens/MapScreen.dart';

class ChooseExpDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Material(
            type: MaterialType.transparency,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ))),
                      margin: const EdgeInsets.all(12.0),
                      child: new Column(children: <Widget>[
                        new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 40.0, 10.0, 28.0),
                            child: Center(
                                child: new Text('Vous voulez?',
                                    style: new TextStyle(
                                      fontFamily: 'Broadwell',
                                      fontSize: 25.0,
                                    )))),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _genderChooseItemWid(1, context),
                              _genderChooseItemWid(2, context)
                            ]),
                        new FlatButton(
                            child: new Text(
                              "Annuler",
                              style: new TextStyle(fontFamily: 'Broadwell'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ]))
                ])));
  }

  Widget _genderChooseItemWid(var gender, var context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            gender == 1
                ? MaterialPageRoute(builder: (context) => MapScreen())
                : MaterialPageRoute(builder: (context) => HuntScreen()),
          );
        },
        child: Column(children: <Widget>[
          gender == 1
              ? Material(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.explore, color: Colors.white, size: 90.0),
                  ))
              : Material(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.new_releases,
                        color: Colors.white, size: 90.0),
                  )),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 40.0),
              child: Text(gender == 1 ? 'CARTE' : 'MISSION',
                  style: TextStyle(
                      fontFamily: 'Broadwell',
                      color: Colors.black,
                      fontSize: 15.0)))
        ]));
  }
}
