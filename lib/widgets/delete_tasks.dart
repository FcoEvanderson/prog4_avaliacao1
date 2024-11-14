import 'package:avaliacao1/models/Task.dart';
import 'package:flutter/material.dart';

class DeleteTask extends StatelessWidget {
  final int index;
  final List<Task> tasklist;
  final VoidCallback onTaskDeleted;

  const DeleteTask({
    super.key,
    required this.index,
    required this.tasklist,
    required this.onTaskDeleted,
  });

  _deleteTask(BuildContext context, List<Task> tasksList) {
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
                  onTaskDeleted;
                  (context as Element).markNeedsBuild();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Excluir'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 163, 31, 22)),
      onPressed: () => _deleteTask(context, tasklist),
    );
  }
}