// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:polymuseum/screens/VisitorScreen.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/BeaconsTool.dart';
import 'mockups/MockedDBHelper.dart';
import 'package:polymuseum/DBHelper.dart';
import 'mockups/MockedBeaconsTool.dart';
import 'mockups/MockedScanner.dart';


void main() async {


  global.setInstance(global.DefaultGlobal());


  //MOCKUPS

  DBHelper.setInstance(MockedDBHelper(
    objects: [{
      "id" : 0,
      "name" : "Chaussure de Zizou",
      "description" : "description",
      "question" : {
        "text": "question",
        "good_answer" : "good_answer"
      }
    }],visits: [{
      "id" : 0,
      "objects" : ["0"]
    }]
  ));
  await DBHelper.instance.updateSettings();

  Scanner.setInstance(new MockedScanner());
  BeaconsTool.setInstance(new MockedBeaconsTool());

  setUp((){
    global.instance.clear();
  });


  testWidgets('Chargement d`\'une visite', (WidgetTester tester) async {


    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: VisitorScreen()
        );
      })
    );

    await tester.tap(find.text("Exploration"));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text("MISSION"));
    await tester.pumpAndSettle();

    expect(find.text('Chercher l\'exposition correspondant a la description suivante :'), findsOneWidget);

    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;
    await tester.tap(find.text("Verifier"));
    await tester.pumpAndSettle();

    expect(find.text("Maintenant trouver l'objet correspondant a la description suivante :"), findsOneWidget);

    //on simule le bon scan (la position est déjà ok)
    (Scanner.instance as MockedScanner).qrcode = "1";
    await tester.tap(find.text("Scan"));
    await tester.pumpAndSettle();

    expect(find.text("Bravo"), findsOneWidget);

  });



}





