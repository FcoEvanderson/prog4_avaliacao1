import 'package:avaliacao1/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final int index;
  final Task task;
  final List<Task> tasksList;
  final Color? cardColor;
  final Widget? trailing;

  const TaskCard(
      {super.key,
      required this.index,
      required this.task,
      required this.tasksList,
      this.cardColor,
      this.trailing,
    });

  _deleteTask(int index, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tem certeza que deseja excluir?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  tasksList.removeAt(index);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Excluir'),
              ),
            ],
          );
        });
  }

  String _dateFormat(String date) {
    initializeDateFormatting('pt_BR');
    var formatter = DateFormat('d/MM/y');
    DateTime convertedDate = DateTime.parse(date);
    return formatter.format(convertedDate);
  }

  @override
  Widget build(BuildContext context) {
    String shortDescription = task.description.length > 50
        ? '${task.description.substring(0, 44)}...'
        : task.description;

    return Card(
      color: cardColor,
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(shortDescription),
          Text(
            'Prazo: ${_dateFormat(task.dueDate.toString())}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: () => _deleteTask(index, context),
              child: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 199, 17, 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
