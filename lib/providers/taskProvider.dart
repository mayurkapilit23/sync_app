import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/SocketService.dart';
import '../database/dbHelper.dart';
import '../model/taskModel.dart';

class TaskProvider extends ChangeNotifier {
  // final socketService = SocketService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Task> _tasks = [];
  bool _isBackupLoading = false;

  List<Task> get tasks => _tasks;

  bool get isBackupLoading => _isBackupLoading;

  /// Load all tasks from the database
  Future<void> loadTasks() async {
    _tasks = await DBHelper().getTasks();
    notifyListeners();
  }

  /// Add a new task with UUID, description, and status
  Future<void> addTask(String text, String description) async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd – hh:mm a').format(now);

    final newTask = Task(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      // updated_on: DateTime.now().toIso8601String(),
      updated_on: formattedDate,
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

  void mergeTasks(Task serverTasks) async {
    await DBHelper().updateTask(serverTasks);

    int result = await DBHelper().updateTask(serverTasks);

    if (result > 0) {
      print(' Task updated successfully');
    } else {
      print(' Task update failed or task not found');
    }

    _tasks = await DBHelper().getTasks();
    notifyListeners();
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.getInt('user_id');
  }

  void backup(Task task, SocketService socket) async {
    _isBackupLoading = true;
    // task.status = 'loading';
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    socket.sendTaskList([task]);

    _isBackupLoading = false;
    // task.status = 'synced';

    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
