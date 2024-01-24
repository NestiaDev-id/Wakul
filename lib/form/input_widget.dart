import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  const InputField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
      ),
    );
  }
}
