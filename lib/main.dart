import '../widgets/notifications.dart';
import '../models/Task.dart';
import '../screens/tasksCompleted.dart';
import '../screens/main_page.dart';
import '../screens/tasks_pending.dart';
import '../views/create_new_task.dart';
import '../views/task.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
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
    debugShowCheckedModeBanner: false,
    title: 'Minhas Anotações',
    home: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Task> tasksList = [];
  List<Task> tasksPending = [];
  List<Task> completedTasks = [];
  String selectedType = 'Todos';
  final notificationService = AppNotificationService();

  Future<void> _addTaskScreen() async {
    final newTask = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const CreateNewTask())
    );

    if (newTask != null) {
      setState(() {
        final taskDueDate = DateTime(
          newTask.dueDate.year,
          newTask.dueDate.month,
          newTask.dueDate.day
        );

        if(taskDueDate.isBefore(DateTime.now())) {
          tasksPending.add(newTask);
        
          notificationService.showNotification(
            'A TAREFA EXPIROU', 
            'O prazo da tarefa "${newTask.title}" expirou!'
          );

        } else {
          tasksList.add(newTask);
        }
      });
    }
  }

  void _markCompletedTask(Task task) {
    setState(() {
      tasksList.remove(task);
      completedTasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 233, 233, 233),
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: Text('Minhas Atividades')
                ),
                
                DropdownButton<String>(
                  value: selectedType,
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  dropdownColor: Colors.lightBlue,
                  items: ['Todos', 'Pessoal', 'Trabalho', 'Estudo', 'Outro']
                      .map((String type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                  onChanged: (String? newType) {
                    setState(() {
                        selectedType = newType!;
                      }
                    );
                  },
                ),
              ], 
            ),
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromARGB(255, 0, 95, 184),
              tabs: [
                Tab(text: 'Início'),
                Tab(text: 'Pendentes'),
                Tab(text: 'Concluídas'),
            ]),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              MainPage(
                tasksList: tasksList, 
                filterType: selectedType,
                addTaskToPending: (Task task) {
                  setState(() {
                    tasksPending.add(task);
                  });
                },
                markCompletedTask: _markCompletedTask,
              ),
              TasksPending(pendingTasks: tasksPending),
              TasksCompleted(completedTasks: completedTasks),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            onPressed: _addTaskScreen,
            child: const Icon(Icons.add),
          )
      ),
    );
  }
}
