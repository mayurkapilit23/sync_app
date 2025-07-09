import 'package:flutter/material.dart';
import '../database/dbHelper.dart';
import '../model/taskModel.dart';

class TaskProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  /// Load all tasks from the database
  Future<void> loadTasks() async {
    _tasks = await DBHelper().getTasks();
    notifyListeners();
  }

  /// Add a new task with UUID, description, and status
  Future<void> addTask(String text, String description) async {
    final newTask = Task(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      updated_on: DateTime.now().toIso8601String(),
      status: 'pending', // default status
    );

    await DBHelper().insertTask(newTask);

    titleController.clear();
    descriptionController.clear();

    await loadTasks();
  }

  /// Delete task by UUID (String)
  Future<void> deleteTask(String id) async {
    await DBHelper().deleteTask(id);
    await loadTasks();
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    await DBHelper().deleteAllTasks();
    await loadTasks();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
