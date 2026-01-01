import 'package:quantum_todo_app/data/repository/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
