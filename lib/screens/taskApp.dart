import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_app/model/taskModel.dart';
import 'package:sync_app/widget/customTaskTile.dart';
import '../database/SocketService.dart';
import '../providers/taskProvider.dart';
import '../widget/customButton.dart';
import 'addTaskScreen.dart';

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<TaskProvider>(context, listen: false);

    // 1. Load local tasks from SQLite
    Future.microtask(() => provider.loadTasks());

    // 2. Connect to socket server
    socketService.connect();

    // 3. When server sends tasks, merge them into local state + DB
    socketService.onTasksReceived = (tasksFromServer) {
      print(tasksFromServer.status);
      provider.mergeTasks(tasksFromServer);

      // Optional: show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Synced ${tasksFromServer} tasks from server')),
      );
    };

    // 4. Automatically request sync after short delay
    Future.delayed(Duration(seconds: 10), () {
      socketService.requestSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hello ${provider.getUserId()} ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (_, index) {
                final task = provider.tasks[index];
                return CustomTaskTile(
                  task: task,
                  deleteTask: () => provider.deleteTask(task.id),
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              label: 'Backup',
              onPressed: () {
                // socketService.sendTaskList(provider.tasks);

                for(int i=0;i<provider.tasks.length;i++){
                  provider.backup(provider.tasks[i], socketService);
                }

              },

              color: Colors.green,
            ),
            // CustomButton(label: 'Sync', onPressed: () {}, color: Colors.blue),
            CustomButton(
              label: 'Delete',
              onPressed: provider.deleteAllTasks,
              color: Colors.red,
            ),
          ],
        ),
      ],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
