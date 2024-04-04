import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Views/tasks_view.dart';

class PrincipalView extends StatefulWidget {  
  const PrincipalView({ Key? key }) : super(key: key);

  @override
  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {

  double _width = 0.0;
  double _height = 0.0;
  // metodo para obtener el ancho y el largo de la pantalla
  void _getScreenSize(){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            taskIcon(),
            circle1(),
            circle2(),
            Positioned(
              width: _width,
              height: _height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  title(),
                  const SizedBox(height: 20),
                  subtitle(),
                  const SizedBox(height: 40),
                  startButton(),
                ],
              
              ),
            )
          ],
        ),
      ),
    );
  }

  taskIcon() {
    return Positioned(
      top: 0,
      right: 20,
      child: Image.asset(
        'assets/images/task_icon.png',
        width: 150,
        color: Colors.blue[200],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle1() {
    return Positioned(
      top: _height * 0.45,
      right: 0,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 150,
        color: Colors.blue[100],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle2() {
    return Positioned(
      bottom: -100,
      left: -60,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 280,
        color: Colors.blue[50],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  title() {
    return Text(
      'Task Manager',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900]
      ),
    );
  }

  subtitle() {
    return Text(
      'Organiza tus tareas de forma sencilla',
      style: TextStyle(
        fontSize: 20,
        color: Colors.blue[900]
      ),
    );
  }

  startButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TasksView()
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[900],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        textStyle: const TextStyle(
          fontSize: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      child: const Text('Iniciar'),
    );
  }


}