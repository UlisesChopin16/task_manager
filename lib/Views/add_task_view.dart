import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/input_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';

class AddTaskView extends StatefulWidget {
  final bool isAdd;
  const AddTaskView({ 
    required this.isAdd,
    Key? key 
  }) : super(key: key);

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final getDataController = Get.put(TaskController());

  bool isCompleted = false;

  double _width = 0.0;
  double _height = 0.0;

  double top = 0;
  double? right = 15;
  double? left;

  

  

  // metodo para obtener el ancho y el largo de la pantalla
  void _getScreenSize(){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Scaffold(
      appBar: widget.isAdd ? null: AppBar(),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            circle1(),
            circle2(),
            circle3(),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: LayoutBuilder(
                  builder: (context, constraints){
                    double height = constraints.maxHeight;
                    double width = constraints.maxWidth;
                    return Stack(
                      children: [
                        Positioned(
                          top: height /5,
                          left: width / 6,
                          child: image(width),
                        ),
                        Positioned(
                          top: 60,
                          left: 20,
                          right: 20,
                          bottom: 30,
                          child: SingleChildScrollView(
                            
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                
                                const InputComponent(
                                  label: 'Titulo',
                                  hintText: 'Interfaz agregar Task',
                                  helperText: 'Obligatorio*',
                                ),
                                SizedBox(height: height*0.03,),
                                const InputComponent(
                                  label: 'Descripcion',
                                  hintText: '(Opcional)',
                                ),
                                SizedBox(height: height*0.03,),
                                const InputComponent(
                                  label: 'Comentarios',
                                  hintText: '(Opcional)',
                                ),
                                SizedBox(height: height*0.03,),
                                const InputComponent(
                                  label: 'Fecha',
                                  hintText: '(Opcional)',
                                ),
                                SizedBox(height: height*0.03,),
                                const InputComponent(
                                  label: 'Tags',
                                  hintText: '(Opcional)',
                                ),
                            
                                const SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                            
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
                                    child: Text(
                                      'Guardar',
                                      style: TextStyle(
                                        fontSize: 18
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  image(double wd){
    return Image.asset(
      'assets/images/task_icon.png',
      width: wd /1.5,
      color:  Colors.blue[200]!.withOpacity(0.14),
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
      child: Image.asset(
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
}