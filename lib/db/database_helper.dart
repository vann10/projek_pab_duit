import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('keuangan.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        tipe TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE dompet (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        saldo INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        kategori_id INTEGER,
        deskripsi TEXT,
        tipe TEXT NOT NULL,
        FOREIGN KEY (kategori_id) REFERENCES kategori (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        kategori_id INTEGER,
        deskripsi TEXT,
        tipe TEXT NOT NULL,
        FOREIGN KEY (kategori_id) REFERENCES kategori (id)
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
