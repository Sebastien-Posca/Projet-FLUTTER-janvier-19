import 'package:sensors/sensors.dart';

///Wrapper permettant d'être indépendant du plugin utilisé pour la lecture du gyroscope
class Gyroscope {
  static Gyroscope _instance;
  static Gyroscope get instance => _instance;

  List<double> _gyroscopeValues;
  List<double> get gyroscopeValues => _gyroscopeValues;

  static setInstance(Gyroscope obj) {
    _instance = obj;
  }

  listen(void callback(List<double> coordinates)) {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      _gyroscopeValues = <double>[event.x, event.y, event.z];
      callback(_gyroscopeValues);
    });
  }
}
