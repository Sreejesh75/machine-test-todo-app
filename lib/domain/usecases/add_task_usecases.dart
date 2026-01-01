
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/data/repository/task_repository.dart';



class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(TaskModel task) {
    return repository.addTask(task);
  }
}
