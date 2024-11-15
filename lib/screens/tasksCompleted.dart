import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/models/card.dart';
import 'package:avaliacao1/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksCompleted extends StatefulWidget {
  final List<Task> completedTasks;

  const TasksCompleted({required this.completedTasks, super.key});

  @override
  State<TasksCompleted> createState() => _TasksCompletedState();
}

class _TasksCompletedState extends State<TasksCompleted> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final completedTasks = taskProvider.tasksCompleted;
    
    return Column(
      children: [
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {

              return ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    index: index, 
                    task: completedTasks[index], 
                    cardColor: Colors.greenAccent,
                    onDelete: () {
                      taskProvider.removeCompletedTask(index);
                    },
                  );
                },
              );
            },
          )
        ),
      ],
    );
  }
}

