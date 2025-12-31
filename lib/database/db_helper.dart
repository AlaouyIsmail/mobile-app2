import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produit.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Obtient le chemin d'accès à la base de données.
    String path = join(await getDatabasesPath(), 'stock_database.db');

    // Ouvre la DB et crée la table si elle n'existe pas.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Création de la table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prix REAL,
        quantite INTEGER
      )
    ''');
  }

  // 1. Ajouter un produit (CREATE)
  Future<void> insertProduit(Produit produit) async {
    final db = await database;
    await db.insert(
      'produits',
      produit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. Afficher les produits (READ)
  Future<List<Produit>> getProduits() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('produits');

    // Convertit la List<Map<String, dynamic>> en List<Produit>
    return List.generate(maps.length, (i) {
      return Produit.fromMap(maps[i]);
    });
  }

  // 3. Modifier un produit (UPDATE)
  Future<void> updateProduit(Produit produit) async {
    final db = await database;

    await db.update(
      'produits',
      produit.toMap(),
      where: 'id = ?',
      whereArgs: [produit.id],
    );
  }

  // 4. Supprimer un produit (DELETE)
  Future<void> deleteProduit(int id) async {
    final db = await database;
    await db.delete(
      'produits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}