import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Components/input_component.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Models/task_model.dart';

class AddTaskView extends StatefulWidget {

  /// if its true we shows the interface to add new task
  final bool isAdd;

  /// we obtain the color of the task
  final Color color;

  /// we obtain the task
  final Task? task;

  const AddTaskView({ 
    required this.isAdd,
    required this.color,
    this.task,
    Key? key 
  }) : super(key: key);

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

// we create a enum for to do the actions
enum TaskAction {add, update, delete}

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
  String titleBar = 'Crea un nuevo Task';

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
    
    // we add a postFrameCallback to get the task 
    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      
      // if its not to add a task we get the task
      if(!widget.isAdd){
        buttonText = 'Actualizar Task';
        titleBar = 'Detalles del Task';

        // we obtain the task
        task = await getDataController.getTask(
          task: widget.task!,
        );

        // we show the details of task in the interface
        titleController.text = task.title;
        descriptionController.text = task.description ?? '';
        commentsController.text = task.comments ?? '';
        dateController.text = task.dueDate ?? '';
        tagsController.text = task.tags ?? ''; 

        // we assign the values to the variables to compare the changes
        titleCompare = task.title;
        descriptionCompare = task.description ?? '';
        commentsCompare = task.comments ?? '';
        dateCompare = task.dueDate ?? '';
        tagsCompare = task.tags ?? '';
        completedCompare = task.isCompleted;

        // we assign the values to the variables to show in the interface
        title = task.title;
        description = task.description ?? '';
        comments = task.comments ?? '';
        date = task.dueDate ?? '';
        tags = task.tags ?? '';
        completed = task.isCompleted;


        setState(() {});
      }

    });

    focusNodeDate.addListener(() {
      if(focusNodeDate.hasFocus){
        // we show the datePicker
        datePicker();
        // we remove the focus
        focusNodeDate.unfocus();
      }
    });
  }

  // methods of obtain the value of the fields
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

  // we validate the fields
  String? validatorTitle(String? value){
    if(value!.trim().isEmpty){
      return 'Este campo es obligatorio';
    }
    return null;
  }

  // method to show datePicker
  datePicker(){
    showDatePicker(
      barrierColor: widget.color,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030)
    ).then((value){
      if(value != null){
        date = value.toString().split(' ')[0];
        dateController.text = date;
        focusNodeDate.unfocus();
      }
    });
  }

  // method of the button to add or update the task
  void onPressed()async {
    final FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus && focus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if(_formKey.currentState!.validate()){
      if(widget.isAdd){
        
        await confirmDialog(TaskAction.add);

      }else{

        await confirmDialog(TaskAction.update);

      }
      getDataController.listChange.value = true;
      setState(() {});
    }

  }

  // method to show the dialog of confirm
   confirmDialog(TaskAction action) async {
    String titleDialog = '';
    String textButtonDialog = '';
    VoidCallback onPressedDialog = (){};
    switch (action) {
      case TaskAction.add:
        titleDialog = '¿Estás seguro de agregar la tarea?';
        textButtonDialog = 'Agregar';
        onPressedDialog = addTask;
        break;
      case TaskAction.update:
        titleDialog = '¿Estás seguro de actualizar la tarea?';
        textButtonDialog = 'Actualizar';
        onPressedDialog = updateTask;
        break;
      case TaskAction.delete:
        titleDialog = '¿Estás seguro de eliminar la tarea?';
        textButtonDialog = 'Eliminar';
        onPressedDialog = deleteTask;
        break;
    }

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          titleTextStyle:  TextStyle(
            color: widget.color,
            fontSize: 20, 
          ),
          title: Text(titleDialog),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context,);
              }, 
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: widget.color
                ),
              )
            ),
            TextButton(
              onPressed: onPressedDialog, 
              child: Text(
                textButtonDialog,
                style: TextStyle(
                  color: widget.color
                ),
              )
            )
          ],
        );
      }
    );
  } 

  addTask()async{
    if(date.isEmpty){
      date = DateTime.now().toString().split(' ')[0];
    }
    getDataController.addTask(
      task: Task(
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

    titleController.clear();
    descriptionController.clear();
    commentsController.clear();
    dateController.clear();
    tagsController.clear();
    completed = 0;
    isEditing = false;

    setState(() {});

    Navigator.of(context).pop();
  }

  updateTask(){
    isEditing = false;
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

    titleCompare = title;
    descriptionCompare = description;
    commentsCompare = comments;
    dateCompare = date;
    tagsCompare = tags;
    completedCompare = completed;

    setState(() {});

    Navigator.of(context).pop();
  }

  deleteTask() async {
    getDataController.isLoading.value = true;
    await getDataController.deleteTask(
      task: task,
      context: context
    );
    getDataController.isLoading.value = false;
    getDataController.listChange.value = true;

    titleController.clear();
    descriptionController.clear();
    commentsController.clear();
    dateController.clear();
    tagsController.clear();
    completed = 0;

    if(!context.mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  // method to get the size of the screen
  void _getScreenSize(){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    _getScreenSize();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(titleBar),
        centerTitle: true,
        actions: [
          if(!widget.isAdd)
            IconButton(
              onPressed: () async {
                await confirmDialog(TaskAction.delete);
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
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
      color:  widget.color.withOpacity(0.03),
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
        color: widget.color.withOpacity(0.9),
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
        color: widget.color.withOpacity(0.7),
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
        color: widget.color.withOpacity(0.5),
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
                  formDate(),
                  const SizedBox(width: 10,),
                  checkCompleted(),
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
      isRequired: true,
      color: widget.color,
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
      color: widget.color,
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
      color: widget.color,
      controller: commentsController,
      focusNode: focusNodeComments,
      onChanged: onChangedComments,
      label: 'Comentarios',
      hintText: '(Opcional)',
      maxLines: 4,
    );
  }

  Widget formDate(){
    return Flexible(
      child: InputComponent(
        color: widget.color,
        controller: dateController,
        focusNode: focusNodeDate,
        onChanged: onChangedDate,
        label: 'Fecha',
        hintText: '(Opcional)',
      ),
    );
  }

  Widget checkCompleted(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: (){
            setState(() {
              completed = completed == 1 ? 0 : 1;
              if(completed != completedCompare){
                isEditing = true;
              }else{
                isEditing = false;
              }
            });
          },
          child: Text(
            '¿Completada?', 
            style: TextStyle(
              fontSize: 20,
              color: widget.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Checkbox(
          value: completed == 1,
          activeColor: widget.color,
          side: const BorderSide(
            width: 2
          ),
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
    );
  }

  Widget formTags(){
    return InputComponent(
      color: widget.color,
      controller: tagsController,
      focusNode: focusNodeTags ,
      onChanged: onChangedTags,
      label: 'Tags',
      hintText: '(Opcional)',
    );
  }

  Widget formButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      onPressed: isEditing || widget.isAdd ? onPressed : null,
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