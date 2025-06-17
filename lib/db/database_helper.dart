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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    try {
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

      await db.insert('dompet', {'nama': 'Dompet Utama', 'saldo': 0});

      List<Map<String, String>> kategoriList = [
        {'nama': 'Makanan', 'tipe': 'EXPENSE'},
        {'nama': 'Kebutuhan', 'tipe': 'EXPENSE'},
        {'nama': 'Pakaian', 'tipe': 'EXPENSE'},
        {'nama': 'Tabungan', 'tipe': 'EXPENSE'},
        {'nama': 'Sosial', 'tipe': 'EXPENSE'},
        {'nama': 'Transportasi', 'tipe': 'EXPENSE'},
        {'nama': 'Lainnya', 'tipe': 'EXPENSE'},
        {'nama': 'Gaji', 'tipe': 'INCOME'},
        {'nama': 'Bonus', 'tipe': 'INCOME'},
        {'nama': 'Uang Saku', 'tipe': 'INCOME'},
        {'nama': 'Lainnya', 'tipe': 'INCOME'},
      ];

      for (var kategori in kategoriList) {
        await db.insert('kategori', kategori);
      }
    } catch (e) {
      print("❌ Error saat membuat database: $e");
    }
  }

  Future<void> addDompet(String nama, int saldo) async {
    final db = await instance.database;
    await db.insert('dompet', {'nama': nama, 'saldo': saldo});
  }

  // START: MODIFICATION
  /// Deletes a wallet and all its associated transactions.
  ///
  /// Returns `true` if deletion is successful, `false` otherwise.
  /// The main wallet (id = 1) cannot be deleted.
  Future<bool> deleteDompet(int id) async {
    // Prevent deleting the main wallet
    if (id == 1) {
      print("Deletion failed: Cannot delete the main wallet.");
      return false;
    }

    final db = await instance.database;
    try {
      await db.transaction((txn) async {
        // First, delete associated transactions to maintain data integrity
        await txn.delete('transaksi', where: 'dompet_id = ?', whereArgs: [id]);
        // Then, delete the wallet itself
        await txn.delete('dompet', where: 'id = ?', whereArgs: [id]);
      });
      return true;
    } catch (e) {
      print('❌ Error deleting wallet: $e');
      return false;
    }
  }
  // END: MODIFICATION

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
    return await db.rawQuery(
      '''
      SELECT t.*, k.nama as kategori_nama, d.nama as dompet_nama
      FROM transaksi t
      LEFT JOIN kategori k ON t.kategori_id = k.id
      LEFT JOIN dompet d ON t.dompet_id = d.id
      ORDER BY t.tanggal DESC
      LIMIT ?
    ''',
      [limit],
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransaksiAsMap() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        t.*,
        k.nama as kategori_nama,
        k.tipe as kategori_tipe,
        d.nama as dompet_nama
      FROM transaksi t
      LEFT JOIN kategori k ON t.kategori_id = k.id
      LEFT JOIN dompet d ON t.dompet_id = d.id
      ORDER BY t.tanggal DESC
    ''');
  }

  Future<List<Transaksi>> getAllTransaksiList() async {
    final maps = await getAllTransaksiAsMap();

    return maps.map((map) => Transaksi.fromMap(map)).toList();
  }

  Future<bool> updateTransaksiById({
    required int id,
    required int jumlahBaru,
    required String kategoriBaru,
    required String deskripsiBaru,
    required String tipe,
    required int dompetId,
  }) async {
    final db = await instance.database;

    try {
      await db.transaction((txn) async {
        // Ambil transaksi lama
        final oldTransaksi = await txn.query(
          'transaksi',
          where: 'id = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (oldTransaksi.isEmpty) {
          throw Exception("Transaksi tidak ditemukan");
        }

        final oldData = oldTransaksi.first;
        final int jumlahLama = oldData['jumlah'] as int;
        final String tipeLama = oldData['tipe'] as String;
        final int dompetLamaId = oldData['dompet_id'] as int;

        // Kembalikan saldo ke dompet lama
        final int saldoReversal =
            tipeLama == 'INCOME' ? -jumlahLama : jumlahLama;
        await txn.rawUpdate(
          'UPDATE dompet SET saldo = saldo + ? WHERE id = ?',
          [saldoReversal, dompetLamaId],
        );

        // Cek apakah dompet baru ada (jika berbeda dari dompet lama)
        if (dompetId != dompetLamaId) {
          final dompetBaru = await txn.query(
            'dompet',
            where: 'id = ?',
            whereArgs: [dompetId],
            limit: 1,
          );
          if (dompetBaru.isEmpty) {
            throw Exception("Dompet tujuan tidak ditemukan");
          }
        }

        // Ambil kategori_id baru
        final kategoriResult = await txn.query(
          'kategori',
          where: 'nama = ?',
          whereArgs: [kategoriBaru],
          limit: 1,
        );
        if (kategoriResult.isEmpty) throw Exception("Kategori tidak ditemukan");
        final kategoriIdBaru = kategoriResult.first['id'] as int;

        // Update transaksi
        await txn.update(
          'transaksi',
          {
            'jumlah': jumlahBaru,
            'kategori_id': kategoriIdBaru,
            'deskripsi': deskripsiBaru,
            'tipe': tipe,
            'tanggal': DateTime.now().toIso8601String(),
            'dompet_id': dompetId, // Dompet bisa berubah
          },
          where: 'id = ?',
          whereArgs: [id],
        );

        // Update saldo dompet baru (bisa sama atau berbeda dari dompet lama)
        final int saldoBaru = tipe == 'INCOME' ? jumlahBaru : -jumlahBaru;
        await txn.rawUpdate(
          'UPDATE dompet SET saldo = saldo + ? WHERE id = ?',
          [saldoBaru, dompetId],
        );
      });

      return true;
    } catch (e) {
      print('❌ Error saat update transaksi: $e');
      return false;
    }
  }

  Future<bool> deleteTransaksi(int id) async {
    final db = await instance.database;
    try {
      await db.transaction((txn) async {
        // 1. Ambil data transaksi yang akan dihapus untuk mengetahui jumlah, tipe, dan dompetnya
        final oldTransaksi = await txn.query(
          'transaksi',
          where: 'id = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (oldTransaksi.isEmpty) {
          throw Exception("Transaksi dengan ID $id tidak ditemukan.");
        }

        final oldData = oldTransaksi.first;
        final int jumlahLama = oldData['jumlah'] as int;
        final String tipeLama = oldData['tipe'] as String;
        final int dompetId = oldData['dompet_id'] as int;

        // 2. Kembalikan saldo dompet. Jika INCOME dihapus, saldo berkurang. Jika EXPENSE dihapus, saldo bertambah.
        final int saldoReversal =
            tipeLama == 'INCOME' ? -jumlahLama : jumlahLama;
        await txn.rawUpdate(
          'UPDATE dompet SET saldo = saldo + ? WHERE id = ?',
          [saldoReversal, dompetId],
        );

        // 3. Hapus transaksi itu sendiri
        await txn.delete('transaksi', where: 'id = ?', whereArgs: [id]);
      });
      return true;
    } catch (e) {
      print('❌ Error saat menghapus transaksi: $e');
      return false;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
