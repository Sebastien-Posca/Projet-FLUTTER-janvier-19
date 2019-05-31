import 'package:flutter/material.dart';
import 'package:polymuseum/global.dart' as global;

class CheckListScreen extends StatefulWidget {
  CheckListScreen({Key key}) : super(key: key);

  @override
  CheckListScreenState createState() {
    return new CheckListScreenState();
  }
}

class CheckListScreenState extends State<CheckListScreen> {
  CheckListScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Check list',
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: 'Broadwell')),
      ),
      body: ListView.builder(
        itemCount: global.instance.checkListObjectsCount,
        itemBuilder: (context, index) => ListTile(
            title: new Text(
                global.instance.checkListObjects[index]["name"].toString())),
      ),
    );
  }
}
