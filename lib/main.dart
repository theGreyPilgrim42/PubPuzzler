import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/infra/datasources/question.dart';
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
      home: Scaffold(
        // Header container
        appBar: AppBar(
          leading: const Icon(Icons.quiz),
          title: const Text('Header'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                debugPrint('Menu button is pressed');
              },
            ),
          ],
        ),
        body: const SafeArea(
          child: QuestionCard(),
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  Future<Question> question = fetchQuestion();

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
                      title: const Center(
                        child: Text('Question #1'),
                      ),
                      subtitle: Center(
                        child: Text(snapshot.data!.category.name.toString()),
                      ),
                      trailing: const Icon(Icons.close),
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
                        // TODO: Randomize the order of the answers
                        const SizedBox(height: 10),
                        AnswerTile(answerText: snapshot.data!.correctAnswer),
                        const SizedBox(height: 10),
                        AnswerTile(answerText: snapshot.data!.incorrectAnswers[0]),
                        const SizedBox(height: 10),
                        AnswerTile(answerText: snapshot.data!.incorrectAnswers[1]),
                        const SizedBox(height: 10),
                        AnswerTile(answerText: snapshot.data!.incorrectAnswers[2]),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    question = fetchQuestion();
                  });
                }, 
                child: const Text('Next question'),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
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
  });

  final String answerText;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.all(10),
      child: OutlinedButton(
        onPressed: () => debugPrint("Pressed $answerText"),
        child: Text(answerText),
      )
    );
  }
}
