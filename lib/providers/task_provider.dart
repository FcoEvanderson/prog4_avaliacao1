import 'package:avaliacao1/models/Task.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  List<Task> tasksPending = [];
  List<Task> tasksCompleted = [];

  void addTask(Task task) {
    tasksList.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    tasksList.removeAt(index);
    notifyListeners();
  }

  void markAsCompleted(int index) {
    tasksCompleted.add(tasksList[index]);
    tasksList.removeAt(index);
    notifyListeners();
  }

  void markAsPending(Task task) {
    tasksPending.add(task);
    notifyListeners();
  }
}