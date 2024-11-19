// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        type: data['type'] ?? 'Outro',
        dueDate: (data['dueDate']),
        isCompleted: data['isCompleted'],
        isPending: data['isPending']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'type': type,
      'isCompleted': isCompleted,
      'isPending': isPending,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      type: map['type'] as String,
      isCompleted: map['isCompleted'] as bool,
      isPending: map['isPending'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
