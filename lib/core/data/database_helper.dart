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
      CREATE TABLE bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        total_amount INTEGER NOT NULL,
        created_at TEXT NOT NULL
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
      CREATE TABLE people (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        total_amount INTEGER NOT NULL,
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE
      )
    ''');

    // item_person_split table
    await db.execute('''
      CREATE TABLE item_person_splits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        split_amount INTEGER NOT NULL,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE,
        FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE
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

  /// insert a bill and return its id
  Future<int> insertBill(Map<String, dynamic> bill) async {
    final db = await database;
    return await db.insert('bills', bill);
  }

  /// get all bills ordered by created date - newes first
  Future<List<Map<String, dynamic>>> getAllBills() async {
    final db = await database;
    return await db.query('bills', orderBy: 'created_at DESC');
  }

  /// get a single bill by id
  Future<Map<String, dynamic>?> getBill(int id) async {
    final db = await database;
    final results = await db.query('bills', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  /// delete a bill by id
  Future<int> deleteBill(int id) async {
    final db = await database;
    return await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }

  /// insert and item and return its id
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('items', item);
  }

  /// get all items for a bill
  Future<List<Map<String, dynamic>>> getItemsForBill(int billId) async {
    final db = await database;
    return await db.query('items', where: 'bill_id = ?', whereArgs: [billId]);
  }

  /// insert a person and return its id
  Future<int> insertPerson(Map<String, dynamic> person) async {
    final db = await database;
    return await db.insert('people', person);
  }

  /// get all people for a bill
  Future<List<Map<String, dynamic>>> getPeopleForBill(int billId) async {
    final db = await database;
    return await db.query('people', where: 'bill_id = ?', whereArgs: [billId]);
  }

  /// insert an item-person split
  Future<int> insertSplit(Map<String, dynamic> split) async {
    final db = await database;
    return await db.insert('item_person_splits', split);
  }

  /// get all splits for a bill
  Future<List<Map<String, dynamic>>> getSplitsForBill(int billId) async {
    final db = await database;
    return await db.rawQuery(
      '''
        SELECT ips.* FROM item_person_splits ips
        INNER JOIN items i ON ips.item_id = i.id
        WHERE i.bill_id = ?
      ''',
      [billId],
    );
  }
}
