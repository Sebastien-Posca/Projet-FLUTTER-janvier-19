import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:async';

class MockedAccelerometer extends Accelerometer {

  List<double> values = List();

  @override
  listen(void Function(List<double> values) callback) {
    Timer.periodic(Duration(milliseconds: 100), (timer) => callback(values));
  }

}