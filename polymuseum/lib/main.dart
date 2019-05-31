import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/Gyroscope.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';
import 'package:polymuseum/welcomePage/ChooseDialog.dart';
import 'package:polymuseum/welcomePage/SplagePage.dart';
import 'package:polymuseum/sensors/BeaconsTool.dart';

void main() async {
  //DBHelper
  DBHelper.setInstance(DBHelper());
  await DBHelper.instance.updateSettings();

  //Global
  global.setInstance(global.DefaultGlobal());

  /*** ZONE D'INITIALISATION DES WRAPPERS ***/

  //QrCode Scanner
  Scanner.setInstance(new Scanner());

  //Accelerometer
  Accelerometer.setInstance(new Accelerometer());

  //Gyroscope
  Gyroscope.setInstance(new Gyroscope());

  //NFC Scanner
  NFCScanner.setInstance(new NFCScanner());

  //Beacon Scanner
  BeaconsTool.setInstance(new BeaconsTool());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    title: 'PolyMusem',
    home: FirstScreen(),
  ));
}

class FirstScreen extends StatelessWidget {
  final DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new Container(
              color: Colors.grey[200],
              child: new ChooseDialog(),
            )
      },
    );
  }
}
