import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/taskProvider.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: taskProvider.titleController,
                decoration: inputDecoration.copyWith(hintText: 'Task Title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter task title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: taskProvider.descriptionController,
                maxLines: 4,
                decoration: inputDecoration.copyWith(
                  hintText: 'Task Description',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (taskProvider.titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    await taskProvider.addTask(
                      taskProvider.titleController.text.trim(),
                      taskProvider.descriptionController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added successfully')),
                    );

                    Navigator.pop(context); // Go back to task list screen
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
