
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/data/repository/task_repository.dart';


class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  List<TaskModel> call() {
    return repository.getTasks();
  }
}
