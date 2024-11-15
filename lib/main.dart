import 'package:avaliacao1/widgets/notifications.dart';

import '../app/home.dart';
import '../providers/task_provider.dart';
import '../views/task.dart';
import 'package:provider/provider.dart';
import '../models/Task.dart';
import '../views/create_new_task.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => TaskProvider(AppNotificationService())
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
      if (settings.name == '/taskDescription') {
        final task = settings.arguments as Task;
        return MaterialPageRoute(
          builder: (context) => TaskDescription(task: task),
        );
      }
      return null;
    },
      routes: {
        '/createNewTask': (context) => const CreateNewTask(),
      },
      title: 'Minhas Anotações',
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}