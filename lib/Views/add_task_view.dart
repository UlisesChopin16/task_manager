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
  State<AddTaskView> createState() => _AddTaskViewState();
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
    
      
    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      if(!widget.isAdd){
        buttonText = 'Actualizar Task';
        titleBar = 'Detalles del Task';
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
        datePicker();
        focusNodeDate.unfocus();
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

  // Metodo para desplegar un DatePicker
  datePicker(){
    showDatePicker(
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

  void onPressed(){
    final FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus && focus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if(_formKey.currentState!.validate()){
      if(widget.isAdd){
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

      }else{

        

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

      }
      getDataController.listChange.value = true;
      setState(() {});
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
      appBar: AppBar(
        title: Text(titleBar),
        actions: [
          if(!widget.isAdd)
            IconButton(
              onPressed: () async {
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

                Navigator.pop(context);
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
    return Flexible(
      child: InputComponent(
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
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
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