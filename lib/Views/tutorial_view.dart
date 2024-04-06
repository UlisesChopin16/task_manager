import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/card_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Models/task_model.dart';
import 'package:task_manager/Views/tasks_view.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({ Key? key }) : super(key: key);

  @override
  _TutorialViewState createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> with TickerProviderStateMixin {

  final getDataController = Get.put(TaskController());

  bool isReverse = false;

  bool isFinish = false;

  late SlidableController slidableController = SlidableController(this);

  int isCompleted = 0;

  int index = 0;

  late List<Widget> cards = [
      card(
        index: index,
        title: 'Eliminar tarea 1',
        message: 'Desliza por completo la tarjeta de izquierda a derecha o de derecha a izquierda para eliminar una tarea',
        
      ),
      card(
        index: index,
        slidableController: slidableController,
        title: 'Eliminar tarea 2',
        message: 'Desliza solo un poco la tarjeta de izquierda a derecha o de derecha a izquierda y pulsa el icono de la papelera para eliminar una tarea',
      ),
      card(
        index: index,
        title: 'Completar tarea',
        message: 'Toca el icono el icono con la palomita para marcar una tarea como completada o pendiente',
      ),
      card(
        index: index,
        title: 'Ver detalles',
        message: 'Toca la tarjeta para ver los detalles de la tarea',
      ),
      card(
        index: 4,
        title: 'Agregar tarea',
        message: 'Toca este botón para agregar una nueva tarea',
      ),
  ];

  Future<bool> confirmDismiss() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          titleTextStyle:  TextStyle(
            color: Colors.blue[900],
            fontSize: 20, 
          ),
          title: const Text('¿Estás seguro de eliminar la tarea?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context, false);
              }, 
              child: const Text('Cancelar')
            ),
            TextButton(
              onPressed: (){
                slidableController.dismiss(
                  ResizeRequest(const Duration(milliseconds: 500), () {}),
                );
                slidableController.resizeRequest;
                Navigator.pop(context, true);
              }, 
              child: const Text('Eliminar')
            )
          ],
        );
      }
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildCard(),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  buildCard(){
    return Expanded(
      child: Container(
        color: Colors.grey[300],
        child: PageTransitionSwitcher(
          duration: const Duration(seconds: 1),
          reverse: isReverse,
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return SharedAxisTransition(
              transitionType: SharedAxisTransitionType.horizontal,
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        
          child: cards[index],
        ),
      ),
    );
  }

  card({
    required String title,
    required String message,
    required int index,
    int? isCompleted,
    SlidableController? slidableController,
  }){
    return CardTutorial(
      key: UniqueKey(),
      index: index,
      slidableController: slidableController,
      check: cardCheckCompleted(),
      confirmDismiss: confirmDismiss,
      title: title,
      message: message,
    );
  }

  buildButtons(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue[900],
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 18,
              ),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),
            onPressed: (){
              setState(() {
                isReverse = false;
                index = index > 0 ? index - 1 : 0;
              });
            },
            child: const Text(
              'Atrás'
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 18,
              ),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),
            onPressed: (){
              setState(() {
                isReverse = true;
                if(index < 4){
                  index++;
                }else{
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TasksView()
                    ),
                  );
                }
              });
            },
            child: Text(
              index == 4 ? 'Finalizar' : 'Siguiente'
            ),
          )
        ],
      ),
    );
  }

  Widget cardCheckCompleted(){

    return Obx(
      ()=> IconButton(
        padding: const EdgeInsets.only(left: 15),
        onPressed: () {
          setState(() {
            getDataController.isCompleted.value = getDataController.isCompleted.value > 0 ? 0 : 1;
          });
        },
        icon: Icon(
          getDataController.isCompleted.value > 0 ? Icons.check_circle : Icons.check_circle_outline,
          color: getDataController.isCompleted.value > 0 ? Colors.green : Colors.blue[800],
          size: 35,
        ),
      ),
    );
  }
}

class CardTutorial extends StatelessWidget {

  final int index;

  final SlidableController? slidableController;

  final Widget check;

  final Future<bool> Function()? confirmDismiss;

  final String title;

  final String message;

  const CardTutorial({ 
    required this.index,
    required this.check,
    required this.confirmDismiss,
    required this.title,
    required this.message,
    this.slidableController,

    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return card();
  }

  card(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 30
      ),
      child: Card(
        elevation: 3.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: LayoutBuilder(
          builder: (context, constrains) {
            double width = constrains.maxWidth;
            double height = constrains.maxHeight;
            return Stack(
              children: [
                imageBackground(height, width),
                Positioned(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(index == 4)
                            floatingActionButton()
                            else
                            CardComponent(
                              slidableController: slidableController,
                              task: Task(
                                taskId: index,
                                title: title,
                                isCompleted: 0,
                                dueDate: DateTime.now().toString().split(' ')[0],
                              ),
                              isEnable: false,
                              check: check,
                              onClosed: (never){},
                              onDelete:(){
                              },
                              confirmDismiss: confirmDismiss,
                              confirmDelete: (context)=> confirmDismiss!(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          bottom: 80.0,
                          top: 20
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 22
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }

  imageBackground(double height, double width){
    return Positioned(
      top: height /5,
      left: width / 6,
      child: image(width),
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

  floatingActionButton() {
    return FloatingActionButton.large(
      backgroundColor: Colors.blue[900],
      onPressed: (){},
      child: const Icon(Icons.add),
    );
  }


}