import 'package:flutter/material.dart';
import 'package:task_manager/Views/tasks_view.dart';
import 'package:task_manager/Views/tutorial_view.dart';

class PrincipalView extends StatefulWidget {  
  const PrincipalView({ Key? key }) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {

  double _width = 0.0;
  double _height = 0.0;

  List<Color> colors = [
    Colors.blue[300]!,
    Colors.green[600]!,
    Colors.red[700]!,
    Colors.yellow[900]!,
    Colors.purple[900]!,
  ];

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
            circle3(),
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
        color: colors[0],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle1() {
    return Positioned(
      top: _height * 0.2,
      left: 0,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 150,
        color: colors[1],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle2() {
    return Positioned(
      top: _height * 0.5,
      right: 0,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 150,
        color: colors[2],
        fit: BoxFit.fitWidth,
      ),
    );
  }

  circle3() {
    return Positioned(
      bottom: -100,
      left: -60,
      child: Image.asset(
        'assets/images/circulo.png',
        width: 280,
        color: colors[3],
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
        color: colors[4]
      ),
    );
  }

  subtitle() {
    return Text(
      'Organiza tus tareas de forma sencilla',
      style: TextStyle(
        fontSize: 20,
        color: colors[4]
      ),
    );
  }

  startButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TutorialView()
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: colors[4],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        textStyle: const TextStyle(
          fontSize: 24,
        ),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      child: const Text('Iniciar'),
    );
  }


}