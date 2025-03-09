import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'usermodel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      age INTEGER NOT NULL,
      diagnosis TEXT NOT NULL,
      speechTherapyScore INTEGER DEFAULT 0,
      emotionTherapyScore INTEGER DEFAULT 0,
      shapeMatchingScore INTEGER DEFAULT 0
    )
  ''');
  }

  Future<int> updateScore(int userId, String game, int newScore) async {
    final db = await instance.database;
    String columnName = "";

    if (game == "Speech Therapy") {
      columnName = "speechTherapyScore";
    } else if (game == "Emotion Therapy") {
      columnName = "emotionTherapyScore";
    } else if (game == "Shape Matching") {
      columnName = "shapeMatchingScore";
    }

    return await db.update(
      'users',
      {columnName: newScore},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await database; // Ensure the database instance is available
    List<Map<String, dynamic>> result = await db.query(
      'users', // Your table name
      where: 'id = ?', // Assuming 'uid' is your primary key
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the first matching user
    }
    return null; // Return null if no user is found
  }

  // Insert User (Sign Up)
  Future<int> insertUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get User (Login)
  Future<User?> getUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
