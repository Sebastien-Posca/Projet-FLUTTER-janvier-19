import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';

class DocGenScreen extends StatefulWidget {
  final List<Map<String, dynamic>> objects;

  DocGenScreen({Key key, @required this.objects}) : super(key: key);

  @override
  _DocGenScreenState createState() => _DocGenScreenState(objects: objects);
}

class _DocGenScreenState extends State<DocGenScreen> {
  List<String> textAff = [];
  List<Map<String, dynamic>> objects;
  bool enter = false;
  List<String> goodAnswers = [];

  _DocGenScreenState({@required this.objects}) : super() {
    for (var o in objects) {
      textAff.add(o["question"]["text"]);
      goodAnswers.add(o["question"]["good_answer"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Document',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 70, right: 70, bottom: 10.0),
              child : FloatingActionButton.extended(
                heroTag: "btn1",
                icon: Icon(Icons.picture_as_pdf),
                label: Text("Generer un document"),
                onPressed: () {
                  if (textAff.length == objects.length && goodAnswers.length == objects.length) {
                    _write();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Fonction demandant la permission d'ecrire dans le stockage externe du telephone
   */
  requestPermission() async {
    final res =
        await Permission.requestSinglePermission(PermissionName.Storage);
    print(res);
  }

  /*Fonction permettant la creation du fichier dans le dossier voulu*/
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    await requestPermission();
    String dir = (await getExternalStorageDirectory()).path;
    return new File('$dir/Test/quiz.txt');
  }

  /*Ecriture dans le fichier*/
  Future<Null> _write() async {
    print(textAff.length);
    var buffer = new StringBuffer();
    int i = 1;
    int j = 1;
    for (String s in textAff) {
      buffer.write('$i . ');
      buffer.write(s);
      buffer.write('\n\n');
      ++i;
    }
    buffer.write('\n\n\n');
    for (String s in goodAnswers) {
      buffer.write('$j . ');
      buffer.write(s);
      buffer.write('\n\n');
      ++j;
    }
    await (await _getLocalFile()).writeAsString(buffer.toString());
  }
}
