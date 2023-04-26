import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/models/songmodel.dart';

const String tableBands = 'bands';
const String columnBandId = 'bandId';
const String columnName = 'name';
const String columnGenre = 'genre';

const String tableSongs = 'songs';
const String columnSongId = 'songId';
const String columnTitle = 'title';
const String columnReleaseYear = 'releaseYear';
const String columnBand = 'band';

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
        "$columnBandId INTEGER,"
        "FOREIGN KEY ($columnBandId) REFERENCES $tableBands($columnBandId))");
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

    const orderBy = '$columnName ASC';
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

    const orderBy = '$columnTitle ASC';
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
    final db = await instance.database;
    final result =
        await db.query('songs', where: 'bandId = ?', whereArgs: [bandId]);
    final songs = result.map((json) => Song.fromMap(json)).toList();
    print('Songs for band $bandId: $songs');
    return songs;
  }
}
