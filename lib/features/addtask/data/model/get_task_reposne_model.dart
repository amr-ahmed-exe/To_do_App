class GetTasksResponseModel {
  bool? status;
  List<TaskModel>? tasks;

  GetTasksResponseModel({this.status, this.tasks});

  GetTasksResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['tasks'] != null) {
      tasks = <TaskModel>[];
      json['tasks'].forEach((v) {
        tasks!.add(TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (tasks != null) {
      data['tasks'] = tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskModel {
  String? createdAt;
  String? description;
  int? id;
  String? imagePath;
  String? title;

  TaskModel({
    this.createdAt,
    this.description,
    this.id,
    this.imagePath,
    this.title,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    description = json['description'];
    id = json['id'];
    imagePath = json['image_path'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['description'] = description;
    data['id'] = id;
    data['image_path'] = imagePath;
    data['title'] = title;
    return data;
  }
}
