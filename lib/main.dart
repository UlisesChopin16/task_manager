import 'package:flutter/material.dart';
import 'package:task_manager/Views/add_task_view.dart';
import 'package:task_manager/Views/principal_view.dart';
import 'package:task_manager/Views/tasks_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      // home: const PrincipalView(),
      // home: const TasksView(),
      home: const AddTaskView(isAdd: true),
    );
  }
}

