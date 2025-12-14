import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'task_details_screen.dart';
import 'dart:math';
import 'completed_tasks_screen.dart';
import '../services/storage_service.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Drawer _buildAppDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Stats'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StatsScreen(tasks: _tasks)),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );

    if (result == 'deleted') {
      setState(() {
        _tasks.removeWhere((t) => t.id == task.id);
      });
      StorageService.saveTasks(_tasks);
    }
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
      drawer: _buildAppDrawer(),
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
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart, // swipe left
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete task?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    setState(() {
                      _tasks.removeAt(index);
                    });
                    StorageService.saveTasks(_tasks);
                  },
                  child: TaskTile(
                    task: task,
                    onTap: () => _openTaskDetails(task),
                    onChanged: (value) {
                      setState(() {
                        task.isDone = value!;
                      });
                      StorageService.saveTasks(_tasks);
                    },
                  ),
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
