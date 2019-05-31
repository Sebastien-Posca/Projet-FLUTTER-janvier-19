import 'package:sensors/sensors.dart';

/*
Comme la plupart des class associées à un capteur, il s'agit ici d'un wrapper
permettant au reste du code d'être totalement indépendant de l'implémentation du plugin.
*/
class Accelerometer {
  static Accelerometer _instance;
  static Accelerometer get instance => _instance;

  List<double> _userAccelerometerValues;
  List<double> get accelerometerValues => _userAccelerometerValues;

  static setInstance(Accelerometer obj) {
    _instance = obj;
  }

  //listen appelle la méthode passée en paramètre à chaques fois que la valeur lu par l'accelerometre change et met à jour userAccelerometerValues.
  listen(void callback(List<double> values)) {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _userAccelerometerValues = <double>[event.x, event.y, event.z];
      callback(_userAccelerometerValues);
    });
  }
}
