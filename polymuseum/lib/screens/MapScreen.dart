import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// BeaconsTool beaconsTool = BeaconsTool.instance;

class Line {
  Offset p1;
  Offset p2;
  Line(Offset p1, Offset p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => new _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  //AnimationController controller;
  final lines = <Line>[];
  final points = <Offset>[];
  final tresors = <Offset>[];
  static final tresorsFound = <Offset>[];
  bool checkingState = false;
  String region = '';
  Offset current = Offset(-100, -100);
  _MapScreenState();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<RangingResult> _streamRanging;
  StreamSubscription<double> _streamdoubleRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  double _direction;
  double pi = 3.1415926;
  double shaking = 0.2;
  bool shakeState = false;
  int shakeStopCount = 0;
  String currentBeaconID = '';
  static AudioCache player = new AudioCache();
  Scanner scanner = Scanner.instance;

  @override
  void initState() {
    initBeacon();
    initNotification();
    super.initState();
    downloadMap();
    _streamdoubleRanging = FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double standard = 20.0;
      double ac = pow(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2), 0.5);
      if (ac > standard && !shakeState) {
        setState(() {
          player.play('shaking.wav');
          shakeState = true;
          updateTresor();
          print('startshaking');
        });
      } else if (ac < standard && shakeState && shakeStopCount++ > 5) {
        setState(() {
          shakeState = false;
          shakeStopCount = 0;
          print('stopshaking');
        });
      }
      if (shakeState) {
        shaking == 0 ? shaking = 0.2 : shaking = 0;
      }
    });
  }

  updateTresor() async {
    List<Offset> foundTresors = [];
    int index = 0;
    setState(() {
      checkingState = true;
    });
    while (await DBHelper.instance.getObject(index) != null) {
      var tre = await DBHelper.instance.getObject(index);
      if (tre['checkBeacons']['IDlong'] == currentBeaconID)
        foundTresors.add(
            Offset(tre['position']['x'] * 1.0, tre['position']['y'] * 1.0));
      index++;
    }
    setState(() {
      checkingState = false;
    });
    print('update tresor\n\n\n\n');
    setState(() {
      tresors.clear();
      tresors.addAll(foundTresors);
    });
    if (tresors.length > 0) {
      player.play('found.wav');
      Vibrate.vibrate();
    }
  }

  updatePosition() async {
    Beacon nearby = await getNearby();
    Beacon mark = nearby;
    for (int i = 0; i < 40; i++) {
      Beacon check;
      nearby = await getNearby();
      check = nearby;
      if (check == null) break;
      if (nearby.accuracy < mark.accuracy) mark = nearby;
      // print(mark.minor.toString()+' : '+mark.accuracy.toString());
    }
    if (mark == null) {
      return;
    }

    nearby = mark;
    var o = await DBHelper.instance.getExhibition(3);
    final map = o['beacons'];
    double x;
    double y;
    int j = 0;
    String regionName = '';
    // String UUID = nearby.proximityUUID;
    if (nearby == null) return;
    while (map.length > j) {
      String id = nearby.proximityUUID.toString() +
          nearby.major.toString() +
          nearby.minor.toString();
      if (id == map[j]['ID']) {
        x = map[j]['x'] * 1.0;
        y = map[j]['y'] * 1.0;
        regionName = map[j]['region'];
      }
      j++;
    }
    if (region == regionName) return;
    setState(() {
      // MEMORY LEAK hasn't been handled
      // this cause the memory leak because it can be still running after the
      // _streamdoubleRanging have been cancelled, but it must be a async method called by
      // _streamdoubleRanging beacause _streandoubleRanging itself can't be async
      // -HUANG
      current = Offset(x, y);
      region = regionName;
    });
    currentBeaconID = nearby.proximityUUID +
        nearby.major.toString() +
        nearby.minor.toString();
    print('---------------\n\n\n' +
        'Now at ' +
        region +
        '\n\n\n----------------');
    var text =
        await DBHelper.instance.getExhibitionByUUID(nearby.proximityUUID);
    await _showNotification(text['message'][nearby.minor.toString()]);
  }

  downloadMap() async {
    setState(() {
      region = 'Locating...';
    });
    updatePosition();
    var o = await DBHelper.instance.getExhibition(3);
    final map = o['beacons'];
    var obj = await DBHelper.instance.getExhibition(2);
    int i = 1;
    String index = '';
    while (obj['l' + i.toString()] != null) {
      index = 'l' + i.toString();
      setState(() {
        lines.add(Line(Offset(obj[index][0] * 1.0, obj[index][1] * 1.0),
            Offset(obj[index][2] * 1.0, obj[index][3] * 1.0)));
      });
      i++;
    }
    // var obj2 = await DBHelper.instance.getExhibition(3);
    int j = 0;
    while (map.length > j) {
      setState(() {
        points.add(Offset(map[j]['x'] * 1.0, map[j]['y'] * 1.0));
      });
      j++;
    }
  }

  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    if (_streamdoubleRanging != null) {
      _streamdoubleRanging.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //appBar: new AppBar(title: new Text(region)),
        body: new Builder(
            builder: (context) => new GestureDetector(
                child: new Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/carte.png'),
                            fit: BoxFit.fill)),
                    child: new Stack(children: <Widget>[
                      Positioned(
                          top: 490,
                          left: 35,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.brown[600],
                            icon: Icon(Icons.camera_alt),
                            label: new Text("Scan",
                                style: new TextStyle(fontFamily: 'Broadwell')),
                            onPressed: () {
                              validateTresors();
                            },
                          )),
                      region == 'Locating...' || checkingState
                          ? Positioned(
                              top: 180,
                              left: 280,
                              child: SpinKitPouringHourglass(
                                color: Colors.brown[600],
                                size: 50.0,
                              ))
                          : Positioned(
                              top: 160,
                              left: 280,
                              child: new Image.asset('images/yeah.png')),
                      Positioned(
                          top: 180,
                          left: 35,
                          child: new Text(
                            region,
                            style: new TextStyle(
                                fontSize: 21.0,
                                color: Colors.brown[600],
                                fontFamily: 'Broadwell'),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          )),
                      Positioned(
                          top: 100,
                          left: 35,
                          right: 35,
                          child: new Text(
                            'PolyMuseum',
                            style: new TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 41.0,
                                color: Colors.brown[600],
                                fontFamily: 'Broadwell'),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          )),
                      Positioned(
                          top: 450,
                          left: 230,
                          child: Transform.rotate(
                              angle: shaking,
                              child: new Image.asset('images/shake.png'))),
                      Positioned(
                          top: 560,
                          left: 200,
                          child: new Text(
                            'Secouez le telephone\nCherchez les tresors',
                            style: new TextStyle(
                                fontSize: 11.0,
                                color: Colors.brown[600],
                                fontFamily: 'Broadwell'),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          )),
                      CustomPaint(
                          willChange: true,
                          child: new Container(),
                          foregroundPainter: new MapPainter(
                              lines, points, tresors, tresorsFound)),
                      Positioned(
                          top: current.dy - 27.5,
                          left: current.dx - 27.5,
                          child: Transform.rotate(
                              angle: ((_direction ?? 0) * (pi / 180)),
                              child: new Image.asset('images/Point.png'))),
                    ])))));
  }

  initNotification() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    await flutterLocalNotificationsPlugin.initialize(initSetttings);
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
        updatePosition();
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

  int currentMinor = 9999;
  String currentUUID = '';
  String currentRegion = '';

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

  validateTresors() async {
    String result = '';
    try {
      String qrInfo = await scanner.scan();
      int intId = int.parse(qrInfo);
      bool check = false;
      setState(() {
        checkingState = true;
      });
      for (int i = 0; i < 20; i++) {
        if (!check)
          check = await checkPosition(intId);
        else
          break;
      }
      setState(() {
        checkingState = false;
      });
      if (!check) {
        result = "Vous devez aller plus proche !";
      } else {
        var tre = await DBHelper.instance.getObject(intId);
        for (var f in tresorsFound)
          if (f.dx == tre['position']['x'] * 1.0 &&
              f.dy == tre['position']['y'] * 1.0)
            result = 'Il est deja valide !';
        if (result == '') {
          setState(() {
            tresorsFound.add(
                Offset(tre['position']['x'] * 1.0, tre['position']['y'] * 1.0));
          });
          player.play('validate.wav');
        }
      }
    } on PlatformException catch (ex) {
      if (ex.code == Scanner.instance.cameraAccessDenied) {
        result =
            "L'application n'a pas la permission d'utiliser la camera du telephone";
      } else {
        result = "Une erreur est survenue";
      }
    } on FormatException {
      result = "Vous n'avez rien scanne";
    } catch (ex) {
      result = "Une erreur est survenue";
    }
    if (result != '') showAlertDialog(context, result);
  }

  void showAlertDialog(BuildContext context, String message) {
    NavigatorState navigator =
        context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?" + (navigator == null).toString());
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              title: new Text("UNE ERREUR",
                  style:
                      new TextStyle(fontSize: 20.0, fontFamily: 'Broadwell')),
              content: new Text(message,
                  style:
                      new TextStyle(fontSize: 16.0, fontFamily: 'Broadwell')),
            ));
  }

  Future<bool> checkPosition(int index) async {
    var obj = await DBHelper.instance.getObject(index);
    String beaconUUID = obj['checkBeacons']['UUID'];
    String beaconMinor = obj['checkBeacons']['minor'];
    print('Target Signal not found, Another trail..');
    for (Beacon beacon in _beacons)
      if (beacon.proximityUUID == beaconUUID &&
          beacon.minor.toString() == beaconMinor) if (beacon.accuracy <= 1.5)
        return true;
    return false;
  }
}

class MapPainter extends CustomPainter {
  final lines;
  final points;
  final tresors;
  final tresorsfound;
  MapPainter(this.lines, this.points, this.tresors, this.tresorsfound);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.brown[500]
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 0.5);
    for (Line line in lines) canvas.drawLine(line.p1, line.p2, paint);
    for (Offset point in points) canvas.drawCircle(point, 10, paint);
    paint.color = Colors.red;
    for (Offset tresor in tresors) canvas.drawCircle(tresor, 2, paint);
    paint.color = Colors.green;
    paint.strokeWidth = 8;
    for (Offset found in tresorsfound) canvas.drawCircle(found, 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
