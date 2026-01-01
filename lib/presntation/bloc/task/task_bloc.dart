import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:quantum_todo_app/core/di/injector.dart';
import 'package:quantum_todo_app/core/services/notification_service.dart';
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/domain/usecases/add_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/delete_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/get_task_usecases.dart';
import 'package:quantum_todo_app/domain/usecases/update_task_usecases.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasks;
  final AddTaskUseCase addTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final NotificationService _notificationService = sl<NotificationService>();

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) {
      emit(TaskLoading());
      final tasks = getTasks();
      emit(TaskLoaded(tasks));
    });

    on<AddTaskEvent>((event, emit) async {
      await addTask(event.task);

      // Schedule notification for the new task
      await _scheduleTaskNotification(event.task);

      final tasks = getTasks();
      emit(TaskLoaded(tasks));
    });

    on<UpdateTaskEvent>((event, emit) async {
      await updateTask(event.task);

      // Reschedule notification for the updated task
      await _scheduleTaskNotification(event.task);

      final tasks = getTasks();
      emit(TaskLoaded(tasks));
    });

    on<DeleteTaskEvent>((event, emit) async {
      // Cancel notification before deleting
      await _notificationService.cancelNotification(event.id);

      await deleteTask(event.id);
      final tasks = getTasks();
      emit(TaskLoaded(tasks));
    });

    on<CompleteTaskEvent>((event, emit) async {
      // Open boxes
      final pendingBox = Hive.box<TaskModel>('tasksBox');
      final completedBox = Hive.box<TaskModel>('completedBox');

      // Remove from pending
      await pendingBox.delete(event.task.id);

      // Add to completed
      await completedBox.put(event.task.id, event.task);

      // Reload only pending tasks
      final tasks = getTasks();
      emit(TaskLoaded(tasks));
    });

    on<SearchTaskEvent>((event, emit) {
      final tasks = getTasks()
          .where(
            (task) =>
                task.title.toLowerCase().contains(event.query.toLowerCase()) ||
                task.description.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
          )
          .toList();
      emit(TaskLoaded(tasks));
    });

    on<SortTaskEvent>((event, emit) {
      final tasks = getTasks();

      if (event.sortType == 0) {
        tasks.sort((a, b) => b.priority.compareTo(a.priority));
      } else if (event.sortType == 1) {
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      } else {
        tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      emit(TaskLoaded(tasks));
    });
  }

  /// Helper method to schedule notifications for a task
  Future<void> _scheduleTaskNotification(TaskModel task) async {
    // Schedule notification at due date
    await _notificationService.scheduleTaskNotification(
      id: task.id,
      title: task.title,
      description: task.description,
      scheduledDate: task.dueDate,
    );

    // Schedule reminder 1 hour before due date
    await _notificationService.scheduleTaskReminder(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      reminderBefore: const Duration(minutes: 30),
    );
  }
}
