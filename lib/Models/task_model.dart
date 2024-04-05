import 'dart:convert';

GetModelTasks getModelTasksFromJson(String str) => GetModelTasks.fromJson(json.decode(str));

String getModelTasksToJson(GetModelTasks data) => json.encode(data.toJson());

class GetModelTasks {
    List<Task> tasks;

    GetModelTasks({
        required this.tasks,
    });

    factory GetModelTasks.fromJson(Map<String, dynamic> json) => GetModelTasks(
        tasks: List<Task>.from(json["Tasks"].map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
    };
}

class Task {
    int? taskId;
    String? token;
    String title;
    int isCompleted;
    String? dueDate;
    String? comments;
    String? description;
    String? tags;

    Task({
        this.taskId,
        this.token,
        required this.title,
        required this.isCompleted,
        this.dueDate = '',
        this.comments = '',
        this.description = '',
        this.tags = '',
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json["id"],
        token: json["token"],
        title: json["title"],
        isCompleted: json["is_completed"],
        dueDate: json["due_date"],
        comments: json["comments"],
        description: json["description"],
        tags: json["tags"],
    );

    Map<String, dynamic> toJson() => {
        "id": taskId,
        "token": token,
        "title": title,
        "is_completed": isCompleted,
        "due_date": dueDate,
        "comments": comments,
        "description": description,
        "tags": tags,
    };
}
