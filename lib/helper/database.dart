import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DB {
  static const String playerTable = 'player_table';
  static const String seasonTable = 'season_table';

  static Future<sql.Database> getDataBase() async {
    String rawPath = await sql.getDatabasesPath();
    String dbPath = path.join(rawPath, 'userDataBase1');
    return sql.openDatabase(dbPath, onCreate: (db, v) async {
      await db.execute(
          'CREATE TABLE $playerTable(id TEXT PRIMARY KEY,playerName TEXT,timePlayed INTEGER,gamePlayed INTEGER,gameWon INTEGER,gameLost INTEGER,createdDate TEXT,imagePath TEXT)');
      return db.execute(
          'CREATE TABLE $seasonTable(id TEXT RIMARY KEY,startTime TEXT,endTime TEXT,matchPlayed TEXT)');
    }, version: 1);
  }

  static Future addPlayer(Map<String, Object> data) async {
    final db = await getDataBase();
    db.insert(playerTable, data);
  }

  static Future<List<Map<String, Object?>>> readPlayersData() async {
    final db = await getDataBase();
    return db.query(playerTable);
  }

  static Future updatePlayerData(String id, Map<String, dynamic> values) async {
    final db = await getDataBase();
    db.update(playerTable, values, where: "id=?", whereArgs: [id]);
  }

  static Future addSeason(Map<String, Object> data) async {
    final db = await getDataBase();
    db.insert(seasonTable, data);
  }

  static Future<List<Map<String, dynamic>>> readSeasonsData() async {
    final db = await getDataBase();
    return db.query(seasonTable);
  }
}
