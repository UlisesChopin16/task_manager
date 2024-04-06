import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/input_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Models/task_model.dart';

class AddTaskView extends StatefulWidget {

  final bool isAdd;

  final Task? task;

  const AddTaskView({ 
    required this.isAdd,
    this.task,
    Key? key 
  }) : super(key: key);

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {

  final getDataController = Get.put(TaskController());

  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;


  double _width = 0.0;
  double _height = 0.0;

  double top = 0;
  double? right = 15;
  double? left;

  FocusNode focusNodeTitle = FocusNode();
  FocusNode focusNodeDescription = FocusNode();
  FocusNode focusNodeComments = FocusNode();
  FocusNode focusNodeDate = FocusNode();
  FocusNode focusNodeTags = FocusNode();

  int completed = 0;
  int completedCompare = 0;

  String buttonText = 'Agregar Task';

  String titleCompare = '';
  String descriptionCompare = '';
  String commentsCompare = '';
  String dateCompare = '';
  String tagsCompare = '';

  String title = '';
  String description = '';
  String comments = '';
  String date = '';
  String tags = '';

  Task task = Task(
    title: '',
    isCompleted: 0
  );

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController tagsController = TextEditingController();


  @override
  void initState() {
    super.initState();
    
      
    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      if(!widget.isAdd){
        buttonText = 'Editar Task';
        task = await getDataController.getTask(
          task: widget.task!,
        );

        titleController.text = task.title;
        descriptionController.text = task.description ?? '';
        commentsController.text = task.comments ?? '';
        dateController.text = task.dueDate ?? '';
        tagsController.text = task.tags ?? ''; 

        titleCompare = task.title;
        descriptionCompare = task.description ?? '';
        commentsCompare = task.comments ?? '';
        dateCompare = task.dueDate ?? '';
        tagsCompare = task.tags ?? '';
        completedCompare = task.isCompleted;
        completed = task.isCompleted;

        setState(() {
          
        });
      }

    });
  }

  onChangedTitle(String value){
    setState(() {
      title = value;
      if(title != titleCompare){
        isEditing = true;
      }else{
        isEditing = false;
      }
    });
  }

  onChangedDescription(String value){
    setState(() {
      description = value;
      if(description != descriptionCompare){
        isEditing = true;
      }else{
        isEditing = false;
      }
    });
  }

  onChangedComments(String value){
    setState(() {
      comments = value;
      if(comments != commentsCompare){
        isEditing = true;
      }else{
        isEditing = false;
      }
    });
  }

  onChangedDate(String value){
    setState(() {
      date = value;
      if(date != dateCompare){
        isEditing = true;
      }else{
        isEditing = false;
      }
    });
  }

  onChangedTags(String value){
    setState(() {
      tags = value;
      if(tags != tagsCompare){
        isEditing = true;
      }else{
        isEditing = false;
      }
    });
  }

  String? validatorTitle(String? value){
    if(value!.trim().isEmpty){
      return 'Este campo es obligatorio';
    }
    return null;
  }

  onPressed(){
    final FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus && focus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      if(_formKey.currentState!.validate()){
        if(widget.isAdd){
          getDataController.addTask(
            task: Task(
              token: 'SoteloChopinUlisesShie',
              isCompleted: 0,
              title: title,
              description: description,
              comments: comments,
              dueDate: date,
              tags: tags
            ),
            context: context
          );
        }else{
          setState(() => isEditing = false);
          getDataController.updateTask(
            task: Task(
              taskId: task.taskId,
              token: 'SoteloChopinUlisesShie',
              isCompleted: completed,
              title: title,
              description: description,
              comments: comments,
              dueDate: date,
              tags: tags
            ),
            context: context
          );
        }
      }
    }

  }

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
            bodyForm(),
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

  bodyForm(){
    return Positioned(
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
            return Obx(
              ()=> Stack(
                children: [
                  imageBackground(height, width),
                  Positioned(
                    top: 60,
                    left: 20,
                    right: 20,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(!getDataController.isLoading.value)
                          forms(height)
                        else
                         const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        const SizedBox(height: 50,),
                        formButton(),
                      ],
                    ),
                  )
                ],
              ),
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

  forms(double height){
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formTitle(),
              sizeBetween(height),
              formDescription(),
              sizeBetween(height),
              formComments(),
              sizeBetween(height),
              Row(
                children: [
                  Flexible(child: formDate()),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¿Completada?', 
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Checkbox(
                        value: completed == 1,
                        activeColor: Colors.blue[600],
                        onChanged: (value){
                          setState(() {
                            completed = value! ? 1 : 0;
                            if(completed != completedCompare){
                              isEditing = true;
                            }else{
                              isEditing = false;
                            }
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
              sizeBetween(height),
              formTags(),
            ],
          ),
        ),
      ),
    );
  }

  sizeBetween(double height)=> SizedBox(height: height*0.03,);

  Widget formTitle(){
    return InputComponent(
      controller: titleController,
      focusNode: focusNodeTitle,
      onChanged: onChangedTitle,
      validator: validatorTitle,
      label: 'Titulo',
      hintText: 'Interfaz agregar Task',
      helperText: 'Obligatorio*',
    );
  }

  Widget formDescription(){
    return InputComponent(
      controller: descriptionController,
      focusNode: focusNodeDescription,
      onChanged: onChangedDescription,
      label: 'Descripcion',
      hintText: '(Opcional)',
      maxLines: 4,
    );
  }

  Widget formComments(){
    return InputComponent(
      controller: commentsController,
      focusNode: focusNodeComments,
      onChanged: onChangedComments,
      label: 'Comentarios',
      hintText: '(Opcional)',
      maxLines: 4,
    );
  }

  Widget formDate(){
    return InputComponent(
      controller: dateController,
      focusNode: focusNodeDate,
      onChanged: onChangedDate,
      label: 'Fecha',
      hintText: '(Opcional)',
    );
  }

  Widget formTags(){
    return InputComponent(
      controller: tagsController,
      focusNode: focusNodeTags ,
      onChanged: onChangedTags,
      label: 'Tags',
      hintText: '(Opcional)',
    );
  }

  Widget formButton(){
    return ElevatedButton(
      onPressed: isEditing ? onPressed : null,
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18
          ),
        ),
      ),
    );
  }
}