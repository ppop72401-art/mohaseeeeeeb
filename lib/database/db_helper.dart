import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('accounting_system.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // إعداد ffi الخاص بالويندوز
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    // إنشاء جدول الموردين (الميزة 9-16)
    await db.execute('''
    CREATE TABLE suppliers (
      id $idType,
      name $textType,
      company $textType,
      phone $textType,
      email $textType,
      credit_limit $realType,
      balance $realType,
      is_active INTEGER NOT NULL
    )
    ''');

    // يمكن إضافة جداول المخزون والفواتير هنا تباعاً
  }
}

