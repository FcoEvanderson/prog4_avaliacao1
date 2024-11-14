class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  String? type;

  Task({
    this.id, 
    required this.title, 
    required this.description, 
    required this.dueDate,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'type': type,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      type: map['type']
    );
  }
}