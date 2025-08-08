import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер задач',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TaskManagerScreen(),
    );
  }
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<String> tasks = [];
  final TextEditingController _controller = TextEditingController();
  int? _editingIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = tasks[index];
    });
  }

  void _updateTask() {
    if (_editingIndex != null && _controller.text.isNotEmpty) {
      setState(() {
        tasks[_editingIndex!] = _controller.text;
        _editingIndex = null;
        _controller.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер задач'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите задачу',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      _editingIndex == null ? _addTask() : _updateTask();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: _editingIndex == null ? _addTask : _updateTask,
                  child: Icon(_editingIndex == null ? Icons.add : Icons.save),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _startEditing(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
