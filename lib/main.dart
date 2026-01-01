import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quantum_todo_app/core/di/injector.dart';
import 'package:quantum_todo_app/core/services/notification_service.dart';
import 'package:quantum_todo_app/data/models/task_model.dart';
import 'package:quantum_todo_app/firebase_notification_handler.dart';
import 'package:quantum_todo_app/firebase_options.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_bloc.dart';
import 'package:quantum_todo_app/presntation/bloc/task/task_event.dart';
import 'package:quantum_todo_app/presntation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //  Setup Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasksBox');
  await Hive.openBox<TaskModel>('completedBox');

 
  await initDependencies();

 
  await sl<NotificationService>().initialize();


  await FirebaseMessaging.instance.requestPermission();


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

 
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM TOKEN = $fcmToken");


  runApp(
    BlocProvider(
      create: (_) {
        final bloc = TaskBloc(
          getTasks: sl(),
          addTask: sl(),
          updateTask: sl(),
          deleteTask: sl(),
        );
        bloc.add(LoadTasksEvent());
        return bloc;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
