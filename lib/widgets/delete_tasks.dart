import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteTask extends StatelessWidget {
  final int index;

  const DeleteTask({
    super.key,
    required this.index,
  });

  _deleteTask(BuildContext context, List<Task> tasksList) {
    
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return IconButton(
      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 163, 31, 22)),
      onPressed: () {
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
                  taskProvider.deleteTask(taskProvider.tasksList[index].id);
                  Navigator.pop(context);
                  (context as Element).markNeedsBuild();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Excluir'),
              ),
            ],
          );
        });
      },
    );
  }
}