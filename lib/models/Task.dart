import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  String type;
  bool isCompleted;
  bool isPending;

  Task({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.dueDate,
    required this.type,
    required this.isCompleted,
    required this.isPending,
  });

  factory Task.fromFirestore (DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: data['id'],
      title: data['title'], 
      description: data['description'], 
      type: data['type'] ?? 'Outro',
      dueDate: (data['dueDate']), 
      isCompleted: data['isCompleted'],
      isPending: data['isPending']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'type': type,
      'isCompleted': isCompleted,
      'isPending': isPending,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      type: map['type'],
      isCompleted: map['isCompleted'],
      isPending: map['isPending']
    );
  }
}