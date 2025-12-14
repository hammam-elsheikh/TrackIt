import 'package:flutter/material.dart';
import '../models/task.dart';

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(Task) onRestore;

  const CompletedTasksScreen({
    super.key,
    required this.completedTasks,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Tasks')),
      body: completedTasks.isEmpty
          ? const Center(child: Text('No completed tasks'))
          : ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (_, index) {
                final task = completedTasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: () {
                      onRestore(task);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}
