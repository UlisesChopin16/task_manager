import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {

  final String label;
  final String hintText;
  final String? helperText;

  const InputComponent({ 
    required this.label,
    required this.hintText,
    this.helperText,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            border: const UnderlineInputBorder(
              
            ),
            helperText: helperText,
            helperStyle: TextStyle(
              color: Colors.blue[900]
            )
          ),
        ),
        const SizedBox(height: 15,)
      ],
    );
  }
}