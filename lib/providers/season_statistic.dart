// ignore_for_file: avoid_function_literals_in_foreach_calls

import '../models/season.dart';
import '../models/player.dart';

class SeasonStatistic {
  static Map<Player, int> loadMatchPlayersPoints(List<Player> players) {
    Map<Player, int> points = {};
    for (var i = 0; i < players.length; i++) {
      points[players[i]] = 0;
    }
    return points;
  }

  Future<List<Player>> lastSeasonPlayers(Future<Season> fetchLastSeason) async {
    bool foundMatch = false;
    List<Player> tempPlayers = [];
    Season s = await fetchLastSeason;
    s.matches.forEach((match) {
      match.players.forEach((matchPlayer) {
        if (tempPlayers.isEmpty) tempPlayers.add(matchPlayer);
        for (var i = 0; i < tempPlayers.length; i++) {
          if (tempPlayers[i].id == matchPlayer.id) {
            foundMatch = true;
            return;
          } else {
            foundMatch = false;
          }
        }
        if (!foundMatch) tempPlayers.add(matchPlayer);
      });
    });
    return tempPlayers;
  }

  List<Player> seasonPlayers(Season s) {
    bool foundMatch = false;
    List<Player> tempPlayers = [];
    s.matches.forEach((match) {
      match.players.forEach((matchPlayer) {
        if (tempPlayers.isEmpty) tempPlayers.add(matchPlayer);
        for (var i = 0; i < tempPlayers.length; i++) {
          if (tempPlayers[i].id == matchPlayer.id) {
            foundMatch = true;
            return;
          } else {
            foundMatch = false;
          }
        }
        if (!foundMatch) tempPlayers.add(matchPlayer);
      });
    });
    return tempPlayers;
  }

  static double getSeasonWinRate(Season season, Player player) {
    int playerWins = 0;
    season.matches.forEach((match) {
      if (match.winner.id == player.id) playerWins++;
    });
    return playerWins / season.matches.length;
  }

  Map<Player, int> playersWinRate(List<Player> players, Season s) {
    Map<Player, int> winRate = {};
    for (var i = 0; i < players.length; i++) {
      winRate.putIfAbsent(players[i], () => 0);
    }
    s.matches.forEach((match) {});
    return winRate;
  }

  double playerWInrRate(Player player, Season s) {
    int n = s.matches.length;
    int totalWins = 0;
    s.matches.forEach((match) {
      if (match.winner.id == player.id) {
        totalWins++;
      }
    });
    return (totalWins / n);
  }

  int totalWins(Player player, Season season) {
    int totalWins = 0;
    season.matches.forEach((match) {
      if (match.winner.id == player.id) {
        totalWins++;
      }
    });
    return totalWins;
  }
}
