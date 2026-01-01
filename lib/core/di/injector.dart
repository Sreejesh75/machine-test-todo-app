import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/domain/usecases/add_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/delete_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/get_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/update_task_usecases.dart';
import 'package:quantum_todo_app/core/services/notification_service.dart';

import '../../data/repository/task_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Hive Box
  final taskBox = Hive.box<TaskModel>('tasksBox');

  // Services
  sl.registerLazySingleton(() => NotificationService());

  // Repository
  sl.registerLazySingleton(() => TaskRepository(taskBox));

  // UseCases
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
}
