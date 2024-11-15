import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/widgets/notifications.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasksList = [];
  List<Task> _tasksPending = [];
  List<Task> _tasksCompleted = [];
  String _selectedType = 'Todos';

  List<Task> get tasksPending => _tasksPending;
  List<Task> get tasksCompleted => _tasksCompleted;
  String get selectedType => _selectedType;

  void setSelectedType(String newType) {
    _selectedType = newType;
    notifyListeners();
  }

  final AppNotificationService notificationService;

  TaskProvider(this.notificationService);

  List<Task> get tasksList {
    if (_selectedType == 'Todos') return _tasksList;
    return _tasksList.where(
      (task) => task.type == _selectedType
    ).toList();
  }

  void addTask(Task task) {
    _tasksList.add(task);
    _checkExpiredTasks();
    notifyListeners();
  }
  
  void removePendingTask(int index) {
    _tasksPending.removeAt(index);
    notifyListeners();
  }

  void removeCompletedTask(int index) {
    _tasksCompleted.removeAt(index);
    notifyListeners();
  }

  void moveTaskToCompleted(int index) {
    final task = _tasksPending.removeAt(index);
    _tasksCompleted.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasksList.removeAt(index);
    notifyListeners();
  }

  void _checkExpiredTasks() {
    final currentDate = DateTime.now();
    final startToday = 
      DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (var task in List.from(_tasksList)) {
      if (task.dueDate.isBefore(startToday)) {
        _tasksList.remove(task);
        _tasksPending.add(task);
        notificationService.showNotification(
          'A TAREFA EXPIROU!',
          'O prazo da tarefa "${task.title}" expirou!',
        );
      } else if (task.dueDate.day == currentDate.day &&
                 task.dueDate.month == currentDate.month &&
                 task.dueDate.year == currentDate.year) {
        notificationService.showNotification(
          'O PRAZO EXPIRA HOJE!',
          'Atenção! O prazo da tarefa "${task.title}" expira hoje!',
        );
      }
    }
    notifyListeners();
  }

  void markAsCompleted(Task task) {
    tasksList.remove(task);
    tasksCompleted.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task newTask) {
    _tasksList[index] = newTask;
    _checkExpiredTasks();
    notifyListeners();
  }

  void markAsPending(Task task) {
    tasksPending.add(task);
    notifyListeners();
  }
}