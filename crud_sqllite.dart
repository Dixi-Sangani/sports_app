import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  int? id;
  String title;
  String description;

  Task({this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
    );
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}




class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  var filteredTaskList = <Task>[].obs;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() async {
    taskList.value = await _databaseHelper.getTasks();
    filteredTaskList.value = taskList;
  }

  void filterTasksByName(String query) {
    if (query.isEmpty) {
      filteredTaskList.value = taskList;
    } else {
      filteredTaskList.value = taskList
          .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void addTask(Task task) async {
    await _databaseHelper.insertTask(task);
    fetchTasks();
  }

  void updateTask(Task task) async {
    await _databaseHelper.updateTask(task);
    fetchTasks();
  }

  void deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
    fetchTasks();
  }
}

class HomeScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Title',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    taskController.filterTasksByName(searchController.text);
                  },
                ),
              ),
              onChanged: (value) {
                taskController.filterTasksByName(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: taskController.filteredTaskList.length,
                itemBuilder: (context, index) {
                  final task = taskController.filteredTaskList[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        taskController.deleteTask(task.id!);
                      },
                    ),
                    onTap: () {
                      titleController.text = task.title;
                      descriptionController.text = task.description;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Update Task'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration:
                                InputDecoration(labelText: 'Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                taskController.updateTask(Task(
                                  id: task.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                ));
                                Get.back();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    taskController.addTask(Task(
                      title: titleController.text,
                      description: descriptionController.text,
                    ));
                    Get.back();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


