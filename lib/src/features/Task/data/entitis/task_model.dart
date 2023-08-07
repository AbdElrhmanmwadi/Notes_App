import 'package:intl/intl.dart';
import 'package:note/src/features/Task/domain/entites/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int id,
    required String task,
    required int isComplete,
  }) : super(id: id, task: task, isComplete: isComplete);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'isComplete': isComplete,
    };
  }

  factory TaskModel.fromJson(Map<dynamic, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      task: json['task'] as String,
      isComplete: json['isComplete'] as int,
    );
  }
}


// class TaskModel {
//   final int id;
//   final String task;
//   final String date;
//   final int isComplete;

//   TaskModel({
//     required this.id,
//     required this.task,
//     required this.date,
//     required this.isComplete,
//   });

 
 

//   @override
//   String toString() {
//     return 'TaskModel(id: $id, task: $task, date: $date, isComplete: $isComplete)';
//   }
// }

