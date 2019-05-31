import 'package:flutter/material.dart';
import 'package:polymuseum/main.dart';

class QuizResultScreen extends StatelessWidget {

  final int score;
  final int scoreTotal;
  final List<List<String>> wrongAnswers;

  QuizResultScreen({Key key, @required this.score, @required this.scoreTotal, @required this.wrongAnswers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Text('Résultats du quiz',
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
              Expanded(child: 
                ListView.builder(
                  itemCount: wrongAnswers.length,
                  itemBuilder: (context, index){
                    return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child : Text('${wrongAnswers[index][0]}'),
                              ),
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child : Text('${wrongAnswers[index][1]}', style: TextStyle(color : Colors.red),),
                              ),
                              Expanded(
                                child: Text('${wrongAnswers[index][2]}',style: TextStyle(color : Colors.green),),
                              )
                            ],
                          ),
                          Text(''),
                        ]
                    );
                  },  
                )
              ),
              Text('Score: $score sur $scoreTotal'),
              Text(''),
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 70, right: 70, bottom: 10.0),
                child : FloatingActionButton.extended(
                  heroTag: "btn1",
                  icon: Icon(Icons.backspace),
                  label: Text("Retour"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstScreen()),
                    );
                  },
                ),
              ),
            ]
        )
      ),
    );
  }
}