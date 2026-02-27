import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isDone INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertTask(TaskModel task) async {
    Database dbClient = await db;

    return await dbClient.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getTasks() async {
    Database dbClient = await db;

    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
      'SELECT * FROM tasks',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(TaskModel task) async {
    Database dbClient = await db;

    return await dbClient.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database dbClient = await db;

    return await dbClient.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }
}
