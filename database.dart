import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
Future<void> fetchDataAndStoreInSQLite() async {
  // Fetch data from the API
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  // Parse JSON response
  final List<dynamic> jsonData = json.decode(response.body);

  // Open SQLite database
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'posts_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)',
      );
    },
    version: 1,
  );

  // Insert data into SQLite database
  for (final post in jsonData) {
    await database.insert(
      'posts',
      post,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
*/



//Function to fetch data from API and store in SQLite
Future<void> fetchDataAndStoreInSQLite() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  final List<dynamic> jsonData = json.decode(response.body);

  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'posts_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)',
      );
    },
    version: 1,
  );

  for (final post in jsonData) {
    await database.insert(
      'posts',
      {'id': post['id'], 'title': post['title'], 'body': post['body']},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}