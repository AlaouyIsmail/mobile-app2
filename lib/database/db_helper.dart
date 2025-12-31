import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produit.dart';

class DBHelper {
  static Database? database;
  static Future<Database> initDB() async {
    if (database != null) return database!;
    String path = join(await getDatabasesPath(), 'stock.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produits(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prix REAL,
            quantite INTEGER
          )
        ''');
      },
    );
    return database!;
  }

  static Future<void> insert(Produit produit) async {
    final db = await initDB();
    await db.insert('produits', produit.toMap());
  }

  static Future<List<Produit>> getAll() async {
    final db = await initDB();
    final data = await db.query('produits');
    return data.map((e) => Produit.fromMap(e)).toList();
  }

  static Future<void> update(Produit produit) async {
    final db = await initDB();
    await db.update(
      'produits',
      produit.toMap(),
      where: 'id = ?',
      whereArgs: [produit.id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await initDB();
    await db.delete(
      'produits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
