import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled/database.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Future<List<Map<String, dynamic>>?>? _posts;

  @override
  void initState() {
    super.initState();
    _posts = _fetchPostsFromSQLite();
  }

  Future<List<Map<String, dynamic>>?> _fetchPostsFromSQLite() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'posts_database.db'),
    );
    return await database.query('posts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post['title'] ?? ''),
                  subtitle: Text(post['body'] ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchDataAndStoreInSQLite();
  runApp(MaterialApp(
    home: PostsScreen(),
  ));
}
