
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';


class BoussoleTester extends StatefulWidget {
  @override
  _BoussoleTesterState createState() => new _BoussoleTesterState();
}

class _BoussoleTesterState extends State<BoussoleTester> {
  double _direction;
  double pi = 3.1415926;
  @override
  void initState() {
    super.initState();
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: new Container(
          alignment: Alignment.center,
          color: Colors.brown,
          child: new Transform.rotate(
            angle: ((_direction ?? 0) * (pi / 180)),
            child: new Image.asset('images/Point.png'),
          ),
        ),
      ),
    );
  }
}