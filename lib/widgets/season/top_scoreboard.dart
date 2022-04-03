import 'package:flutter/material.dart';

import '../../providers/matches_provider.dart';

import '../../models/player.dart';

class TopScoreBoard extends StatelessWidget {
  const TopScoreBoard(
      {required this.seasonPlayers, required this.matchProv, Key? key})
      : super(key: key);
  final List<Player> seasonPlayers;
  final MatchProvider matchProv;

  @override
  Widget build(BuildContext context) {
    return buildScoreBoard();
  }

  Widget buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 130,
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              border: const Border(
                  bottom: BorderSide(color: Colors.black, width: 1)),
              color: Colors.white.withOpacity(0.01),
            ),
            height: 50,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: seasonPlayers.map((p) {
                String s = p.name.substring(0, 3).toUpperCase();
                return Text(s);
              }).toList(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: const Border(
                  bottom: BorderSide(color: Colors.black, width: 1)),
              color: Colors.white.withOpacity(0.02),
            ),
            height: 50,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: seasonPlayers.map((p) {
                matchProv.updatePlayerMatchState(p);
                return Text(p.seasonWins.toString());
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
