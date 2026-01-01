import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_bloc.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_event.dart';
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int priority = 1;
  DateTime? dueDate;
  TimeOfDay? dueTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E4DA0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Create Task", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0E4DA0),
              Color(0xFF1B75CF),
            ],
          ),
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE TEXTFIELD
                  const Text("Task Title",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: _inputDecoration("Enter task title"),
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  const Text("Description",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration("Describe your task"),
                  ),

                  const SizedBox(height: 16),

                  // PRIORITY
                  const Text("Priority",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: priority,
                    decoration: _inputDecoration("Select priority"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Low")),
                      DropdownMenuItem(value: 2, child: Text("Medium")),
                      DropdownMenuItem(value: 3, child: Text("High")),
                    ],
                    onChanged: (v) => setState(() => priority = v!),
                  ),

                  const SizedBox(height: 16),

                  // DATE PICKER
                  const Text("Due Date",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: pickDate,
                    child: _pickerTile(
                      icon: Icons.calendar_month,
                      text: dueDate == null
                          ? "Pick due date"
                          : DateFormat("dd MMM yyyy").format(dueDate!),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TIME PICKER
                  const Text("Time",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: pickTime,
                    child: _pickerTile(
                      icon: Icons.access_time,
                      text: dueTime == null
                          ? "Pick time"
                          : dueTime!.format(context),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F89E3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Create Task",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------- WIDGET HELPERS ----------------------------

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F7FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _pickerTile({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ---------------------------- DATE & TIME PICKERS ----------------------------

  pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => dueTime = picked);
    }
  }

  // ---------------------------- SAVE TASK ----------------------------

  Future<void> saveTask() async {
    if (titleController.text.isEmpty || dueDate == null || dueTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final finalDue = DateTime(
      dueDate!.year,
      dueDate!.month,
      dueDate!.day,
      dueTime!.hour,
      dueTime!.minute,
    );

    final task = TaskModel(
      id: const Uuid().v4(),
      title: titleController.text,
      description: descriptionController.text,
      priority: priority,
      dueDate: finalDue,
      createdAt: DateTime.now(),
      reminderTime: null,
    );
    
  //   // 🔔 CALL NOTIFICATION HERE  
  // await NotificationService.scheduleNotification(
  //   id: DateTime.now().millisecondsSinceEpoch % 100000,
  //   title: task.title,
  //   body: task.description.isEmpty
  //       ? "Task is due soon!"
  //       : task.description,
  //   date: finalDue,
  // );


    context.read<TaskBloc>().add(AddTaskEvent(task));

    Navigator.pop(context);
  }
}
