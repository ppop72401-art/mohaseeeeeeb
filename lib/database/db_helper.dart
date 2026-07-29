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
    _database = await _initDB('massive_accounting_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE suppliers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      credit_limit REAL NOT NULL,
      total_debt REAL NOT NULL DEFAULT 0,
      risk_level TEXT NOT NULL DEFAULT 'Low' 
    )
    ''');

    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      supplier_id INTEGER NOT NULL,
      amount REAL NOT NULL,
      type TEXT NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (supplier_id) REFERENCES suppliers (id)
    )
    ''');
    
    // بيانات تجريبية لتشغيل التحليلات
    await db.insert('suppliers', {'name': 'الشركة الهندسية', 'credit_limit': 50000, 'total_debt': 45000, 'risk_level': 'High'});
    await db.insert('transactions', {'supplier_id': 1, 'amount': 15000, 'type': 'invoice', 'date': '2023-08-01'});
  }
}
