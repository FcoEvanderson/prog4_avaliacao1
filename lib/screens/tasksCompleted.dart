import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/models/card.dart';
import 'package:flutter/material.dart';

class TasksCompleted extends StatefulWidget {
  final List<Task> completedTasks;

  const TasksCompleted({required this.completedTasks, super.key});

  @override
  State<TasksCompleted> createState() => _TasksCompletedState();
}

class _TasksCompletedState extends State<TasksCompleted> {
  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.completedTasks[index];

                    return TaskCard(
                      index: index, 
                      task: task, 
                      tasksList: widget.completedTasks,
                      cardColor: Colors.greenAccent,
                    );
                  },
                )
              ),
            ],
          );
  }
}

