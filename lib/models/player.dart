import 'dart:io';

class Player {
  String id;
  String name;
  DateTime? createDate;
  File? image;
  int gamePlayed;
  int totalWins;
  int totalLost;
  int timePlayed = 0;
  int seasonWins = 0;
  int currentScore = 0;
  int currentSets = 0;
  //thisvariable to reverse score to previous state
  bool shouldServe = false;
  int _tempScore = 0;
  Player({
    this.timePlayed = 0,
    required this.image,
    required this.name,
    required this.gamePlayed,
    required this.totalLost,
    required this.totalWins,
    required this.id,
    this.createDate,
  });

  //this method check for selected seasonPlayers and return the first match
  //it takes a null player and override it's value from the list of season players
  static Player overridePlayer(
      Player? current, Player newP, List<Player> seasonPlayers) {
    current = seasonPlayers.firstWhere((element) => element.id == newP.id);
    return current;
  }

  void addPoint(int myScore, Player otherPlayer) {
    _tempScore = currentScore;
    int point = myScore;
    if (myScore < 40 || otherPlayer.currentScore < 40) {
      myScore < 30
          ? point += 15
          : myScore < 40
              ? point += 10
              : myScore == 40
                  ? point = 45
                  : 0;
    } else {
      if (point == 41 && otherPlayer.currentScore == 40) {
        point = 45;
      } else if (point == 40 && otherPlayer.currentScore >= 40) {
        point = 41;
      }
    }
    if (point == 41 && otherPlayer.currentScore == 41) {
      point = 40;
      otherPlayer.currentScore = 40;
    }
    if (point == 45) {
      currentScore = 0;
      otherPlayer.currentScore = 0;
      _addSet(otherPlayer);
    } else {
      currentScore = point;
    }
  }

  void removePoint(int myScore, Player otherPlayer) {
    int points = myScore;
    //remove point
    if (currentScore != 0) {
      if (currentScore != 41 || otherPlayer.currentScore != 40) {
        currentScore == 40
            ? points = 30
            : currentScore == 30
                ? points = 15
                : points = 0;
      } else {
        if (currentScore == 41) {
          points = 40;
        }
      }
    } else if (currentSets != 0 && currentScore == 0) {
      _removeSet(otherPlayer);
      points = _tempScore;
      otherPlayer.currentScore = otherPlayer._tempScore;
    } else {
      if (currentScore == 41) {
        points = 40;
      }
    }

    currentScore = points;
  }

  void reset() {
    shouldServe = false;
    _tempScore = 0;
    currentSets = 0;
    currentScore = 0;
  }

  void switchServe(bool isServing) {
    shouldServe = isServing;
  }

  void _addSet(Player otherPlayer) {
    shouldServe = !shouldServe;
    otherPlayer.switchServe(!shouldServe);
    currentSets++;
  }

  void _removeSet(Player otherPlayer) {
    shouldServe = !shouldServe;
    otherPlayer.switchServe(!shouldServe);
    currentSets--;
  }
}
