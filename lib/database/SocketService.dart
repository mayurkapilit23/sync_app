import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sync_app/model/taskModel.dart';

import 'dbHelper.dart';

class SocketService {
  static const socketAddress = 'http://192.168.15.201:4000';

  /// Callback to send server tasks to Provider
  Function(Task)? onTasksReceived;

  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      socketAddress,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connect if needed
          .build(),
    );

    socket.connect();

    // Connection Events
    socket.onConnect((_) {
      print(' Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    // Sync Tasks From Server

    // socket.on("RESPONSE", (data) {
    //   print('Received task back from server: $data');
    //
    //     // final tasks = Task.fromMap(jsonDecode(data));
    //     // onTasksReceived?.call(tasks); // Pass to Provider
    //
    //
    //   try {
    //     //  data is already a Map, no need for jsonDecode
    //     final Task receivedTask = Task.fromMap(Map<String, dynamic>.from(data));
    //     print('📌 Task title: ${receivedTask.title}');
    //
    //     onTasksReceived?.call(receivedTask);
    //   } catch (e) {
    //     print('❌ Failed to parse task from RESPONSE: $e');
    //   }
    //
    //   // // Convert the JSON/map back to a Task object
    //   // Task receivedTask = Task.fromMap(Map<String, dynamic>.from(data));
    //   // print('Task title: ${receivedTask.title}');
    // });

    socket.on("RESPONSE", (data) {
      print('Received task from server: $data');
      try {
        //  No jsonDecode here!
        if (data is Map) {
          final task = Task.fromMap(Map<String, dynamic>.from(data));
          onTasksReceived?.call(task);
          print(' Task title: ${task.title}');
        } else if (data is String) {
          // fallback: handle if server sends JSON string (not recommended)
          final decoded = jsonDecode(data);
          final task = Task.fromMap(Map<String, dynamic>.from(decoded));
          onTasksReceived?.call(task);
        } else {
          print('️ Unexpected data type: ${data.runtimeType}');
        }
      } catch (e) {
        print(' Failed to parse task: $e');
      }
    });

    void disconnect() {
      socket.disconnect();
    }
  }

  void sendTaskList(List<Task> tasks) async {
    // tasks[0].title = 'playing';
    // print(taskList);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      print('user_id not found in SharedPreferences');
      return;
    }

    final unsyncedTasks = tasks
        .where((task) => task.status != 'synced')
        .toList();

    //
    // for (Task item in tasks) {
    //   print('Sending task: :${jsonEncode(item.toMap())}');
    //
    //   socket.emit(
    //     'BACKUP',
    //     jsonEncode(item.toMap()),
    //   ); //send to server using event name 'BACKUP'
    //   await Future.delayed(Duration(seconds: 2));
    // }

    for (Task item in unsyncedTasks) {
      final payload = {
        'user_id': userId,

        ...item.toMap(), // spread task fields
      };
      print('Sending task with user id: ${jsonEncode(payload)}');
      // print('Sending task: ${jsonEncode(item.toMap())}');

      // Emit to server
      socket.emit('BACKUP', jsonEncode(payload));
      // socket.emit('BACKUP', jsonEncode(item.toMap()));

      //  Update status to 'synced'
      item.status = 'synced';
      item.updated_on = DateTime.now().toIso8601String();

      //  Save updated task to local DB
      await DBHelper().updateTask(item);

      await Future.delayed(Duration(seconds: 2));
    }
  }

  /// Ask server to send tasks
  void requestSync() {
    socket.emit('SYNC_REQUEST');
  }
}
