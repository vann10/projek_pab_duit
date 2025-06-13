import 'package:projek_pab_duit/screens/home_page.dart';
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

    // Insert dompet default
    await db.insert('dompet', {
      'nama': 'Dompet Utama',
      'saldo': 0,
    });

    // Insert kategori default
    final List<Map<String, dynamic>> defaultKategori = [
      {'nama': 'Makanan', 'tipe': 'EXPENSE'},
      {'nama': 'Transportasi', 'tipe': 'EXPENSE'},
      {'nama': 'Belanja', 'tipe': 'EXPENSE'},
      {'nama': 'Hiburan', 'tipe': 'EXPENSE'},
      {'nama': 'Gaji', 'tipe': 'INCOME'},
      {'nama': 'Lainnya', 'tipe': 'BOTH'},
    ];

    for (var kategori in defaultKategori) {
      await db.insert('kategori', kategori);
    }
  }

  // Insert transaksi dan update saldo dompet dalam satu transaksi database
  Future<bool> insertTransaksiWithUpdateSaldo({
    required int jumlah,
    required String kategori,
    required String deskripsi,
    required String tipe, // 'INCOME' atau 'EXPENSE'
    int dompetId = 1, // Default ke dompet utama
  }) async {
    final db = await instance.database;
    
    try {
      await db.transaction((txn) async {
        // 1. Cari kategori_id berdasarkan nama kategori
        final kategoriResult = await txn.query(
          'kategori',
          where: 'nama = ?',
          whereArgs: [kategori],
          limit: 1,
        );
        
        int? kategoriId;
        if (kategoriResult.isNotEmpty) {
          kategoriId = kategoriResult.first['id'] as int;
        }

        // 2. Insert transaksi
        await txn.insert('transaksi', {
          'tanggal': DateTime.now().toIso8601String(),
          'jumlah': jumlah,
          'kategori_id': kategoriId,
          'deskripsi': deskripsi,
          'tipe': tipe,
          'dompet_id': dompetId,
        });

        // 3. Update saldo dompet
        final saldoChange = tipe == 'INCOME' ? jumlah : -jumlah;
        await txn.rawUpdate(
          'UPDATE dompet SET saldo = saldo + ? WHERE id = ?',
          [saldoChange, dompetId],
        );
      });
      
      return true;
    } catch (e) {
      print('Error inserting transaction: $e');
      return false;
    }
  }

  // Fungsi untuk mendapatkan kategori berdasarkan tipe
  Future<List<Map<String, dynamic>>> getKategoriByTipe(String tipe) async {
    final db = await instance.database;
    return await db.query(
      'kategori',
      where: 'tipe = ? OR tipe = ?',
      whereArgs: [tipe, 'BOTH'],
    );
  }

  // Fungsi untuk mendapatkan semua dompet
  Future<List<Map<String, dynamic>>> getAllDompet() async {
    final db = await instance.database;
    return await db.query('dompet');
  }

  // Fungsi untuk mendapatkan saldo dompet tertentu
  Future<int> getSaldoDompet(int dompetId) async {
    final db = await instance.database;
    final result = await db.query(
      'dompet',
      columns: ['saldo'],
      where: 'id = ?',
      whereArgs: [dompetId],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first['saldo'] as int;
    }
    return 0;
  }

  Future<int> getTotalSaldo() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(saldo) as total FROM dompet');
    return result.first['total'] != null ? result.first['total'] as int : 0;
  }

  // Fungsi untuk mendapatkan riwayat transaksi
  Future<List<Map<String, dynamic>>> getTransaksi({int limit = 50}) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT t.*, k.nama as kategori_nama, d.nama as dompet_nama
      FROM transaksi t
      LEFT JOIN kategori k ON t.kategori_id = k.id
      LEFT JOIN dompet d ON t.dompet_id = d.id
      ORDER BY t.tanggal DESC
      LIMIT ?
    ''', [limit]);
  }

  Future<List<Transaksi>> getAllTransaksi() async {
    final db = await database;
    final result = await db.query('transaksi', orderBy: 'tanggal DESC');
    return result.map((json) => Transaksi.fromMap(json)).toList();
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}