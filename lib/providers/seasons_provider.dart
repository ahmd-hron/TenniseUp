// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/season.dart';
import '../models/player.dart';
import '../models/match.dart';

import 'season_statistic.dart';

import '../helper/database.dart';

class SeasonProvider extends SeasonStatistic with ChangeNotifier {
  //this should be loaded from storage database
  List<Season> _seasons = [];
  List<Match> tempMatches = [];
  DateTime? startTime;

  bool _playedSeasonBefore = false;

  bool get playedSeasonBefore {
    return _playedSeasonBefore;
  }

  List<Season> get seasons {
    return _seasons;
  }

  void startSeason() {
    startTime = DateTime.now();
  }

  Future addSeason(
      List<Player> seasonPlayers, List<Match> matches, DateTime endTime) async {
    tempMatches = matches;
    Season s = Season(
      id: DateTime.now().toString(),
      startTime: startTime!,
      endTime: endTime,
      matches: tempMatches,
    );

    try {
      saveSessonToDataBase(s);
      _seasons.add(s);
      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  String seasonLenght(Season season) {
    final hour = (season.startTime.difference(season.endTime).inHours).abs();
    int minutes = season.startTime.difference(season.endTime).inMinutes.abs();
    if (minutes > 60) {
      minutes = minutes % 60;
    }
    return '$hour h ${minutes}m';
  }

  //under test
  void saveSessonToDataBase(Season s) {
    try {
      List<String> matches = [];
      s.matches.forEach((match) {
        List<String> players = [];
        int timeInSeconds = match.timeInSeconds;
        List<String> playersSetsData = [];

        match.players.forEach((player) {
          String playerData = json.encode({
            'id': player.id,
            'name': player.name,
            'createdTime': player.createDate!.toIso8601String(),
            'gamePlayed': player.gamePlayed,
            'totalWins': player.totalWins,
            'totalLost': player.totalLost
          });
          players.add(playerData);
        });

        //encoding everyplayer Set
        // print('trying the value of sets before saveing the season');
        // print('this is how much sets keys we have ${match.sets.keys.length}');
        for (var i = 0; i < match.sets.keys.length; i++) {
          List<Player> players = match.sets.keys.toList();
          int playerSets = match.sets[players[i]]!;
          String data = json.encode({'sets': playerSets});
          playersSetsData.add(data);
        }

        //encoding the winner data
        String winnerPlayer = json.encode({
          'id': match.winner.id,
          'name': match.winner.name,
          'createdTime': match.winner.createDate!.toIso8601String(),
          'gamePlayed': match.winner.gamePlayed,
          'totalWins': match.winner.totalWins,
          'totalLost': match.winner.totalLost
        });

        //encoding match data
        String matchData = json.encode({
          'timeInSeconds': timeInSeconds,
          'id': match.id,
          'startTime': match.startTime.toIso8601String(),
          'endTime': match.endTime.toIso8601String(),
          'playerList': players,
          'playersSets': playersSetsData,
          'winner': winnerPlayer,
        });
        matches.add(matchData);
      });

      //undertest
      try {
        DB.addSeason({
          'startTime': s.startTime.toIso8601String(),
          'matchPlayed': json.encode(matches),
          'id': s.id,
          'endTime': s.endTime.toIso8601String(),
        });
      } catch (e) {
        // print(e);
      }
    } catch (e) {
      // print('couldn\'t save because $e');
    }
  }

  Future<Season> fetchLastSeason() async {
    try {
      await loadSeasonData();
    } catch (e) {
      // print(e);
    }
    _playedSeasonBefore = _seasons.isNotEmpty;
    return _seasons.last;
  }

  Future loadSeasonData() async {
    List<Season> seasons = [];
    List<Map<String, dynamic>> data = await DB.readSeasonsData();

    data.forEach(
      (savedData) {
        List<Match> matchesData = [];

        List<dynamic> savedMatches = json.decode(savedData['matchPlayed']);
        savedMatches.forEach(
          (encodedMatch) {
            int timeInSeconds = json.decode(encodedMatch)['timeInSeconds'];
            Map<String, dynamic> matchData = json.decode(encodedMatch);
            Map<String, dynamic> decodedWInner =
                json.decode(matchData['winner']);
            List<dynamic> encodedPlayersList = matchData['playerList'];
            List<Player> pl = loadMatchPlayers(encodedPlayersList);

            List<dynamic> encodedPlayersSets = matchData['playersSets'];

            Player winner = loadMatchWinner(decodedWInner);

            matchesData.add(
              loadMatch(
                matchData,
                pl,
                SeasonStatistic.loadMatchPlayersPoints(pl),
                loadMatchPlayerSets(encodedPlayersSets, pl),
                winner,
                timeInSeconds,
              ),
            );
          },
        );

        seasons.add(leadTheSeason(savedData, matchesData));
      },
    );
    _seasons = seasons;
  }

  Season leadTheSeason(
      Map<String, dynamic> savedData, List<Match> matchesData) {
    return Season(
      id: savedData['id'],
      startTime: DateTime.parse(savedData['startTime']),
      endTime: DateTime.parse(savedData['endTime']),
      matches: matchesData,
    );
  }

  Match loadMatch(
      Map<String, dynamic> matchData,
      List<Player> pl,
      Map<Player, int> points,
      Map<Player, int> sets,
      Player winner,
      int timeInSecond) {
    return Match(
      timeInSeconds: timeInSecond,
      id: matchData['id'],
      startTime: DateTime.parse(matchData['startTime']),
      endTime: DateTime.parse(matchData['endTime']),
      players: pl,
      points: points,
      sets: sets,
      winner: winner,
    );
  }

  Player loadMatchWinner(Map<String, dynamic> decodedWInner) {
    return Player(
      image: null,
      name: decodedWInner['name'],
      gamePlayed: decodedWInner['gamePlayed'],
      totalLost: decodedWInner['totalLost'],
      totalWins: decodedWInner['totalWins'],
      id: decodedWInner['id'],
    );
  }

  List<Player> loadMatchPlayers(List<dynamic> data) {
    List<Player> decodedPlayers = [];
    data.forEach((player) {
      Map<String, dynamic> playerData = json.decode(player);
      Player decodedPlayer = Player(
          image: null,
          name: playerData['name'],
          gamePlayed: playerData['gamePlayed'],
          totalLost: playerData['totalLost'],
          totalWins: playerData['totalWins'],
          id: playerData['id']);
      decodedPlayers.add(decodedPlayer);
    });

    return decodedPlayers;
  }

  Map<Player, int> loadMatchPlayerSets(
      List<dynamic> data, List<Player> players) {
    try {
      Map<Player, int> sets = {};
      for (var i = 0; i < players.length; i++) {
        Map<String, dynamic> savedSets = json.decode(data[i]);
        sets[players[i]] = savedSets['sets'];
      }
      return sets;
    } catch (e) {
      // print(e);
      // print('found error while fetching sets...');
      return {};
    }
  }
}
