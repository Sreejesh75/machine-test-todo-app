import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_todo_app/core/theme/app_colour.dart';
import 'package:quantum_todo_app/core/theme/app_text_styles.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_bloc.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_event.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_state.dart';
import 'package:quantum_todo_app/presntation/screens/add_task_screen.dart';
import 'package:quantum_todo_app/presntation/screens/edit_task_screen.dart';
import 'package:quantum_todo_app/presntation/widgets/search_bar.dart';
import 'package:quantum_todo_app/presntation/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  int sortType = 2;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint("========================================");
      debugPrint("FCM Token: $token");
      debugPrint("========================================");
    });

    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Body";

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🔔 $title — $body")));
    });

    
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("🔔 App opened from notification");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.appGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("My Tasks", style: AppTextStyles.appbarstyle),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5EDFFF),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: const AddTaskScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.appGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() => searchQuery = value);
                  context.read<TaskBloc>().add(SearchTaskEvent(searchQuery));
                },
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.white),
                    child: DropdownButton<int>(
                      value: sortType,
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("Priority")),
                        DropdownMenuItem(value: 1, child: Text("Due Date")),
                        DropdownMenuItem(value: 2, child: Text("Created Date")),
                      ],
                      onChanged: (value) {
                        setState(() => sortType = value!);
                        context.read<TaskBloc>().add(SortTaskEvent(value!));
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TaskLoaded) {
                      if (state.tasks.isEmpty) {
                        return const Center(
                          child: Text(
                            "No tasks found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];

                          return TaskCard(
                            task: task,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<TaskBloc>(),
                                    child: EditTaskScreen(task: task),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
