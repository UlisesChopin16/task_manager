import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {

  final FocusNode? focusNode;

  final int maxLines;

  final String label;
  final String hintText;
  final String? helperText;

  final String? Function(String?)? validator;


  final TextEditingController controller;

  final void Function(String)? onChanged;

  const InputComponent({ 
    required this.label,
    required this.hintText,
    required this.controller,
    this.helperText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.maxLines = 1,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            if(focusNode != null){
              FocusScope.of(context).requestFocus(focusNode);
            }
          },
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          focusNode: focusNode,
          minLines: 1,
          textCapitalization: TextCapitalization.sentences,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: const UnderlineInputBorder(
              
            ),
            helperText: helperText,
            helperStyle: TextStyle(
              color: Colors.blue[900]
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue[900]!,
              )
            )
          ),
        ),
        const SizedBox(height: 15,)
      ],
    );
  }
}