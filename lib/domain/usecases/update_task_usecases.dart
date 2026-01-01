
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/data/repository/task_repository.dart';



class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskModel task) {
    return repository.updateTask(task);
  }
}
