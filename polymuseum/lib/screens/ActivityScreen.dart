import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';
import 'package:polymuseum/screens/RaceScreen.dart';
import 'TennisScreen.dart';

NFCScanner nfcScanner = NFCScanner.instance;

const _NFC_ID_TO_ACTIVITY_MAP = {
  "0": RaceScreen.create,
  "1": Tennis.create,
};

const _NFC_ID_TO_ACTIVITY_NAME = {"0": "Course", "1": "Tennis"};

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() {
    return new _ActivityScreenState();
  }
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    nfcScanner.read().then((result) {
      var activityconstructor = _NFC_ID_TO_ACTIVITY_MAP[result];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => activityconstructor()));
      nfcScanner.stop();
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Activités',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: _NFC_ID_TO_ACTIVITY_NAME.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_NFC_ID_TO_ACTIVITY_NAME.values.elementAt(index),style: new TextStyle(fontFamily: 'Sunday',fontSize: 50,color: Colors.grey),
                      textAlign: TextAlign.center));
            },
          )),
          new Image.asset('images/nfc.png',width: 150,color: Colors.grey,),
          Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                  "  Passez votre téléphone sur le tag NFC d'une des activités suivantes pour la démarrer",
                  style: new TextStyle(fontFamily: 'Broadwell'),
                  )),



        ],
      )),
    );
  }
}
