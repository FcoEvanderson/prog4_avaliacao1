import 'dart:async';
import 'package:avaliacao1/providers/task_provider.dart';
import 'package:avaliacao1/views/task.dart';
import 'package:provider/provider.dart';

import '../views/create_new_task.dart';
import '../widgets/notifications.dart';
import '../models/Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  final List<Task> tasksList;
  final String filterType;
  final Function(Task) addTaskToPending;
  final Function(Task task) markCompletedTask;

  const MainPage({
    required this.tasksList, 
    required this.filterType,
    required this.addTaskToPending,
    required this.markCompletedTask,
    super.key
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late AppNotificationService notificationService;
  Timer? expirationChecker;

  @override
  void initState() {
    super.initState(); 
    notificationService = AppNotificationService();
    _startExpirationChecker();
  }

  @override
  void dispose() {
    expirationChecker?.cancel();
    super.dispose();
  }

  void _checkExpirationChecker() {
    final currentDate = DateTime.now();
    final todayStart = DateTime(currentDate.year, currentDate.month, currentDate.day);

    setState(() {
      widget.tasksList.removeWhere((task) {
        final taskDueDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
        final isExpired = taskDueDate.isBefore(todayStart);

        if (isExpired) {
          widget.addTaskToPending(task);
          notificationService.showNotification(
            'A TAREFA EXPIROU!',
            'O prazo da tarefa "${task.title}" expirou!',
          );
        } else if (taskDueDate.isAtSameMomentAs(todayStart)) {
          notificationService.showNotification(
            'O PRAZO EXPIRA HOJE!', 
            'Atenção! O prazo da tarefa "${task.title}" expira hoje!'
          );
        }
        return isExpired;
      });
    });
  }

  void _startExpirationChecker() {
    expirationChecker = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkExpirationChecker();
    });
  }

  List<Task> get _filteredTasks {
    List<Task> tasks = widget.filterType == 'Todos'
        ? widget.tasksList
        : widget.tasksList.where(
            (task) => task.type == widget.filterType
          ).toList();
      
    tasks.sort(
      (a, b) => a.dueDate.compareTo(b.dueDate)
    );

    return tasks;
  }

  String _dateFormat(String date) {
    initializeDateFormatting('pt_BR');
    var formatter = DateFormat('d/MM/y');
    DateTime convertedDate = DateTime.parse(date);
    return formatter.format(convertedDate);
  }

  Future<void> _editTask(int index) async {
    final editedTask = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewTask(existingTask: widget.tasksList[index]),
        ));

    if (editedTask != null) {
      setState(() {
        widget.tasksList[index] = editedTask;
      });
    }
  }

  _deleteTask(int index) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Tem certeza que deseja excluir?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black
                ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.tasksList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Excluir'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white
                ),
            ),
          ],
        );
      }
      );
  }

  @override
  Widget build(BuildContext context) {

    final taskProvider = Provider.of<TaskProvider>(context);
    final tasklist = taskProvider.tasksList;

    return tasklist.isEmpty
        ? const SingleChildScrollView(
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/search_tasks.png')),
                Text(
                  'Hmm, parece que você não possui tarefas no momento...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Vamos adicionar algumas? Clique no botão "+"',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            )),
        )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: tasklist.length,
                  itemBuilder: (context, index) {
                    final task = tasklist[index];

                    String shortDescription = task.description.length > 50 
                      ? '${task.description.substring(0, 44)}...'
                      : task.description;

                    return Card(
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shortDescription
                              ),
                              Text(
                                'Prazo: ${_dateFormat(task.dueDate.toString())}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                            onTap: () async {
                              final result = await Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => TaskDescription(task: task),
                                )
                              );

                              if (result != null) {
                                widget.markCompletedTask(result);
                              }
                            },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _editTask(index),
                              child: const Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 49, 204, 54),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _deleteTask(index),
                              child: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 199, 17, 4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
