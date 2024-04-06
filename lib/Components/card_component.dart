import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/Models/task_model.dart';
import 'package:task_manager/Views/add_task_view.dart';
class CardComponent extends StatelessWidget {


  /// put the taskId of the task
  final Task task;

  /// put the check widget in the check parameter
  final Widget check;

  /// function to delete the task
  final void Function() onDelete;

  /// function for the onClosed event
  final void Function(Never?)? onClosed;

  /// function to confirm the dismiss
  final Future<bool> Function()? confirmDismiss;

  /// function to confirm the delete
  final void Function(BuildContext)? confirmDelete;

  const CardComponent({
    required this.task,
    required this.check,
    required this.onDelete,
    required this.confirmDismiss,
    required this.onClosed,
    required this.confirmDelete,
    Key? key 
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2
      ),
      child: OpenContainer(
        transitionDuration: const Duration(seconds: 1),
        onClosed: onClosed,
        openElevation: 0,
        middleColor: Colors.white,
        closedColor: Colors.transparent,
        closedElevation: 0,
        closedBuilder: (context, openContainer){
          return slidableCard(
            taskId: task.taskId!, 
            onTap: openContainer,
            onEdit: (context) => openContainer(),
            child: cardTask( 
              title: task.title, 
              description: task.dueDate ?? 'Sin descripción', 
              check: check
            )
          );
        },
        openBuilder: (context, closeContainer){
          return AddTaskView(isAdd: false, task: task,);
        },
      ),
    );
  }


  Widget slidableCard({
    required int taskId,
    required void Function()? onTap,
    required void Function(BuildContext)? onEdit,
    required Widget child
  }){
    return InkWell(
      onTap: onTap,
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: Key(taskId.toString()),
        endActionPane: actionPane(),

        // The start action pane is the one at the left or the top side.
        startActionPane: actionPane(),

        child: child,
      ),
    );
  }

  actionPane(){
    return ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const StretchMotion(),

      // A pane can dismiss the Slidable.
      dismissible: DismissiblePane(
        onDismissed: onDelete,
        confirmDismiss: confirmDismiss,
        closeOnCancel: true,
      ),
  
      // All actions are defined in the children parameter.
      children: [
        // A SlidableAction can have an icon and/or a label.
        SlidableAction(
          onPressed: confirmDelete,
          borderRadius: BorderRadius.circular(20),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
      ],
    );
  }

  cardTask(
    {
      required String title,
      required String description,
      required Widget check
    }
  ){
    return Card(
      elevation: 3.5,
      color: Colors.blue[50]!,
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
            taskInfo(
              title: title,
              description: description,
            ),
            // Check
            check
          ],
        )
      ),
    );
  }

  taskInfo({
    required String title,
    required String description,
  }){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titulo
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: cardText(
              text: title, 
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 30),
          // Descripcion
          cardText(
            text: description, 
            fontSize: 16, 
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
        color: Colors.blue[800],
      ),
    );
  }

  

}