import 'package:flutter/material.dart';
import 'package:polymuseum/screens/QuizResultScreen.dart';

class QuizPersoScreen extends StatefulWidget {

  final List<Map<String, dynamic>> objects;

  QuizPersoScreen({Key key, @required this.objects}) : super(key: key);

  @override
  _QuizPersoScreen createState() => _QuizPersoScreen(objects : objects);
}
  class _QuizPersoScreen extends State<QuizPersoScreen> {

    final List<String> textAff = [];
    final List<Map<String, dynamic>> objects;
    bool enter = false;
    List<String> answers = [];
    List<String> goodAnswers = [];
    List<List<String>> wrongAnswers = [];
    int score = 0;
    int scoreTotal = 0;

    _QuizPersoScreen({@required this.objects}) : super() {
      for(var o in objects){
        answers.add("");
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
        title: Text('Quiz personnalise',
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
            new Expanded(
              child:
                ListView.builder(
                  itemCount: objects.length,
                  itemBuilder: (context, index) {
                    if(textAff.length==objects.length) {
                      print(index);
                      return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child : Text('${textAff[index]}'),
                                ),
                                Expanded(
                                  child : TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Votre Réponse'
                                    ),
                                    //controller: myController,
                                    onChanged: (text) {
                                      answers[index] = text.trim();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(''),
                          ]
                      );
                    }else{
                      return ListTile(
                        title: Text('Chargement des questions'),
                      );
                    }
                  },
                ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 70, right: 70, bottom: 10.0),
              child : FloatingActionButton.extended(
                heroTag: "btn1",
                icon: Icon(Icons.check),
                label: Text("Valider"),
                onPressed: () {
                  checkAnswers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizResultScreen(score : score, scoreTotal : scoreTotal, wrongAnswers: wrongAnswers)),
                  );
                },
              ),
            ),
          ]
        ),
     ),
    );
  }

  /* Fonction permettant de verifier si les reponses entrees par l utilisateur sont juste
  * et ainsi de calculer le score (score) fait par ce dernier ainsi que le score total (scoreTotal)
   */
  void checkAnswers(){
    print('---------Valider---------');
    print(answers);
    for(int  i=0; i<goodAnswers.length;++i){
      if(answers[i] == goodAnswers[i].trim())
        score = score + 10;
      else
        wrongAnswers.add([textAff[i], answers[i], goodAnswers[i]]);
    }
    scoreTotal = 10 * objects.length;
    print(score);
    print(scoreTotal);
    print("---------------------");
    print(wrongAnswers);
  }

}