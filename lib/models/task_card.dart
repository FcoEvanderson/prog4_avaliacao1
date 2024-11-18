import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/views/task_description.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final int index;
  final Task task;
  final VoidCallback onDelete;
  final Color? cardColor;

  const TaskCard(
      {super.key,
      required this.index,
      required this.task,
      required this.onDelete,
      this.cardColor,
    });

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(shortDescription),
                Text(
                  'Prazo: ${_dateFormat(task.dueDate.toString())}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
        trailing: GestureDetector(
              onTap: () {
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
                            onDelete();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text('Excluir'),
                        ),
                      ],
                    );
                  });
              },
              child: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 199, 17, 4),
              ),
            ),
            onTap: () async {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => TaskDescription(task: task),
                )
              );
            },
      ),
    );
  }
}
