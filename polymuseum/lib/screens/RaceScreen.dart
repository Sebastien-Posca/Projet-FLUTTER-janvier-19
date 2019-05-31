import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:math' as math;
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';

Accelerometer accelerometer = Accelerometer.instance;
DBHelper dbHelper = DBHelper.instance;
NFCScanner nfcScanner = NFCScanner.instance;

class RaceScreen extends StatefulWidget {
  static create() {
    return new RaceScreen();
  }

  @override
  RaceScreenState createState() {
    return new RaceScreenState();
  }
}

class RaceScreenState extends State<RaceScreen> {
  List<double> acceleration = [0, 0, 0];
  List<double> celerity = [0, 0, 0];

  double maxAcceleration = 0;
  double speed = 0;
  double avgSpeed = 0;
  double maxSpeed = 0;

  double result = 0;
  bool stopped = false;
  String title = "Vitesse en direct : ";

  String time = " ";

  double c = 0;
  double maxC = 0;

  int oldTime = 0;

  List<Widget> leaderboard = [];

  final control = TextEditingController();
  Stopwatch stopwatch = new Stopwatch();

  @override
  void initState() {
    super.initState();
    accelerometer.listen(update);
    nfc();
    stopwatch.start();
  }

  void update(List<double> xyz) {
    if (!stopped) {
      setState(() {
        acceleration = xyz;
        time = stopwatch.elapsed.toString();
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

        //c = speed in Km/H
        c = speed * 3.6;
        maxC = maxSpeed * 3.6;
        result = c;
      });
    }
  }

  Future stop() async {
    setState(() {
      result = maxC;
      time = stopwatch.elapsed.toString();
      stopped = true;
      title = "Vitesse maximum :";
    });
    stopwatch.reset();
    stopwatch.stop();
    updateLeaderBoard();
  }

  updateLeaderBoard() async {
    leaderboard = [Text("\nTABLEAU DES SCORES :\n")];
    var o = await dbHelper.getSprints();
    if (o != null) {
      for (List<String> sprints in o) {
        setState(() {
          leaderboard.add(
              Text(sprints[0] + " Speed : " + sprints[1].toString() + "Km/h"));
        });
      }
    }
  }

  void nfc() async {
    //active le sacanner NFC, si le le téléphone scan le tag NFC correspondant à la fin de la course, la méthode stop() est appelé
    var o = await nfcScanner.read();
    if (o == "4") {
      stop();
    }
  }

  void submit() async {
    if (control.text != null || control.text == "") {
      dbHelper.addSprint(control.text, maxC);
    } else {
      dbHelper.addSprint("default", maxC);
    }
    updateLeaderBoard();
    control.clear();
    return;
  }

  @override
  build(BuildContext context) {
    return new Scaffold(
        body: new ListView(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 50, bottom: 50),
        child: Text(
          "COURSE",
          style: new TextStyle(fontSize: 50.0, fontFamily: 'Broadwell'),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20.0),
        child: Text(
          title,
          style: new TextStyle(fontSize: 30.0),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        result.round().toString(),
        style: new TextStyle(fontSize: 60.0),
        textAlign: TextAlign.center,
      ),
      Text(
        "Km/h",
        style: new TextStyle(fontSize: 40.0),
        textAlign: TextAlign.center,
      ),
      Text(
        time.split(".")[0],
        style: new TextStyle(fontSize: 30.0),
        textAlign: TextAlign.center,
      ),
      stopped
          ? new Container(
              padding: EdgeInsets.only(top: 60.0, left: 80, right: 80),
              child: TextField(
                  controller: control,
                  decoration: InputDecoration(
                    hintText: 'Votre NOM',
                    filled: true,
                  )))
          : new Container(
              padding: EdgeInsets.only(top: 60.0, left: 80, right: 80),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.stop),
                label: Text("Stop"),
                onPressed: stop,
              )),
      !stopped
          ? new Container()
          : new Container(
              padding:
                  EdgeInsets.only(top: 10.0, left: 80, right: 80, bottom: 10),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.send),
                label: Text("Envoyer"),
                onPressed: submit,
              )),
      !stopped
          ? Text(" ")
          : Column(
              children: leaderboard,
            ),
    ]));
  }
}
