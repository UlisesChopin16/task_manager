import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/card_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Models/task_model.dart';
import 'package:task_manager/Views/add_task_view.dart';

final pageBucket = PageStorageBucket();

class TasksView extends StatefulWidget {
  const TasksView({ Key? key }) : super(key: key);

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> with TickerProviderStateMixin{

  List<SlidableController> slidableControllers = [];

  final  getDataController = Get.put(TaskController());

  bool isCompleted = false;

  double _width = 0.0;
  double _height = 0.0;

  double top = 0;
  double? right = 15;
  double? left;
  
  List<Color> colors = [
    Colors.blue[900]!,
    Colors.red[900]!,
    Colors.yellow[900]!,
    Colors.green[900]!,
    Colors.purple[900]!,
  ];

  int count = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getDataController.getTasks(token: 'SoteloChopinUlisesShie');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void onClosed(never){
    if(getDataController.listChange.value){
      getDataController.getTasks(token: 'SoteloChopinUlisesShie');
      getDataController.listChange.value = false;
    }
  }

  onDelete(int index, Task task) async {
    await getDataController.deleteTask(task: task, context: context);

    getDataController.getDataModelTask.value.tasks.removeAt(index);
    getDataController.getDataModelTask.refresh();
  }

  Future<bool> confirmDismiss(int index) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          titleTextStyle:  TextStyle(
            color: colors[index],
            fontSize: 20, 
          ),
          title: const Text('¿Estás seguro de eliminar la tarea?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context, false);
              }, 
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: colors[index],
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context, true);
              }, 
              child: Text(
                'Eliminar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors[index]
                ),
              )
            )
          ],
        );
      }
    );
  } 

  void confirmDelete(int index, Task task, int count) async {
    bool response = await confirmDismiss(count);
    if(response){
      slidableControllers[index].dismiss(
        ResizeRequest(const Duration(milliseconds: 300), () { }),
      );
      onDelete(index, task);
    }
  }


  // metodo para obtener el ancho y el largo de la pantalla
  void _getScreenSize(){
    setState(() {
      _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
    });

  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Obx(
      ()=> Scaffold(
        floatingActionButton: floatingActionButton(),
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

  floatingActionButton() {
    return OpenContainer(
      transitionDuration: const Duration(seconds: 1),
      onClosed: onClosed,
      closedShape: const CircleBorder(),
      closedBuilder: (context, action){
        return FloatingActionButton.large(
          backgroundColor: colors[4],
          onPressed: action,
          child: const Icon(Icons.add),
        );
      },
      openBuilder: (context, action){
        return AddTaskView(isAdd: true, color: colors[0]);
      },
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
              image(true),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: Text(
                  'No tienes ninguna tarea',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: colors[2]
                  ),
                ),
              )
            ],
          );
        }else if(getDataController.getDataModelTask.value.tasks.isEmpty && getDataController.isLoading.value){
          top = 0;
          left = null;
          right = 15;
          child = image(false);
        }else{
          top = 0;
          left = null;
          right = 15;
          child = image(false);
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

  image(bool isEmpty){
    return Image.asset(
      'assets/images/task_icon.png',
      width: isEmpty ? 150 : 80,
      color: isEmpty ? colors[2].withOpacity(0.5) : Colors.white,
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
        color: colors[1],
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
          color: colors[2],
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
        color: colors[3],
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
        child: getDataController.isLoading.value ? const Center(child: CircularProgressIndicator(),) : 
        PageStorage(
          bucket: pageBucket,
          child: ListView.builder(
            key: const PageStorageKey('tasks'),
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: getDataController.getDataModelTask.value.tasks.length,
            itemBuilder: (context, index){
              final task = getDataController.getDataModelTask.value.tasks[index];
              task.token = 'SoteloChopinUlisesShie';
              slidableControllers.add(SlidableController(this));
          
              int maxColors = colors.length;
              int count = index % maxColors;
          
              return CardComponent(
                slidableController: slidableControllers[index],
                task: task,
                color: colors[count],
                isEnable: true,
                onClosed: (never)=> onClosed(never),
                onDelete:()=> onDelete(index,task),
                confirmDismiss: ()=> confirmDismiss(count),
                confirmDelete: (context)=> confirmDelete(index, task, count),
                check: cardCheckCompleted(task,index),
              );
            },
          ),
        ),
      ),
    );
  }

  cardCheckCompleted(Task task, int index){

    return IconButton(
      padding: const EdgeInsets.only(left: 15),
      onPressed: () async {

        getDataController.getDataModelTask.value.tasks[index] = await getDataController.getTask(task: task);

        task = getDataController.getDataModelTask.value.tasks[index];

        task.isCompleted = task.isCompleted == 0 ? 1 : 0;

        if(!context.mounted) return;
        await getDataController.updateTask(task: task, context: context);
        setState(() {});
      },
      icon: Icon(
        task.isCompleted > 0 ? Icons.check_circle : Icons.check_circle_outline,
        color: task.isCompleted > 0 ? Colors.green : Colors.black,
        size: 35,
      ),
    );
  }

  

}