// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../helper/database.dart';

class PlayerProvider with ChangeNotifier {
  //this supposed to load players from database later
  bool shouldReadDataBase = true;
  List<Player> _players = [];

  //at first run copy this list with real database players
  List<Player> _seasonPlayers = [];

  List<Player> get seasonPlayers {
    return _seasonPlayers;
  }

  List<Player> get players {
    return _players;
  }

  void resetSeasonPlayers() {
    _seasonPlayers = [];
  }

  Future addDataBasePlayer(
      {required String name,
      required String id,
      required String imagePath}) async {
    //save player for database
    final player = Player(
      image: null,
      name: name,
      gamePlayed: 0,
      totalLost: 0,
      totalWins: 0,
      timePlayed: 0,
      id: id,
      createDate: DateTime.now(),
    );
    try {
      DB.addPlayer({
        'imagePath': imagePath,
        'id': id,
        'playerName': name,
        'gamePlayed': player.gamePlayed,
        'gameWon': player.totalWins,
        'gameLost': player.totalLost,
        'createdDate': player.createDate!.toIso8601String(),
        'timePlayed': 0,
      });
      _players.add(player);
      shouldReadDataBase = true;
      _seasonPlayers = [];

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future readDataBasePlayers([bool requesteReload = false]) async {
    if (shouldReadDataBase || requesteReload) {
      List<Player> savedPlayers = [];
      List<Map<String, dynamic>> temp = await DB.readPlayersData();
      temp.forEach((element) {
        Player p = Player(
            image: File(element['imagePath']),
            name: element['playerName']!,
            timePlayed: element['timePlayed'],
            gamePlayed: element['gamePlayed'],
            totalLost: element['gameLost'],
            totalWins: element['gameWon'],
            id: element['id'],
            createDate: DateTime.parse(
              element['createdDate'],
            ));
        savedPlayers.add(p);
      });
      _players = savedPlayers;
      shouldReadDataBase = false;
    }
  }

  Future incraseGamePlayedNumber(
      Player player, bool isWinner, matchTime) async {
    final players = await DB.readPlayersData();
    var targtedPlayer = players.firstWhere((p) => p['id'] == player.id);
    int oldGames = targtedPlayer['gamePlayed'] as int;
    int oldWins = targtedPlayer['gameWon'] as int;
    int oldLost = targtedPlayer['gameLost'] as int;
    int oldTimePlayed = targtedPlayer['timePlayed'] as int;
    DB.updatePlayerData(player.id, {
      'timePlayed': oldTimePlayed + matchTime,
      'gamePlayed': oldGames + 1,
      'gameWon': isWinner ? oldWins + 1 : oldWins,
      'gameLost': isWinner ? oldLost : oldLost + 1,
    });
  }

  Future updateDataBasePlayer(String id, Map<String, dynamic> values) async {
    try {
      DB.updatePlayerData(id, values);
    } catch (e) {
      // print(e);
    }
  }

  addSeasonPlayer(String id) async {
    final player = _players.firstWhere((p) => p.id == id);
    try {
      _seasonPlayers.add(player);

      _players.remove(player);
      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  removePlayerSeason(String id) async {
    final Player p = _seasonPlayers.firstWhere((player) => player.id == id);
    _seasonPlayers.remove(p);
    _players.add(p);
    notifyListeners();
  }
}
