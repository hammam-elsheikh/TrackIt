import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'task_details_screen.dart';
import 'dart:math';
import 'completed_tasks_screen.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _openCompletedTasks() {
    final completedTasks = _tasks.where((task) => task.isDone).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompletedTasksScreen(
          completedTasks: completedTasks,
          onRestore: (task) {
            setState(() {
              task.isDone = false;
            });
            StorageService.saveTasks(_tasks);
          },
        ),
      ),
    );
  }

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(id: Random().nextInt(100000).toString(), title: title));
    });
    StorageService.saveTasks(_tasks);
  }

  void _openAddTaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _addTask(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _openTaskDetails(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );
    StorageService.saveTasks(_tasks);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await StorageService.loadTasks();
    setState(() {
      _tasks.clear();
      _tasks.addAll(loadedTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: _openCompletedTasks,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, index) {
                return TaskTile(
                  task: _tasks[index],
                  onTap: () => _openTaskDetails(_tasks[index]),
                  onChanged: (value) {
                    setState(() {
                      _tasks[index].isDone = value!;
                    });
                    StorageService.saveTasks(_tasks);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
