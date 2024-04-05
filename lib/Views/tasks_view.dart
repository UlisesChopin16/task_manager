import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/card_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Models/task_model.dart';

class TasksView extends StatefulWidget {
  const TasksView({ Key? key }) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {


  final getDataController = Get.put(TaskController());

  bool isCompleted = false;

  double _width = 0.0;
  double _height = 0.0;

  double top = 0;
  double? right = 15;
  double? left;

  @override
  void initState() {
    super.initState();
    // getDataController.addTask(
    //   task: Task(
    //     token: 'SoteloChopinUlisesShie',
    //     title: 'Obtener mensaje',
    //     isCompleted: 1,
    //     // formato de fecha YYYY-MM-DD
    //     dueDate: DateTime.now().toString().split(' ')[0],
    //     comments: '',
    //     description: 'Obtener el mensaje de confirmacion',
    //     tags: '',
    //   )
    // );

    // getDataController.updateTask(
    //   task: Task(
    //     taskId: 1913,
    //     token: 'SoteloChopinUlisesShie',
    //     title: 'Actualizar task',
    //     isCompleted: 0,
    //     // formato de fecha YYYY-MM-DD
    //     dueDate: DateTime.now().toString().split(' ')[0],
    //     comments: '',
    //     description: 'Actualizar task',
    //     tags: '',
    //   )
    // );

    getDataController.getTasks(token: 'SoteloChopinUlisesShie');
  }

  void onDelete(int index) {
    print('Delete');
  }

  void onEdit(BuildContext context){
    print('Edit');
  }

  void onDetails(int index){

    print(getDataController.getDataModelTask.value.tasks[index].taskId);
  }

  // metodo para obtener el ancho y el largo de la pantalla
  void _getScreenSize(){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Obx(
      ()=> Scaffold(
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
                    getDataController.isLoading.value ? const SizedBox() : const SizedBox(height: 20),
                    listTasks(),
                  ],
                
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  taskIcon() {
    Widget child = const SizedBox();
    return Obx(
      (){
        if(getDataController.getDataModelTask.value.tasks.isEmpty && !getDataController.isLoading.value){
          top = _height * 0.3;
          left = _width / 3;
          right = null;
          child = Column(
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
          );
        }else if(getDataController.getDataModelTask.value.tasks.isEmpty && getDataController.isLoading.value){
          top = 0;
          left = null;
          right = 15;
          child = image();
        }else{
          top = 0;
          left = null;
          right = 15;
          child = image();
        }
        return Positioned(
          top: top,
          right: right,
          left: left,
          child: child
        );
      },
    );
  }

  image(){
    return Image.asset(
      'assets/images/task_icon.png',
      width: 80,
      color:  Colors.white,
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
    return Obx(
      ()=> Positioned(
        top: _height * 0.4,
        left: 0,
        child: getDataController.getDataModelTask.value.tasks.isEmpty ? const SizedBox() : Image.asset(
          'assets/images/circulo.png',
          width: 200,
          color: Colors.blue[400],
          fit: BoxFit.fitWidth,
        ),
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
    return Obx(
      () => Expanded(
        child: getDataController.isLoading.value ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: getDataController.getDataModelTask.value.tasks.length,
          itemBuilder: (context, index){
            final task = getDataController.getDataModelTask.value.tasks[index];
            return CardComponent(
              taskId: task.taskId!,
              title: task.title,
              description: task.description,
              onDelete:()=> onDelete(index),
              onEdit: (context)=> onEdit(context),
              onDetails: ()=> onDetails(index),
              check: cardCheckCompleted(index),
            );
          },
        ),
      ),
    );
  }

  cardCheckCompleted(int index){
    return IconButton(
      padding: const EdgeInsets.only(left: 15),
      onPressed: (){
        setState(() {
          getDataController.getDataModelTask.value.tasks[index].isCompleted = getDataController.getDataModelTask.value.tasks[index].isCompleted == 0 ? 1 : 0;
        });
      },
      icon: Icon(
        getDataController.getDataModelTask.value.tasks[index].isCompleted > 0 ? Icons.check_circle : Icons.check_circle_outline,
        color: getDataController.getDataModelTask.value.tasks[index].isCompleted > 0 ? Colors.green : Colors.blue[800],
        size: 35,
      ),
    );
  }


}