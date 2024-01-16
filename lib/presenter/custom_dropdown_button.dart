import 'package:flutter/material.dart';

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