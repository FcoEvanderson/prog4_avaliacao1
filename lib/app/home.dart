import '../models/Task.dart';
import '../screens/tasksCompleted.dart';
import '../screens/tasks_pending.dart';
import '../widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../views/create_new_task.dart';
import '../screens/main_page.dart';

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

  // Future<void> _addTaskScreen() async {
  //   final newTask = await Navigator.push(
  //     context, 
  //     MaterialPageRoute(builder: (context) => const CreateNewTask())
  //   );

  //   if (newTask != null) {
  //     setState(() {
  //       final taskDueDate = DateTime(
  //         newTask.dueDate.year,
  //         newTask.dueDate.month,
  //         newTask.dueDate.day
  //       );

  //       if(taskDueDate.isBefore(DateTime.now())) {
  //         tasksPending.add(newTask);
        
  //         notificationService.showNotification(
  //           'A TAREFA EXPIROU', 
  //           'O prazo da tarefa "${newTask.title}" expirou!'
  //         );

  //       } else {
  //         tasksList.add(newTask);
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

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
                    taskProvider.setSelectedType(newType!);
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
                tasksList: taskProvider.tasksList, 
                filterType: taskProvider.selectedType,
                addTaskToPending: (Task task) {
                  taskProvider.markAsPending(task);
                },
                markCompletedTask: (task) {
                  setState(() {
                    tasksList.remove(task);
                    completedTasks.add(task);
                  });
                },
              ),
              TasksPending(pendingTasks: taskProvider.tasksPending),
              TasksCompleted(completedTasks: taskProvider.tasksCompleted),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            onPressed: () async {
              final newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateNewTask())
              );

              if(newTask != null){
                taskProvider.addTask(newTask);
              }
            },
            child: const Icon(Icons.add),
          )
      ),
    );
  }
}