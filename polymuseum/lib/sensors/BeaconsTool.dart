import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:polymuseum/DBHelper.dart';

class BeaconsTool {
  static BeaconsTool get instance => _instance;
  static BeaconsTool _instance;

  static setInstance(BeaconsTool obj) {
    _instance = obj;
  }

  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  DBHelper dbHelper = DBHelper.instance;
  double LEGALDISTANCE = 1.5;

  List<Beacon> getBeacons() {
    return _beacons;
  }

  void dispose() {
    _streamRanging.cancel();
  }

  initBeacon() async {
    try {
      await flutterBeacon.initializeScanning;
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      regions.add(Region(
          identifier: 'com.bluecats.BlueCats',
          proximityUUID: '61687109-905F-4436-91F8-E602F514C96D'));
    } else {
      regions.add(Region(identifier: 'com.beacon'));
    }

    _streamRanging = flutterBeacon.ranging(regions).listen((result) {
      if (result != null) {
        _regionBeacons.clear();
        _regionBeacons[result.region] = result.beacons;
        _beacons.clear();
        _regionBeacons.values.forEach((list) {
          _beacons.addAll(list);
        });
        _beacons.sort(_compareParameters);
      }
    });
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  Future<bool> checkPosition(int index) async {
    var obj = await DBHelper.instance.getObject(index);
    String beaconUUID = obj['checkBeacons']['UUID'];
    String beaconMinor = obj['checkBeacons']['minor'];
    print(_beacons.length.toString() + ':trial');
    for (Beacon beacon in _beacons)
      if (beacon.proximityUUID == beaconUUID &&
          beacon.minor.toString() ==
              beaconMinor) if (beacon.accuracy <= LEGALDISTANCE) return true;
    return false;
  }

  Future<Beacon> getNearby() async {
    final find = <Beacon>[];
    var obj = await DBHelper.instance.getExhibition(3);
    int j = 0;
    final map = obj['beacons'];
    while (map.length > j) {
      for (Beacon b in _beacons) {
        String id = b.proximityUUID + b.major.toString() + b.minor.toString();
        if (id == map[j]['ID']) find.add(b);
      }
      j++;
    }
    Beacon mark;
    double min = 999;
    for (Beacon b in find) {
      if (b.accuracy < min) {
        min = b.accuracy;
        mark = b;
      }
    }
    return mark;
  }
}
