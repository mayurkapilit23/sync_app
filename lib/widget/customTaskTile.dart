import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/taskModel.dart';
import '../providers/taskProvider.dart';

class CustomTaskTile extends StatelessWidget {
  final Task task;
  final deleteTask;
  final onToggleStatus;

  const CustomTaskTile({
    super.key,
    required this.task,
    this.deleteTask,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: deleteTask,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // _formatDate(task.updatedOn),
                  '${task.updated_on}',
                  style: const TextStyle(fontSize: 12),
                ),
                // task.status == 'loading'
                //     ? SizedBox(
                //         width: 20,
                //         height: 20,
                //         child: CircularProgressIndicator(),
                //       )
                //     : Container(),
                Row(
                  children: [
                    task.status == 'synced'
                        ? Icon(Icons.cloud_sync, color: Colors.green)
                        : Icon(Icons.pending, color: Colors.yellow),
                  ],
                ),

                // Row(
                //   children: [
                //     Icon(Icons.pending), Text('${task.status}')
                //   ],
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //   String _formatDate(String? dateStr) {
  //     try {
  //       final date = DateTime.parse(dateStr ?? '');
  //       return DateFormat('hh:mm a dd MMM, yyyy').format(date);
  //     } catch (e) {
  //       return '';
  //     }
  //   }
}
