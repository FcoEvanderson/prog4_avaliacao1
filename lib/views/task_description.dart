import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskDescription extends StatelessWidget {
  final Task task;
  const TaskDescription({ required this.task, super.key});

  String _dateFormat(String date) {
    initializeDateFormatting('pt_BR');
    var formatter = DateFormat('d/MM/y');
    DateTime convertedDate = DateTime.parse(date);
    return formatter.format(convertedDate);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final isCompleted = taskProvider.tasksCompleted.contains(task);
    final isPending = taskProvider.tasksPending.contains(task);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tipo: ${task.type}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  'Prazo: ${_dateFormat(task.dueDate.toString())}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ] 
            ),
            const Divider(),
            const Text(
              'Descrição:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(task.description)
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isCompleted ? null
      : FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          if (isPending) {
            taskProvider.tasksPending.remove(task);
          }
          taskProvider.moveTaskToCompleted(task);
          Navigator.pop(context);
        },
        backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}