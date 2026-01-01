import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int priority;

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? reminderTime;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    this.reminderTime,
  });
}
