import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/domain/question_repository.dart';

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
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
        ),
      );
  }
}

class CustomDropdownButton extends StatefulWidget {
  final List<String> list;
  final String hint;
  final Function callback;

  const CustomDropdownButton({
    super.key,
    required this.list,
    required this.hint,
    required this.callback,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.list.first,
      hint: Text(widget.hint),
      decoration: InputDecoration(
        labelText: widget.hint
      ),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return (value == null || value.isEmpty || !widget.list.contains(value)) ? 'Please choose a ${widget.hint}' : null;
      },
      onSaved: (value) {
        widget.callback(value);
      },
    );
  }
}