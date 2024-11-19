import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/models/task_card.dart';
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

    return completedTasks.isEmpty
        ? const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 100, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/completedtasks_image.png'),
                    width: 400,
                  ),
                  Text(
                    'Sem tarefas concluídas no momento...',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Que tal irmos concluir algumas? =)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              Expanded(child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: completedTasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasksCompleted[index];
                      return TaskCard(
                        index: index,
                        task: completedTasks[index],
                        cardColor: Colors.greenAccent,
                        onDelete: () async {
                          await taskProvider.removeCompletedTask(task.id);
                        },
                      );
                    },
                  );
                },
              )),
            ],
          );
  }
}
