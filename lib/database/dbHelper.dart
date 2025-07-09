import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/taskModel.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE tasks (
              id TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              updated_on TEXT,
              status TEXT
          )''');
      },
    );
  }

  // Insert a task
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Get all tasks
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Delete one task by UUID (String)
  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete('tasks');
  }

  // Update task by ID
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks', // table name
      task.toMap(), // updated values
      where: 'id = ?', // match by id
      whereArgs: [task.id],
    );
  }
}
