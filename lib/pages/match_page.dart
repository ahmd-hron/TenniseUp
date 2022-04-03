// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_scoreboard/helper/methods.dart';
import 'package:tennis_scoreboard/widgets/player_picture.dart';

import '../providers/matches_provider.dart';
import '../providers/players_provider.dart';
import '../providers/user_data_provider.dart';

import '../models/player.dart';
import '../widgets/match/timer.dart' as w;

class MatchPage extends StatefulWidget {
  static const String routeName = '/matchPage';
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int firsPlayerScore = 0;
  int secondPlayerScore = 0;
  int timeInSeconds = 0;
  bool gameOver = false;
  Player? matchWinner;
  bool faul = false;
  int faulCounter = 0;
  final timerKey = const ValueKey('timer');

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context, listen: false).readUserDataSets();
  }

  @override
  Widget build(BuildContext context) {
    final playerProv = Provider.of<PlayerProvider>(context);
    final matchProv = Provider.of<MatchProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        bool? resoults = await finishMatchDialog(matchProv, playerProv);
        resoults ?? false;
        return resoults!;
      },
      child: Scaffold(
        appBar: _buildAppBar(matchProv, playerProv),
        body: buildBody(matchProv),
        floatingActionButton: FloatingActionButton(
          child: const Text(
            'Faul',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () => setState(
            () {
              if (gameOver) {
                _gameOverDialog();
                return;
              }
              _addFaul(matchProv);
            },
          ),
          backgroundColor: Theme.of(context).errorColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  AppBar _buildAppBar(MatchProvider matchProv, PlayerProvider playerProv) {
    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Center(
        child: gameOver == true
            ? const Text('Game is over')
            : SizedBox(
                height: 80,
                width: 98,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: w.Timer(
                    key: timerKey,
                    providTime: _updateTime,
                    stopTimer: false,
                    backGroundColor: Colors.green,
                    primaryColor: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  Future<bool?> finishMatchDialog(
      MatchProvider matchProv, PlayerProvider playerProv) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveMatch(matchProv, playerProv);
              return Navigator.of(context).pop(true);
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Save and exite',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelMedium!.color),
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () {
              _cancelMatch(matchProv);
              return Navigator.of(context).pop(true);
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Exite without saving',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelMedium!.color),
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () {
              return Navigator.of(context).pop(false);
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelMedium!.color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody(MatchProvider matchProv) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (faul)
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5),
            child: Text(
              'Faul',
              style: TextStyle(fontSize: 28),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.025),
        ),
        buildPlayerScore(
          matchProv: matchProv,
          playerName: HelperMethods.capitalName(matchProv.matchPlayers[0].name),
          playerScore: matchProv.matchPlayers[0].currentScore,
          playerSets: matchProv.matchPlayers[0].currentSets,
          player: matchProv.matchPlayers[0],
          otherPlayer: matchProv.matchPlayers[1],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.025),
        ),
        buildPlayerScore(
          matchProv: matchProv,
          playerName: HelperMethods.capitalName(matchProv.matchPlayers[1].name),
          playerScore: matchProv.matchPlayers[1].currentScore,
          playerSets: matchProv.matchPlayers[1].currentSets,
          player: matchProv.matchPlayers[1],
          otherPlayer: matchProv.matchPlayers[0],
        ),
      ],
    );
  }

  Widget buildPlayerScore({
    required MatchProvider matchProv,
    required String playerName,
    required int playerScore,
    required int playerSets,
    required Player player,
    required Player otherPlayer,
  }) {
    bool isServing = player.shouldServe;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //player name and score set
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(children: [
                Text(
                  playerName,
                  style: TextStyle(
                      color: isServing
                          ? Colors.white
                          : Colors.white.withOpacity(0.20)),
                ),
                if (isServing)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.sports_tennis),
                  ),
              ]),
            ),
            const Spacer(),
            Row(
              children: blueCircle(playerSets),
            ),
          ],
        ),
        //player reqtangule with player score
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.07,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                //player Picture
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: PlayerPicture(
                  image: player.image,
                  radius: 38,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Points',
                    style: TextStyle(fontSize: 25),
                  ),
                  IconButton(
                      onPressed: () {
                        if (gameOver) {
                          _gameOverDialog();
                          return;
                        }
                        setState(() {
                          player.addPoint(playerScore, otherPlayer);
                          faul = false;
                          faulCounter = 0;
                        });
                        _checkIfgameIsOver(matchProv);
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 40,
                      ))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playerScore == 41 ? 'AD' : '$playerScore',
                    style: const TextStyle(fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      if (gameOver) {
                        _gameOverDialog();
                        return;
                      }
                      setState(() {
                        player.removePoint(playerScore, otherPlayer);
                        faul = false;
                        faulCounter = 0;
                      });
                    },
                    icon: const Icon(
                      Icons.remove,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> blueCircle(int sets) {
    List<Widget> wl = [];
    for (var i = 0; i < sets; i++) {
      wl.add(
        Container(
          margin: const EdgeInsets.only(right: 15),
          width: 15,
          height: 15,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        ),
      );
    }
    return wl;
  }

  Player? _findTheWinner(List<Player> matchPlayers) {
    int sets = 0;
    for (var i = 0; i < matchPlayers.length; i++) {
      if (matchPlayers[i].currentSets > i) {
        sets = matchPlayers[i].currentSets;
      }
    }
    matchWinner = matchPlayers.firstWhere((p) => p.currentSets == sets);
    return matchWinner;
  }

  void _updatePlayersInfo(
      PlayerProvider playersProv, List<Player> matchPlayers) {
    matchPlayers.forEach((player) {
      playersProv.incraseGamePlayedNumber(
        player,
        _isWinner(player),
        timeInSeconds,
      );
    });
  }

  bool _isWinner(Player p) {
    return p.id == matchWinner!.id;
  }

  _cancelMatch(MatchProvider matchProv) {
    Navigator.of(context).pop();
    matchProv.matchPlayers.forEach((player) {
      player.reset();
    });
    matchProv.clearPlayers();
  }

  void _addFaul(MatchProvider matchProv) {
    faulCounter++;
    if (gameOver) {
      _gameOverDialog();
      return;
    }

    if (faulCounter == 2) {
      Player fauledPlayer = matchProv.matchPlayers
          .firstWhere((player) => player.shouldServe == true);
      Player otherPlayer = matchProv.matchPlayers
          .firstWhere((player) => fauledPlayer.id != player.id);
      setState(() {
        otherPlayer.addPoint(otherPlayer.currentScore, fauledPlayer);
        faul = !faul;
      });
      _checkIfgameIsOver(matchProv);
      faulCounter = 0;
      return;
    }

    setState(() {
      faul = !faul;
    });
  }

  void _checkIfgameIsOver(MatchProvider matchProv) {
    gameOver = matchProv.gameIsOver(
        Provider.of<UserDataProvider>(context, listen: false).setsForTheWin);
  }

  void _gameOverDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('game is already over'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('okay'),
          )
        ],
      ),
    );
  }

  Future _saveMatch(MatchProvider matchProv, PlayerProvider playerProv) async {
    matchProv.endMatch(
        matchProv.matchPlayers,
        {
          matchProv.matchPlayers[0]: matchProv.matchPlayers[0].currentScore,
          matchProv.matchPlayers[1]: matchProv.matchPlayers[1].currentScore,
        },
        {
          matchProv.matchPlayers[0]: matchProv.matchPlayers[0].currentSets,
          matchProv.matchPlayers[1]: matchProv.matchPlayers[1].currentSets,
        },
        _findTheWinner(matchProv.matchPlayers)!,
        timeInSeconds: timeInSeconds);
    _updatePlayersInfo(playerProv, matchProv.matchPlayers);
    matchProv.matchPlayers.forEach((player) {
      player.reset();
    });
    Future.delayed(const Duration(milliseconds: 200)).then(
      (value) => matchProv.clearPlayers(),
    );
  }

  void _updateTime(int s) {
    timeInSeconds = s;
  }
}
