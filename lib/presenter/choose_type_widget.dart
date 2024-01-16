import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/main.dart';
import 'package:pub_puzzler/presenter/custom_dropdown_button.dart';

class ChooseQuestionTypeForm extends StatefulWidget {
  const ChooseQuestionTypeForm({super.key});

  @override
  ChooseQuestionTypeState createState() {
    return ChooseQuestionTypeState();
  }
}

class ChooseQuestionTypeState extends State<ChooseQuestionTypeForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categoryList = ['Random', ...Category.values.map((e) => e.name.toString()).toList()];
  final List<String> difficultyList = ['Random', ...Difficulty.values.map((e) => e.name.toString()).toList()];
  late Category chosenCategory;
  late Difficulty chosenDifficulty;

  void setCategory(String category) {
    setState(() {
      chosenCategory = Category.fromString(category);
    });
  }

  void setDifficulty(String difficulty) {
    setState(() {
      chosenDifficulty = Difficulty.fromString(difficulty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [
          CustomDropdownButton(list: categoryList, hint: 'Category', callback: setCategory),
          CustomDropdownButton(list: difficultyList, hint: 'Difficulty', callback: setDifficulty),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(category: chosenCategory, difficulty: chosenDifficulty,),
                  ),
                );
              }
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
    );
  }
}