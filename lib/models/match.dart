import './player.dart';

class Match {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<Player> players;
  final Map<Player, int> points;
  final Map<Player, int> sets;
  final Player winner;
  final int timeInSeconds;

  Match({
    required this.timeInSeconds,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.players,
    required this.points,
    required this.sets,
    required this.winner,
  });
}
