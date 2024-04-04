import 'package:flutter/material.dart';
import 'package:task_manager/Components/card_component.dart';

class TasksView extends StatefulWidget {
  const TasksView({ Key? key }) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {

  bool isCompleted = false;

  double _width = 0.0;
  double _height = 0.0;

  double? top;
  double? left;
  double? right;

  int _index = 15;

  // metodo para obtener el ancho y el largo de la pantalla
  void _getScreenSize(){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.blue[900],
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            circle1(),
            taskIcon(),
            circle2(),
            circle3(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(),
                  const SizedBox(height: 20),
                  listTasks(),
                ],
              
              ),
            )
          ],
        ),
      ),
    );
  }

  taskIcon() {
    if(_index == 0){
      setState(() {
        top = _height * 0.3;
        left = _width / 3;
      });
    }else{
      setState(() {
        top = 0;
        left = null;
        right = 15;
      });
    }
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: _index > 0 ? image() : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image(),
          const SizedBox(height: 10),
          SizedBox(
            width: 150,
            child: Text(
              'No tienes ninguna tarea',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue[300]
              ),
            ),
          )
        ],
      ),
    );
  }

  image(){
    return Image.asset(
      'assets/images/task_icon.png',
      width: _index == 0 ? 150 : 80,
      color: _index == 0 ? Colors.blue[200]!.withOpacity(0.5) : Colors.white,
      fit: BoxFit.fitWidth,
    );
  }

  circle1() {
    return Positioned(
      top: -40,
      right: -60,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 200,
        color: Colors.blue[600],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle2() {
    return Positioned(
      top: _height * 0.4,
      left: 0,
      child: _index == 0 ? const SizedBox() : Image.asset(
        'assets/images/circulo.png',
        width: 200,
        color: Colors.blue[400],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle3() {
    return Positioned(
      bottom: -100,
      right: -60,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 280,
        color: Colors.blue[200],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  title() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0, 
        vertical: 50.0
      ),
      child: Text(
        'Your Tasks',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]
        ),
      ),
    );
  }

  listTasks(){
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: _index,
        itemBuilder: (context, index){
          return CardComponent(
            index: index + 1,
            check: cardCheckCompleted(),
          );
        },
      ),
    );
  }

  cardCheckCompleted(){
    return IconButton(
      onPressed: (){
        setState(() {
          isCompleted = !isCompleted;
        });
      },
      icon: Icon(
        isCompleted ? Icons.check_circle : Icons.check_circle_outline,
        color: isCompleted ? Colors.green : Colors.blue[800],
        size: 35,
      ),
    );
  }


}