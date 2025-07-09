import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String? description;
  String? updated_on;
  String status;

  Task({
    String? id,
    required this.title,
    this.description,
    this.updated_on,
    this.status = 'pending',
  }) : id = id ?? const Uuid().v4(); // <- generate UUID if not passed

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'updated_on': updated_on,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      updated_on: map['updated_on'],
      status: map['status'] ?? 'pending',
    );
  }
}
