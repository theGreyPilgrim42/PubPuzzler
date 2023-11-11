import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          child: Card(
            elevation: 12.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.question_mark),
                  title: Center(
                    child: Text('Question 1'),
                  ),
                  subtitle: Center(
                    child: Text('History'),
                  ),
                  trailing: Icon(Icons.close),
                ),
                Column(
                  children: [
                    Text(
                      "Some question?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    AnswerTile(answerText: "Answer 1"),
                    SizedBox(height: 10),
                    AnswerTile(answerText: "Answer 2"),
                    SizedBox(height: 10),
                    AnswerTile(answerText: "Answer 3"),
                    SizedBox(height: 10),
                    AnswerTile(answerText: "Answer 4"),
                    SizedBox(height: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
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
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
        ),
        onPressed: () => debugPrint("Pressed $answerText"),
        child: Text(answerText),
      )
    );
  }
}
