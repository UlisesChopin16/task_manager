import 'dart:convert';

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


  Future<void> getTasks({required String token}) async {
    try {
      // activamos el isLoading
      isLoading.value = true;

      // hacemos la peticion a la api
      var response = await dio.get(
        // nombre de la api
        rutaURL(''),
        data: {
          'token' : token
        },
        options: auth

      );

      String jsonString = '{"Tasks":${json.encode(response.data)}}';

      getDataModelTask.value = getModelTasksFromJson(jsonString);


    }catch(e){
      print(e);
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> addTask({
    required Task task,
  }) async {
    try {
      // activamos el isLoading
      isLoading.value = true;

      // hacemos la peticion a la api
      var response = await dio.post(
        // nombre de la api
        rutaURL(''),
        options: headerAuth,
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


      final jsonEncode = json.encode(response.data);

      final jsonString = json.decode(jsonEncode);
      
      details.value = jsonString['detail'].toString();

    }catch(e){
      print(e);
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> updateTask({
    required Task task,
  }) async {
    try {
      // activamos el isLoading
      isLoading.value = true;

      // hacemos la peticion a la api
      var response = await dio.put(
        // nombre de la api
        rutaURL('/${task.taskId}'),
        options: headerAuth,
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

      print(response.data);

      final jsonEncode = json.encode(response.data);

      final jsonString = json.decode(jsonEncode);
      
      details.value = jsonString['detail'].toString();

    }catch(e){
      print(e);
    }
    finally{
      isLoading.value = false;
    }
  }

}