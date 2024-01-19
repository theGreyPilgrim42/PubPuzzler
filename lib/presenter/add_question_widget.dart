import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/repositories/question_repository.dart';

import 'custom_dropdown_button.dart';

enum CreationState { creating, loading, done}

class AddQuestionForm extends StatefulWidget {
  const AddQuestionForm({
    super.key
  });

  @override
  AddQuestionState createState() {
    return AddQuestionState();
  }
}

class AddQuestionState extends State<AddQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final correctAnswerController = TextEditingController();
  final incorrectAnswerOneController = TextEditingController();
  final incorrectAnswerTwoController = TextEditingController();
  final incorrectAnswerThreeController = TextEditingController();
  final QuestionRepository questionRepository = QuestionRepository();
  late Category chosenCategory;
  late Difficulty chosenDifficulty;
  CreationState creationState = CreationState.creating;

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
  void dispose() {
    questionController.dispose();
    correctAnswerController.dispose();
    incorrectAnswerOneController.dispose();
    incorrectAnswerTwoController.dispose();
    incorrectAnswerThreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (creationState) {
            case CreationState.loading:
              return const Center(child: CircularProgressIndicator());
            case CreationState.done:
              return const Center(child: Text('Successfully created Question'));
            case CreationState.creating:
              return Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  children: [
                    CustomDropdownButton(list: Category.values.map((e) => e.name.toString()).toList(), hint: 'Category', callback: setCategory),
                    CustomDropdownButton(list: Difficulty.values.map((e) => e.name.toString()).toList(), hint: 'Difficulty', callback: setDifficulty),
                    TextFormField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        labelText: 'Question'
                      ),                validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'Please enter a question' : null;
                      },
                    ),TextFormField(
                      controller: correctAnswerController,
                      decoration: const InputDecoration(
                        labelText: 'Correct Answer'
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'Please enter a valid answer' : null;
                      },
                    ),
                    TextFormField(
                      controller: incorrectAnswerOneController,
                      decoration: const InputDecoration(
                        labelText: 'Invalid Answer #1'
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'Please enter an invalid answer' : null;
                      },
                    ),
                    TextFormField(
                      controller: incorrectAnswerTwoController,
                      decoration: const InputDecoration(
                        labelText: 'Invalid Answer #2'
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'Please enter an invalid answer' : null;
                      },
                    ),
                    TextFormField(
                      controller: incorrectAnswerThreeController,
                      decoration: const InputDecoration(
                        labelText: 'Invalid Answer #3'
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'Please enter an invalid answer' : null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            creationState = CreationState.loading;
                          });
                          _formKey.currentState!.save();
                          List<String> incorrectAnswers = [incorrectAnswerOneController.text, incorrectAnswerTwoController.text, incorrectAnswerThreeController.text];
                          Question question = Question(chosenCategory, 'multiple', chosenDifficulty, questionController.text, correctAnswerController.text, incorrectAnswers);
                          await questionRepository.addQuestion(question);
                          setState(() {
                            creationState = CreationState.done;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    )
                  ],
                ),
              );
          }
        }
      ),
    );
  }
}