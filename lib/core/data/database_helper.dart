import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// sqlite db helper
/// manages creation, versioning and provides access to the db instance
/// using singleton pattern to ensure only one db connection exist
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // private constructor for singleton
  DatabaseHelper._internal();

  // factory constructor returns the singleton instance
  factory DatabaseHelper() => _instance;

  // get db instance, will create if it doesnt exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// init db and create the db file and set up  the tables
  Future<Database> _initDatabase() async {
    // get the default db location
    String path = join(await getDatabasesPath(), 'juan_by_juan.db');

    // open/create db with version 1
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// create db tables
  /// caleld when db is created for the first time
  Future<void> _onCreate(Database db, int version) async {
    // bills table
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE
      )
    ''');

    // items table
    await db.execute(''' 
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE
      )
    ''');

    // people table
    await db.execute('''
      CREATE TABLE item_person_splits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        split_amount INTEGER NOT NULL,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE,
        FOREIGHT KEY (person_id) REFERENCES people (id) ON DELETE CASCADE
      )
    ''');
  }

  /// close db connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// delete db
  Future<void> deleteDb() async {
    String path = join(await getDatabasesPath(), 'juan_by_juan.db');
    await deleteDatabase(path);
    _database = null;
  }
}
