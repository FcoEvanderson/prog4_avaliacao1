import 'package:avaliacao1/firebase_options.dart';
import 'package:avaliacao1/widgets/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import '../app/home.dart';
import '../providers/task_provider.dart';
import 'views/task_description.dart';
import 'package:provider/provider.dart';
import '../models/Task.dart';
import '../views/create_new_task.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        final taskProvider = TaskProvider(AppNotificationService());
        return taskProvider;
      }),
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
