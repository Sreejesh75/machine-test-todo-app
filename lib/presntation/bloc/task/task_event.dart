

import 'package:quantum_todo_app/data/models/task_model.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  DeleteTaskEvent(this.id);
}

class SearchTaskEvent extends TaskEvent {
  final String query;
  SearchTaskEvent(this.query);
}

class SortTaskEvent extends TaskEvent {
  final int sortType; 
  SortTaskEvent(this.sortType);
}

class CompleteTaskEvent extends TaskEvent {
  final TaskModel task;
  CompleteTaskEvent(this.task);
}
