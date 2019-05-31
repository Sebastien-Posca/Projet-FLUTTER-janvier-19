import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:polymuseum/DBHelper.dart';

int currentMinor = 0;
String currentUUID = '';
String currentRegion = 'Locating...';

void main() => runApp(Beacons());
String beaconName;

class Beacons extends StatefulWidget {
  @override
  _BeaconsState createState() => _BeaconsState();
}

class _BeaconsState extends State<Beacons> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  @override
  void initState() {
    super.initState();
    initBeacon();
    initNotification();
  }

  initNotification() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('Notification'),
            content: new Text('$payload'),
          ),
    );
  }

  Future _showNotification(String message) async {
    if (message.isEmpty) return;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Welcome to ' + message,
      'Bonne journee',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
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
      if (result != null && mounted) {
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters);
        });
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

  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    super.dispose();
  }

  void pushWelcomeMessage(String uuid, int minor, double distance) async {
    if (currentMinor == minor && currentUUID == uuid) return;
    if (distance > 0.6) return;
    currentMinor = minor;
    currentUUID = uuid;
    var text = await DBHelper.instance.getExhibitionByUUID(uuid);
    _showNotification(text['message'][minor.toString()]);
    currentRegion = text['message'][minor.toString()] + ' Region';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(currentRegion),
        ),
        body: _beacons == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: ListTile.divideTiles(
                    context: context,
                    tiles: _beacons.map((beacon) {
                      pushWelcomeMessage(
                          beacon.proximityUUID, beacon.minor, beacon.accuracy);
                      return ListTile(
                        title: Text(
                            beacon.proximityUUID + beacon.minor.toString()),
                        subtitle: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                child: Text('Distance: ${beacon.accuracy}m\n',
                                    style: TextStyle(fontSize: 23.0)),
                                flex: 2,
                                fit: FlexFit.tight)
                          ],
                        ),
                      );
                    })).toList(),
              ),
      ),
    );
  }
}
