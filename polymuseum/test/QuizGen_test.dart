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
    }]
  ));
  await DBHelper.instance.updateSettings();

  Scanner.setInstance(new MockedScanner());
  BeaconsTool.setInstance(new MockedBeaconsTool());
  BeaconsTool.instance.initBeacon();

  testWidgets('Scan d\' un objet et génération d\' un quiz auquel on répond correctement', (WidgetTester tester) async {


    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: VisitorScreen()
        );
      })
    );

    await tester.tap(find.text("QRCode"));
    await tester.pumpAndSettle();


    (Scanner.instance as MockedScanner).qrcode = "0";
    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();

    /******* on fait le quizz *******/

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "good_answer");
    await tester.pumpAndSettle();

    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(find.text("Score: 10 sur 10"), findsOneWidget);
    

    //on vérifie que la question n'est pas compatibilisée comme fausse
    expect(find.text("question"), findsNothing);
    expect(find.text("mauvaise réponse"), findsNothing);
    expect(find.text("good_answer"), findsNothing);


  });
  
  testWidgets('Scan d\' un objet et génération d\' un quiz auquel on répond mal', (WidgetTester tester) async {


    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: VisitorScreen()
        );
      })
    );

    await tester.tap(find.text("QRCode"));
    await tester.pumpAndSettle();


    (Scanner.instance as MockedScanner).qrcode = "0";
    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();


    /******* on fait le quizz *******/

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "mauvaise réponse");
    await tester.pumpAndSettle();

    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(find.text("Score: 0 sur 10"), findsOneWidget);

    //on vérifie que la question, la mauvaise réponse et la correction sont affichées.
    expect(find.text("question"), findsOneWidget);
    expect(find.text("mauvaise réponse"), findsOneWidget);
    expect(find.text("good_answer"), findsOneWidget);


  });
}





