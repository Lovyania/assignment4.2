import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assignment_4_2/models/bandmodel.dart';

final String tableBands = 'bands';
final String columnId = 'id';
final String columnName = 'name';
final String columnGenre = 'genre';

class BandsDatabase {
  static final BandsDatabase instance = BandsDatabase._init();

  static Database? _database;

  BandsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bands.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE bands ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "genre TEXT)");
  }

  Future<void> create(Band band) async {
    final db = await instance.database;
    await db.insert(
      tableBands,
      {...band.toMap(), columnId: band.id}, // Add the id column to the map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Band>> readAll() async {
    final db = await instance.database;

    final orderBy = '$columnName ASC';
    final result = await db.query(tableBands, orderBy: orderBy);

    return result.map((json) => Band.fromMap(json)).toList();
  }

  Future<int> update(Band band) async {
    final db = await instance.database;

    return db.update(
      tableBands,
      band.toMap(),
      where: '$columnId = ?',
      whereArgs: [band.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableBands,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
