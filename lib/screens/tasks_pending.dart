import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/models/card.dart';
import 'package:avaliacao1/providers/task_provider.dart';
import 'package:avaliacao1/views/create_new_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksPending extends StatefulWidget {
  final List<Task> pendingTasks;

  const TasksPending({required this.pendingTasks, super.key});

  @override
  State<TasksPending> createState() => _TasksPendingState();
}

class _TasksPendingState extends State<TasksPending> {

  void addTask(Task task) {
    setState(() {
      widget.pendingTasks.add(task);
    });
  }

  Future<void> _editTask(int index) async {
    final editedTask = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewTask(existingTask: widget.pendingTasks[index]),
        ));

    if (editedTask != null) {
      setState(() {
        widget.pendingTasks[index] = editedTask;
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
              onPressed: () {
                setState(() {
                  widget.pendingTasks.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Excluir'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white
                ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  foregroundColor: Colors.white
                ),
            ),
          ],
        );
      }
      );
    }

    String _dateFormat(String date) {
    initializeDateFormatting('pt_BR');
    var formatter = DateFormat('d/MM/y');
    DateTime convertedDate = DateTime.parse(date);

    return formatter.format(convertedDate);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final pendingTasks = taskProvider.tasksPending;

    return pendingTasks.isEmpty
      ? const SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/pendingtasks_image.png'),
              width: 300,
              height: 300,
            ),
            Text(
              'Você não tem tarefas pendentes no momento...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              'Continue assim!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
    )
    : Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final pendingTasks = taskProvider.tasksPending;

          return ListView.builder(
              itemCount: pendingTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  index: index, 
                  task: pendingTasks[index], 
                  onDelete: () {
                    taskProvider.removePendingTask(index);
                  },
                  cardColor: const Color.fromARGB(255, 252, 108, 108),
                );
              },
            );
        },
      );
  }
}