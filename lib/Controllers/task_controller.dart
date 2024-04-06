import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Models/task_model.dart';
import 'package:dio/dio.dart';

class TaskController extends GetxController{

  var getDataModelTask = GetModelTasks(tasks: []).obs;

  var details = ''.obs; 

  var isLoading = false.obs;

  final dio = Dio();

  Options auth = Options(
    headers: {
      'Authorization' : 'Bearer e864a0c9eda63181d7d65bc73e61e3dc6b74ef9b82f7049f1fc7d9fc8f29706025bd271d1ee1822b15d654a84e1a0997b973a46f923cc9977b3fcbb064179ecd',
    }
  );

  Options headerAuth = Options(
    headers: {
      'Authorization' : 'Bearer e864a0c9eda63181d7d65bc73e61e3dc6b74ef9b82f7049f1fc7d9fc8f29706025bd271d1ee1822b15d654a84e1a0997b973a46f923cc9977b3fcbb064179ecd',
    },
    contentType: 'application/x-www-form-urlencoded'
  );


  rutaURL(String ruta) => 
    'https://ecsdevapi.nextline.mx/vdev/tasks-challenge/tasks$ruta';

  snackBarCharging({
    required String message,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  snackBarSucces({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      )
    );
  }

  snackBarError({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  // metodo para obtener la lista de Tareas
  Future<void> getTasks({required String token}) async {
    try {
      // activamos el isLoading
      isLoading.value = true;

      // hacemos la peticion a la api
      var response = await dio.get(
        // url de la Api
        rutaURL(''),

        // enviamos los datos de los parametros
        data: {
          'token' : token
        },

        // enviamos los headers
        options: auth

      );

      final jsonEncode = await compute(json.encode, response.data);

      String jsonString = '{"Tasks":$jsonEncode}';

      getDataModelTask.value = await compute(getModelTasksFromJson, jsonString);


    }catch(e){
      print(e);
    }
    finally{
      isLoading.value = false;
    }
  }

  // metodo para obtener la lista de Tareas
  Future<Task> getTask({
    required Task task,
  }) async {
    Task nTask = Task(title: '', isCompleted: 0);
    try {
      // activamos el isLoading
      isLoading.value = true;

      // hacemos la peticion a la api
      var response = await dio.get(
        // url de la Api
        rutaURL('/${task.taskId}'),

        // enviamos los datos de los parametros
        data: {
          'token' : task.token
        },

        // enviamos los headers
        options: auth

      );
      final jsonEncode = await compute(json.encode, response.data);

      String jsonString = '{"Tasks":$jsonEncode}';

      GetModelTasks getTask = await compute(getModelTasksFromJson, jsonString);
      
      // asignamos la tarea a la variable nTask
      nTask = getTask.tasks[0];

    }catch(e){
      print(e);
    }
    finally{
      isLoading.value = false;
    }
    return nTask;
  }

  // metodo para agregar una tarea
  Future<void> addTask({
    required Task task,
    required BuildContext context,
  }) async {
    try {
      // activamos el isLoading
      snackBarCharging(message: 'Agregando Tarea...', context: context);

      // hacemos la peticion a la api
      var response = await dio.post(
        // url de la Api
        rutaURL(''),
        // enviamos los headers
        options: headerAuth,
        // enviamos los datos
        data: {
          'token' : task.token,
          'title' : task.title,
          'is_completed' : task.isCompleted,
          'due_date' : task.dueDate,
          'comments' : task.comments,
          'description': task.description,
          'tags' : task.tags,
        },
      );

      // convertimos la respuesta a un json
      final jsonEncode = json.encode(response.data);

      // convertimos el json a un string
      final jsonString = json.decode(jsonEncode);
      
      // asignamos el mensaje de la respuesta a la variable details
      details.value = jsonString['detail'].toString();

      if(!context.mounted) return;

    }catch(e){
      snackBarError(message: e.toString(), context: context);
    }
    finally{
      snackBarSucces(message: details.value, context: context);
    }
  }

  // metodo para actualizar una tarea
  Future<void> updateTask({
    required Task task,
    required BuildContext context,
  }) async {
    try {
      
      // Lanzamos un mensaje de carga
      snackBarCharging(message: 'Actualizando Tarea...', context: context);

      // hacemos la peticion a la api
      var response = await dio.put(
        // url de la Api
        rutaURL('/${task.taskId}'),
        // enviamos los headers
        options: headerAuth,
        // enviamos los datos de los parametros
        data: {
          'token' : task.token,
          'title' : task.title,
          'is_completed' : task.isCompleted,
          'due_date' : task.dueDate,
          'comments' : task.comments,
          'description': task.description,
          'tags' : task.tags,
        },
      );
      
      // convertimos la respuesta a un json
      final jsonEncode = json.encode(response.data);

      // convertimos el json a un string
      final jsonString = json.decode(jsonEncode);
      
      // asignamos el mensaje de la respuesta a la variable details
      details.value = jsonString['detail'].toString();

      // si el contexto no esta montado no hacemos nada
      // para evitar errores cuando se trabaja dentro de async
      if(!context.mounted) return;

    }catch(e){
      // Lanzamos un mensaje de error
      snackBarError(message: e.toString(), context: context);
    }
    finally{
      // Lanzamos un mensaje de exito
      snackBarSucces(message: details.value, context: context);
    }
  }

  Future<void> deleteTask({
    required Task task,
    required BuildContext context,
  }) async {
    try {
      // Lanzamos un mensaje de carga
      snackBarCharging(message: 'Eliminando Tarea...', context: context);
      

      // hacemos la peticion a la api
      var response = await dio.delete(
        // url de la Api
        rutaURL('/${task.taskId}'),
        options: auth,
        data: {
          'token' : task.token,
        },
      );

      print(response.data);

      // convertimos la respuesta a un json
      final jsonEncode = json.encode(response.data);

      // convertimos el json a un string
      final jsonString = json.decode(jsonEncode);
      
      // asignamos el mensaje de la respuesta a la variable details
      details.value = jsonString['detail'].toString();

      if(!context.mounted) return;
    }catch(e){
      // Lanzamos un mensaje de error
      snackBarError(message: e.toString(), context: context);
    }
    finally{
      // Lanzamos un mensaje de exito
      snackBarSucces(message: details.value, context: context);
    }
  }

}