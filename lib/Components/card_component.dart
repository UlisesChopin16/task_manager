import 'package:flutter/material.dart';
class CardComponent extends StatelessWidget {

  final int index;

  final Widget check;

  const CardComponent({ 
    required this.index,
    required this.check,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return cardTask(index);
  }

  cardTask(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2
      ),
      child: Card(
        elevation: 3,
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15, 
            bottom: 10, 
            right: 15
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              taskInfo(index),
              // Check
              check
            ],
          )
        ),
      ),
    );
  }

  taskInfo(int index){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titulo
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: cardText(
              text: 'Task $index', 
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 30),
          // Descripcion
          cardText(
            text: 'This is a description of the task $index', 
            fontSize: 18, 
          )
        ]
      ),
    );
  }

  Widget cardText({
    required String text,
    required double fontSize,
  }){
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.blue[700],
      ),
    );
  }

  

}