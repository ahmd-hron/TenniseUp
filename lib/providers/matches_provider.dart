// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:math';
import 'package:flutter/foundation.dart';
// import 'package:tennis_scoreboard/helper/database.dart';
import '../models/match.dart';
import '../models/player.dart';

class MatchProvider with ChangeNotifier {
  List<Match> _matches = [];
  List<Player> matchPlayers = [];
  DateTime matchStartTime = DateTime.now();
  Map<Player, int> matchPoints = {};
  Map<Player, int> matchsets = {};

  List<Match> get matches {
    return _matches;
  }

  void startMatch() {
    matchStartTime = DateTime.now();
  }

  void selectPlayer(String id, List<Player> seasonPlayers) {
    Player p = seasonPlayers.firstWhere((p) => p.id == id);
    try {
      if (matchPlayers.contains(p)) {
        return;
      }
      matchPlayers.add(p);
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  void removePlayer(String id) {
    Player p = matchPlayers.firstWhere((p) => p.id == id);
    matchPlayers.remove(p);
  }

  void endMatch(List<Player> players, Map<Player, int> points,
      Map<Player, int> sets, Player winner,
      {required int timeInSeconds}) {
    final m = Match(
      timeInSeconds: timeInSeconds,
      id: DateTime.now().toString(),
      startTime: matchStartTime,
      endTime: DateTime.now(),
      players: players,
      winner: winner,
      points: points,
      sets: sets,
    );
    try {
      _matches.add(m);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void addPoint(Player p, int point) {
    matchPoints.putIfAbsent(p, () => point);
    notifyListeners();
  }

  void addSet(Player p, int set) {
    matchsets.putIfAbsent(p, () => set);
    notifyListeners();
  }

  void clearMatches() {
    _matches = [];
  }

  void clearPlayers() {
    matchPlayers = [];
  }

  bool gameIsOver(int maxSets) {
    bool matchConcludet = false;
    matchPlayers.forEach((p) {
      if (p.currentSets >= maxSets) {
        matchConcludet = true;
      }
    });
    return matchConcludet;
  }

  int getTotalPoints(String id, Player p) {
    final m = matches.firstWhere((m) => m.id == id);
    int total = 0;
    m.points.forEach((key, value) {
      if (key.id == p.id) {
        total += value;
      }
    });
    return total;
  }

  int getTotalSets(String id, Player p) {
    final m = matches.firstWhere((m) => m.id == id);
    int total = 0;
    m.sets.forEach((key, value) {
      if (key.id == p.id) {
        total += value;
      }
    });
    return total;
  }

  void updatePlayerMatchState(Player player) {
    int total = 0;
    matches.forEach((match) {
      if (match.winner.id == player.id) {
        total++;
      }
    });
    player.seasonWins = total;
  }

  void randomizeServe() {
    if (matchPlayers.length < 2) return;
    matchPlayers[0].switchServe(false);
    matchPlayers[1].switchServe(false);
    final random = Random();
    const double randomFactor = 0.5;
    double randomvalue = random.nextDouble();
    randomvalue > randomFactor
        ? matchPlayers[0].shouldServe = true
        : matchPlayers[1].shouldServe = true;
  }
}
