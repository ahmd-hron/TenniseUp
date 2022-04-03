import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tennis_scoreboard/providers/players_provider.dart';

import './player_view.dart';

class PlayersListView extends StatelessWidget {
  const PlayersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playersProv = Provider.of<PlayerProvider>(context);
    return FutureBuilder(
      future: playersProv.readDataBasePlayers(true),
      builder: (ctx, snapShot) =>
          snapShot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, right: 20, left: 20),
                  child: playersProv.players.isEmpty
                      ? const Center(child: Text('Players record are empty ..'))
                      : ListView(
                          children: playersProv.players
                              .map((player) => PlayerView(player: player))
                              .toList(),
                        ),
                ),
    );
  }
}
