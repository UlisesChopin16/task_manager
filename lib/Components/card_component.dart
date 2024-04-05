import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class CardComponent extends StatelessWidget {

  /// put the taskId of the task
  final int taskId;

  /// put the title of the task
  final String title;

  /// put the description of the task 
  final String? description;

  /// put the check widget in the check parameter
  final Widget check;

  /// function to delete the task
  final void Function() onDelete;

  /// function to edit the task
  final void Function(BuildContext)? onEdit;

  /// function to go to the task details
  final void Function() onDetails;


  const CardComponent({
    required this.taskId,
    required this.title,
    required this.check,
    required this.onDelete,
    required this.onEdit,
    required this.onDetails,
    this.description,
    Key? key 
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2
      ),
      child: slidableCard(
        taskId: taskId, 
        child: cardTask( 
          title: title, 
          description: description ?? 'Sin descripción', 
          check: check
        )
      ),
    );
  }


  Widget slidableCard({
    required int taskId,
    required Widget child
  }){
    return InkWell(
      onTap: onDetails,
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey(taskId),
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const DrawerMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Colors.green[400]!,
              foregroundColor: Colors.white,
              flex: 2,
              icon: Icons.edit,
            ),
          ],
        ),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const DrawerMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: onDelete),
      
          // All actions are defined in the children parameter.
          children: const [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),

        child: child,
      ),
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
        color: Colors.blue[700],
      ),
    );
  }

  

}