import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentage_circle.dart';

import '../../providers/seasons_provider.dart';
import '../../models/player.dart';
import '../../models/season.dart';

class LastSeason extends StatelessWidget {
  const LastSeason({required this.snapShot, Key? key}) : super(key: key);
  final dynamic snapShot;
  @override
  Widget build(BuildContext context) {
    final seasonsProv = Provider.of<SeasonProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.289,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
      ),
      child: !seasonsProv.playedSeasonBefore
          ? const Center(
              child: Text('No records found '),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _playerWinRateText(),
                  LastSeasonPlayers(
                    season: snapShot.data as Season,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _playerWinRateText() {
    return const SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          '   Players win rates ',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class WinRate extends StatelessWidget {
  const WinRate(
      {Key? key,
      required this.players,
      required this.season,
      required this.player})
      : super(key: key);
  final List<Player> players;
  final Player player;
  final Season season;
  @override
  Widget build(BuildContext context) {
    final seasonProv = Provider.of<SeasonProvider>(context, listen: false);
    double winRate = totalWinPresentage(seasonProv, player, season) * 100;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PresentageCircle(
              width: MediaQuery.of(context).size.width * 0.13,
              presentage: winRate / 100,
              style: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            // Text(totalWins(seasonProv, player, season).toString()),
          ],
        ),
      ),
    );
  }

  double totalWinPresentage(SeasonProvider seasonProv, Player p, Season s) {
    return seasonProv.playerWInrRate(player, s);
  }

  int totalWins(SeasonProvider seasonProv, Player p, Season s) {
    return seasonProv.totalWins(player, s);
  }
}

// ignore: must_be_immutable
class LastSeasonPlayers extends StatelessWidget {
  LastSeasonPlayers({Key? key, required this.season}) : super(key: key);
  List<Player> lastSeasonPlayers = [];
  final Season season;

  @override
  Widget build(BuildContext context) {
    final seasonsProv = Provider.of<SeasonProvider>(context);
    return FutureBuilder(
      future: seasonsProv.lastSeasonPlayers(seasonsProv.fetchLastSeason()),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          lastSeasonPlayers = snapShot.data as List<Player>;
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // foreach last season player create colun with text
                  ...lastSeasonPlayers
                      .map((player) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  player.name,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85)),
                                ),
                                WinRate(
                                  players: lastSeasonPlayers,
                                  season: season,
                                  player: player,
                                )
                              ],
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
