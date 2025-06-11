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

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabel kategori
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        tipe TEXT NOT NULL
      )
    ''');

    // Tabel dompet
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dompet (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        saldo INTEGER NOT NULL
      )
    ''');

    // Tabel transaksi
    await db.execute('''
      CREATE TABLE IF NOT EXISTS transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        kategori_id INTEGER,
        deskripsi TEXT,
        tipe TEXT NOT NULL,
        dompet_id INTEGER,
        FOREIGN KEY (kategori_id) REFERENCES kategori (id),
        FOREIGN KEY (dompet_id) REFERENCES dompet (id)
      )
    ''');

    // 🪙 Masukkan Dompet default
    await db.insert('dompet', {
      'nama': 'Dompet Utama',
      'saldo': 0,
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
