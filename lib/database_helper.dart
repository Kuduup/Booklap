import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('booklap_new.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    debugPrint("Database Path : $path");

    return await openDatabase(
      path,
      version: 3,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        lapangan TEXT NOT NULL,
        jam TEXT NOT NULL,
        durasi TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    debugPrint("Database berhasil dibuat");
  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {

    if (oldVersion < 2) {
      try {
        await db.execute(
          "ALTER TABLE bookings ADD COLUMN durasi TEXT DEFAULT '1'",
        );
      } catch (_) {}
    }
  }

  //================ REGISTER ================//

  Future<int> registerUser(
      String username,
      String password,
      ) async {

    final db = await database;

    return await db.insert(
      'users',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  //================ LOGIN ================//

  Future<Map<String, dynamic>?> loginUser(
      String username,
      String password,
      ) async {

    final db = await database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  //================ TAMBAH BOOKING ================//

  Future<int> tambahBooking(
      String nama,
      String lapangan,
      String jam,
      String durasi,
      String status,
      ) async {

    final db = await database;

    final id = await db.insert(
      'bookings',
      {
        'nama': nama,
        'lapangan': lapangan,
        'jam': jam,
        'durasi': durasi,
        'status': status,
      },
    );

    debugPrint("Booking berhasil disimpan. ID = $id");

    return id;
  }

  //================ GET BOOKING ================//

  Future<List<Map<String, dynamic>>> getBooking() async {

    final db = await database;

    return await db.query(
      'bookings',
      orderBy: 'id DESC',
    );
  }

  //================ UPDATE BOOKING ================//

  Future<int> updateBooking(
      int id,
      String nama,
      String lapangan,
      String jam,
      String durasi,
      String status,
      ) async {

    final db = await database;

    return await db.update(
      'bookings',
      {
        'nama': nama,
        'lapangan': lapangan,
        'jam': jam,
        'durasi': durasi,
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //================ DELETE BOOKING ================//

  Future<int> deleteBooking(int id) async {

    final db = await database;

    return await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //================ CLOSE DB ================//

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}