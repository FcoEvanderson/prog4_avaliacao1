import 'dart:convert';

import 'package:avaliacao1/models/Task.dart';
import 'package:avaliacao1/widgets/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasksList = [];
  final List<Task> _tasksPending = [];
  final List<Task> _tasksCompleted = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedType = 'Todos';
  final apiUrl = "https://to-do-e538f-default-rtdb.firebaseio.com";

  List<Task> get tasksPending => _tasksPending;
  List<Task> get tasksCompleted => _tasksCompleted;
  String get selectedType => _selectedType;

  TaskProvider(this.notificationService);

  final AppNotificationService notificationService;

  Future<void> initialize() async {
    await loadTasks();
  }

  List<Task> get tasksList {
    if (_selectedType == 'Todos') return _tasksList;
    return _tasksList.where((task) => task.type == _selectedType).toList();
  }

  Future<void> loadTasks() async {
    await _loadTasks();
    await _loadCompletedTasks();
    await _loadPendingTasks();
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    try {
      final url = '$apiUrl/tasks.json';

      final response = await http.get(
        Uri.parse(url),
      );
      _tasksList.clear();
      final data = jsonDecode(response.body);
      data.forEach((key, data) {
        data['id'] = key;
        _tasksList.add(Task.fromMap(data));
      });
    } catch (e) {}
  }

  Future<void> _loadCompletedTasks() async {
    try {
      final url = '$apiUrl/completed-tasks.json';

      final response = await http.get(
        Uri.parse(url),
      );
      _tasksCompleted.clear();
      final data = jsonDecode(response.body);
      data.forEach((key, data) {
        data['id'] = key;
        _tasksCompleted.add(Task.fromMap(data));
      });
    } catch (e) {}
  }

  Future<void> _loadPendingTasks() async {
    try {
      final url = '$apiUrl/pending-tasks.json';

      final response = await http.get(
        Uri.parse(url),
      );
      _tasksPending.clear();
      final data = jsonDecode(response.body);

      data.forEach((key, data) {
        data['id'] = key;
        _tasksPending.add(Task.fromMap(data));
      });
    } catch (e) {}
  }

  void setSelectedType(String newType) {
    _selectedType = newType;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final url = '$apiUrl/tasks.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: task.toJson(),
      );

      final responseData = jsonDecode(response.body);
      final generatedId = responseData['name'];

      task.id = generatedId;
      _tasksList.add(task);

      _checkExpiredTasks();
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
    }
  }

  Future<void> updateTask(int index, Task newTask) async {
    try {
      final task = _tasksList[index];

      newTask.id = task.id;

      _tasksList[index] = newTask;

      final url = '$apiUrl/tasks/${task.id}.json';

      _checkExpiredTasks();
      notifyListeners();

      await http.patch(Uri.parse(url), body: jsonEncode(newTask.toMap()));
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final url = '$apiUrl/tasks/$taskId.json';
    try {
      final task = _tasksList.firstWhere((task) => task.id == taskId);
      _tasksList.removeWhere((task) => task.id == taskId);

      await http.delete(Uri.parse(url), body: task.toJson());

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  void removePendingTask(String taskId) async {
    final url = '$apiUrl/pending-tasks/$taskId.json';
    try {
      Task task = _tasksPending.firstWhere((task) => task.id == taskId);
      _tasksPending.removeWhere((task) => task.id == taskId);
      await http.delete(Uri.parse(url), body: task.toJson());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeCompletedTask(String taskId) async {
    final url = '$apiUrl/completed-tasks/$taskId.json';
    try {
      Task task = _tasksCompleted.firstWhere((task) => task.id == taskId);

      _tasksCompleted.removeWhere((task) => task.id == taskId);

      await http.delete(Uri.parse(url), body: task.toJson());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> moveTaskToCompleted(Task task) async {
    final urlToCompleted = '$apiUrl/completed-tasks.json';
    final urlRemoveTask = '$apiUrl/tasks/${task.id}.json';
    final urlRemovePendingTask = '$apiUrl/pending-tasks/${task.id}.json';

    try {
      if (task.isPending) {
        _tasksPending.remove(task);
        task.isCompleted = true;
        task.isPending = false;
        _tasksCompleted.add(task);
        http.delete(Uri.parse(urlRemovePendingTask), body: task.toJson());
        http.post(Uri.parse(urlToCompleted), body: task.toJson());
      } else {
        _tasksList.remove(task);

        task.isCompleted = true;
        task.isPending = false;

        _tasksCompleted.add(task);

        http.delete(Uri.parse(urlRemoveTask), body: task.toJson());
        http.post(Uri.parse(urlToCompleted), body: task.toJson());
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao mover tarefa para concluídas: $e');
    }
  }

  void moveTaskToPending(String taskId) {
    final urlToPending = '$apiUrl/pending-tasks.json';
    final urlRemoveTask = '$apiUrl/tasks/$taskId.json';
    try {
      final task = _tasksList.firstWhere((task) => task.id == taskId);

      task.isPending = true;
      task.isCompleted = false;

      _tasksList.removeWhere((task) => task.id == taskId);
      _tasksPending.add(task);

      http.delete(Uri.parse(urlRemoveTask), body: task.toJson());
      http.post(Uri.parse(urlToPending), body: task.toJson());
    } catch (e) {
      print(e);
    }
  }

  void _checkExpiredTasks() {
    final currentDate = DateTime.now();
    final startToday =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (Task task in List.from(_tasksList)) {
      if (task.dueDate.isBefore(startToday)) {
        moveTaskToPending(task.id);
        _tasksList.remove(task);

        task.isPending = true;
        task.isCompleted = false;

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
