import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/models/songmodel.dart';

final String tableBands = 'bands';
final String columnBandId = 'bandId';
final String columnName = 'name';
final String columnGenre = 'genre';

final String tableSongs = 'songs';
final String columnSongId = 'songId';
final String columnTitle = 'title';
final String columnReleaseYear = 'releaseYear';
final String columnBand = 'band';

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
    await db.execute("CREATE TABLE $tableBands ("
        "$columnBandId INTEGER PRIMARY KEY,"
        "$columnName TEXT,"
        "$columnGenre TEXT)");

    await db.execute("CREATE TABLE $tableSongs ("
        "$columnSongId INTEGER PRIMARY KEY,"
        "$columnTitle TEXT,"
        "$columnReleaseYear INTEGER,"
        "$columnBand INTEGER,"
        "FOREIGN KEY ($columnBand) REFERENCES $tableBands($columnBandId))");
  }

  Future<void> createBand(Band band) async {
    final db = await instance.database;
    await db.insert(
      tableBands,
      band.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Band>> readAllBands() async {
    final db = await instance.database;

    final orderBy = '$columnName ASC';
    final result = await db.query(tableBands, orderBy: orderBy);

    return result.map((json) => Band.fromMap(json)).toList();
  }

  Future<int> updateBand(Band band) async {
    final db = await instance.database;

    return db.update(
      tableBands,
      band.toMap(),
      where: '$columnBandId = ?',
      whereArgs: [band.bandId],
    );
  }

  Future<int> deleteBand(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableBands,
      where: '$columnBandId = ?',
      whereArgs: [id],
    );
  }

  Future<void> createSong(Song song) async {
    final db = await instance.database;
    await db.insert(
      tableSongs,
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> readAllSongs() async {
    final db = await instance.database;

    final orderBy = '$columnTitle ASC';
    final result = await db.query(tableSongs, orderBy: orderBy);

    return result.map((json) => Song.fromMap(json)).toList();
  }

  Future<int> updateSong(Song song) async {
    final db = await instance.database;

    return db.update(
      tableSongs,
      song.toMap(),
      where: '$columnSongId = ?',
      whereArgs: [song.songId],
    );
  }

  Future<int> deleteSong(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSongs,
      where: '$columnSongId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Song>> getSongsByBandId(int bandId) async {
    final db = await database;
    final songs = await db.query(
      tableSongs,
      where: '$bandId = ?',
      whereArgs: [bandId],
    );
    return List.generate(songs.length, (i) {
      return Song.fromMap(songs[i]);
    });
  }
}
