import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {

  final bool? isRequired;

  final Color color;

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
    required this.color,
    this.isRequired = false,
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
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              children: [
                if(isRequired!)
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                )
              ]
            ),
          )
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
              color: color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: color,
              )
            )
          ),
        ),
        const SizedBox(height: 15,)
      ],
    );
  }
}