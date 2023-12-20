import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/infra/datasources/question.dart';
import 'package:pub_puzzler/presenter/add_question_widget.dart';
import 'presenter/color_schemes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Puzzler',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const PubPuzzlerApp(),
    );
  }
}

// TODO: Refactor to manage state in PubPuzzlerApp Widget
class PubPuzzlerApp extends StatelessWidget {
  const PubPuzzlerApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          // Header container
          appBar: AppBar(
            title: const Text('Header'),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.quiz)),
              Tab(icon: Icon(Icons.add_circle_outline)),
              Tab(icon: Icon(Icons.insert_chart_outlined_rounded)),
            ]),
          ),
          body: TabBarView(
            children: [
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QuestionScreen(),
                          ),
                        );
                      }, 
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.start),
                          Text('Start Quiz'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddQuestionForm(),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_chart_outlined_rounded),
                  Text('Statistics'),
                ]
              ),
            ],
          ),
        ),
      );
  }
}

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int score = 0;

  void updateScore() {
    setState(() {
      score += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Score: $score',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          QuestionCard(updateScore: updateScore),
        ],
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.updateScore
  });

  final Function updateScore;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late Future<Question> question = fetchQuestion();

  bool answered = false;
  int questionNumber = 1;

  Future<void> checkAnswer(String answer) async {
    debugPrint('Called checkAnser with $answer');
    if (answer.isEmpty) return;
    setState(() {
      question.then((q) => answer == q.correctAnswer ? (q.answerState = AnswerState.correct, widget.updateScore()) : q.answerState = AnswerState.incorrect);
      answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.5,
      child: FutureBuilder<Question>(
        future: question,
        builder: (BuildContext context, AsyncSnapshot<Question> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Card(
                elevation: 12.5,
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.question_mark),
                      title: Center(
                        child: Text('Question #$questionNumber'),
                      ),
                      subtitle: Center(
                        child: Text(snapshot.data!.category.name.toString()),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          snapshot.data!.question,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (var answer in snapshot.data!.answers) 
                          AnswerTile(
                            answerText: answer, 
                            checkAnswer: checkAnswer, 
                            answered: answered, 
                            correctAnswer: snapshot.data!.correctAnswer,
                          ),
                        if (answered) 
                          Text(
                            snapshot.data!.answerState == AnswerState.correct ? 'Correct!' : 'Incorrect!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: snapshot.data!.answerState == AnswerState.correct ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: !answered ? null : () {
                  setState(() {
                    question = fetchQuestion();
                    answered = false;
                    questionNumber++;
                  });
                }, 
                child: const Text('Next question'),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },      
      )
    );
  }
}

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.answerText,
    required this.checkAnswer,
    required this.answered,
    required this.correctAnswer,
  });

  final Function(String answer) checkAnswer;
  final String answerText;
  final bool answered;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(2),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: answered && answerText == correctAnswer ? Theme.of(context).primaryColor : answered && answerText != correctAnswer ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
          side: answered && answerText == correctAnswer ? BorderSide(color: Theme.of(context).primaryColor) : answered && answerText != correctAnswer ? BorderSide(color: Theme.of(context).colorScheme.error) : BorderSide(color: Theme.of(context).colorScheme.secondary)
        ),
        onPressed: answered ? null : () => checkAnswer(answerText),
        child: Text(answerText),
      )
    );
  }
}
