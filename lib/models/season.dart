import './match.dart';

class Season {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<Match> matches;
  Season({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.matches,
  });
}
