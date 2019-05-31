import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconScanner {
  static BeaconScanner _instance;
  static BeaconScanner get instance => _instance;

  static setInstance(BeaconScanner obj) {
    _instance = obj;
  }

  ranging(List<Region> regions) {
    return flutterBeacon.ranging(regions);
  }

  initializeScanning() async {
    await flutterBeacon.initializeScanning;
  }
}
