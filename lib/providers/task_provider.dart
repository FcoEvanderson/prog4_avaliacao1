import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasksList = [];
  final List<Task> _tasksPending = [];
  final List<Task> _tasksCompleted = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedType = 'Todos';

  List<Task> get tasksPending => _tasksPending;
  List<Task> get tasksCompleted => _tasksCompleted;
  String get selectedType => _selectedType;

  TaskProvider(this.notificationService);

  final AppNotificationService notificationService;

  Future<void> initialize() async {
    await loadTasksFromFirestore();
  }

  List<Task> get tasksList {
    if (_selectedType == 'Todos') return _tasksList;
    return _tasksList.where(
      (task) => task.type == _selectedType
    ).toList();
  }

  Future<void> loadTasksFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('tasks').get();
      _tasksList = snapshot.docs.map((doc) {
        return Task.fromMap(doc.data());
      }).toList();
      _checkExpiredTasks();
      notifyListeners();
      notifyListeners();
    } catch(e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  void setSelectedType(String newType) {
    _selectedType = newType;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      final doc = await _firestore.collection('tasks').add(task.toMap());
      task.id = doc.id;
      _tasksList.add(task);
      _checkExpiredTasks();
      notifyListeners();
    } catch(e) {
      print('Erro ao carregar tarefas: $e');
    }
  }
  
  Future<void> updateTask(int index, Task newTask) async {
    try {
      final task = _tasksList[index];
      await _firestore.collection('tasks')
      .doc(task.id).update(newTask.toMap());
      _tasksList[index] = newTask;
      _checkExpiredTasks();
      notifyListeners();
    } catch(e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final task = _tasksList.firstWhere((task) => task.id == taskId);
      await _firestore.collection('tasks').doc(task.id).delete();
      _tasksList.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch(e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  void removePendingTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      _tasksPending.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch(e) {
      print(e);
    }
  }

  void removeCompletedTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();

      _tasksCompleted.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch(e) {
      print(e);
    }
  }

  void moveTaskToCompleted(String taskId) {
    try {
      final task = _tasksList.firstWhere((task) => task.id == taskId);
      _tasksList.removeWhere((task) => task.id == taskId);

      task.isCompleted = true;
      task.isPending = false;
      
      _tasksCompleted.add(task);
      notifyListeners();
    } catch(e) {
      print('Erro ao mover tarefa para concluídas: $e');
    }
  }

  void moveTaskToPending(String taskId) {
    try {
      final task = _tasksList.firstWhere((task) => task.id == taskId);

      task.isPending = true;
      task.isCompleted = false;

      _tasksList.removeWhere((task) => task.id == taskId);
      _tasksPending.add(task);
    } catch (e) {
      print(e);
    }
  }

  void _checkExpiredTasks() {
    final currentDate = DateTime.now();
    final startToday = 
      DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (var task in List.from(_tasksList)) {
      if (task.dueDate.isBefore(startToday)) {
        _tasksList.remove(task);

        task.isPending = true;
        task.isCompleted = false;

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
}