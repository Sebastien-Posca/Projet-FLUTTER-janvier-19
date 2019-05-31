import 'package:flutter/material.dart';
import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/screens/CompassScreen.dart';
import 'package:polymuseum/screens/Beacons.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/screens/TennisScreen.dart';
import 'RaceScreen.dart';

class HidenTestingScreen extends StatelessWidget {
  final DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Dev Test',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Scan QR-code'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Beacons Finder'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Beacons()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Boussole Tester'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BoussoleTester()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Tennis'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tennis()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Run'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RaceScreen()),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
