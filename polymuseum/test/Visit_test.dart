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

  DBHelper.setInstance(MockedDBHelper(objects: [
    {
      "id": 0,
      "name": "Chaussure de Zizou",
      "description": "description",
      "question": {"text": "question", "good_answer": "good_answer"}
    }
  ], visits: [
    {
      "id": 0,
      "objects": ["0"]
    }
  ]));
  await DBHelper.instance.updateSettings();

  Scanner.setInstance(new MockedScanner());
  BeaconsTool.setInstance(new MockedBeaconsTool());

  setUp(() {
    global.instance.clear();
  });

  testWidgets('Chargement d`\'une visite', (WidgetTester tester) async {
    await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return MaterialApp(home: VisitorScreen());
    }));

    await tester.tap(find.text("Visite"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Seed"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "0");
    await tester.pumpAndSettle();

    await tester.tap(find.text('Charger la check list de la visite'));
    await tester.pumpAndSettle();

    expect(find.text("Visite chargée"), findsOneWidget);
  });

  testWidgets('Scan d\'un objet d\'une visite chargée',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return MaterialApp(home: VisitorScreen());
    }));

    await tester.tap(find.text("Visite"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Seed"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "0");
    await tester.pumpAndSettle();

    await tester.tap(find.text('Charger la check list de la visite'));
    await tester.pumpAndSettle();

    expect(find.text("Visite chargée"), findsOneWidget);

    //on revient sur le menu visiteur
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    //on scanne l'unique objet de la visite
    await tester.tap(find.text("QRCode"));
    await tester.pumpAndSettle();

    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;
    (Scanner.instance as MockedScanner).qrcode = "0";

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    //on revient sur le menu visiteur
    await tester.pageBack();
    await tester.pumpAndSettle();

    //on vérifie le contenu de la visite chargée
    await tester.tap(find.text("Visite"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("CheckList"));
    await tester.pumpAndSettle();

    //on vérifie qu'il n'y a plus l'objet
    expect(find.text("Chaussure de Zizou"), findsNothing);
    await tester.pumpAndSettle();
  });
}
