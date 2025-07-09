import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_app/widget/customTaskTile.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TaskProvider>(context, listen: false).loadTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello Mayur',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
         IconButton(onPressed: (){}, icon: Icon(Icons.menu))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Form(
          //     key: formKey,
          //     child: TextFormField(
          //       controller: provider.titleController,
          //       decoration: InputDecoration(
          //         hintText: 'Enter Task',
          //         // suffixIcon: IconButton(
          //         //   icon: Icon(Icons.add),
          //         //   onPressed: () {
          //         //     if (formKey.currentState!.validate()) {
          //         //       provider.addTask(
          //         //         provider.titleController.text.trim(),
          //         //         provider.descriptionController.text.trim(),
          //         //       );
          //         //     }
          //         //   },
          //         // ),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.trim().isEmpty) {
          //           return 'Please enter a task';
          //         }
          //         return null;
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (_, index) {
                final task = provider.tasks[index];
                return CustomTaskTile(task: task,deleteTask: ()=>provider.deleteTask(task.id),);

                // return ListTile(
                //   title: Text(task.title),
                //   trailing: IconButton(
                //     icon: Icon(Icons.delete),
                //     onPressed: () => provider.deleteTask(task.id),
                //   ),
                // );
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
              onPressed: () {},
              color: Colors.green,
            ),
            CustomButton(label: 'Sync', onPressed: () {}, color: Colors.blue),
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
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );

      },child: Icon(Icons.add, color: Colors.white),),
    );
  }
}
