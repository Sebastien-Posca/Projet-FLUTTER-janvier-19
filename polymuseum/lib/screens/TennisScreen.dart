import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:math' as math;
import 'package:polymuseum/DBHelper.dart';

Accelerometer accelerometer = Accelerometer.instance;
DBHelper dbHelper = DBHelper.instance;

class Tennis extends StatefulWidget {
  static create() {
    return new Tennis();
  }

  @override
  TennisState createState() {
    return new TennisState();
  }
}

class TennisState extends State<Tennis> {
  List<double> celerity = [0, 0, 0];

  double speed = 0;
  double avgSpeed = 0;
  double maxSpeed = 0;

  double result = 0;
  bool stopped = true;
  bool over = false;
  String title = "Donner un coup puissant pour obtenir votre score";

  double c = 0;
  double maxC = 0;

  int oldTime = 0;

  Stopwatch stopwatch = new Stopwatch();

  void update(List<double> xyz) {
    if (!stopped) {
      setState(() {
        celerity[0] = xyz[0] * (stopwatch.elapsedMilliseconds - oldTime) / 1000;
        celerity[1] = xyz[1] * (stopwatch.elapsedMilliseconds - oldTime) / 1000;
        celerity[2] = xyz[2] * (stopwatch.elapsedMilliseconds - oldTime) / 1000;

        //calculs de la vitesse selon les 3 axes
        speed = math.sqrt(math.pow(celerity[0], 2) +
            math.pow(celerity[1], 2) +
            math.pow(celerity[2], 2));

        oldTime = stopwatch.elapsedMilliseconds;

        if (speed > maxSpeed) {
          maxSpeed = speed;
        }

        c = speed * 3.6;
        maxC = maxSpeed * 3.6;
        result = c;
      });
    }
  }

  Future stop() async {
    setState(() {
      result = maxC;
      stopped = true;
      title = "";
    });
    stopwatch.reset();
    stopwatch.stop();
    over = true;
  }

  start() {
    accelerometer.listen(update);
    stopwatch.start();
    setState(() {
      stopped = false;
    });
  }

  @override
  build(BuildContext context) {
    return new Scaffold(
        body: new ListView(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 50, bottom: 50),
        child: Text(
          "TENNIS",
          style: new TextStyle(fontSize: 50.0, fontFamily: 'Broadwell'),
          textAlign: TextAlign.center,
        ),
      ),
      !over
          ? Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20.0),
              child: Text(
                title,
                style: new TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            )
          : Container(),
      over
          ? Text(
              result.round().toString(),
              style: new TextStyle(fontSize: 80.0),
              textAlign: TextAlign.center,
            )
          : new Container(),
      over
          ? Text(
              "POINTS",
              style: new TextStyle(fontSize: 65.0),
              textAlign: TextAlign.center,
            )
          : new Container(),
      new Container(
          padding: EdgeInsets.only(top: 60.0, left: 80, right: 80),
          child: !over
              ? (stopped
                  ? FloatingActionButton.extended(
                      icon: Icon(Icons.label_important),
                      label: Text("Start"),
                      onPressed: start,
                    )
                  : FloatingActionButton.extended(
                      icon: Icon(Icons.stop),
                      label: Text("Stop"),
                      onPressed: stop,
                    ))
              : Container())
    ]));
  }
}
