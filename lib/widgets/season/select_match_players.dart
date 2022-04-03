// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import '../../pages/match_page.dart';
import '../../providers/matches_provider.dart';

import '../../models/player.dart';

import '../player_picture.dart';
import '../../helper/methods.dart';

class SelectMatchPlayers extends StatefulWidget {
  final MatchProvider matchProv;
  final List<Player> seasonPlayers;
  const SelectMatchPlayers(
      {required this.matchProv, required this.seasonPlayers, Key? key})
      : super(key: key);

  @override
  State<SelectMatchPlayers> createState() => _SelectMatchPlayersState();
}

class _SelectMatchPlayersState extends State<SelectMatchPlayers> {
  Player? firstPlayer;
  Player? secondPlayer;
  String? playerServing;
  @override
  Widget build(BuildContext context) {
    if (playerServing == null) {
      widget.matchProv.randomizeServe();
    }

    return AlertDialog(
      title: const Center(child: Text('Chose Match Players')),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.72,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selectFirstPlayer(
                    widget.matchProv, widget.seasonPlayers, context),
                _selectScondPlayer(
                    widget.matchProv, widget.seasonPlayers, context)
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.03),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayerPicture(
                  image: firstPlayer == null ? null : firstPlayer!.image,
                  radius: 35,
                ),
                const Text(
                  'VS',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                PlayerPicture(
                  image: secondPlayer == null ? null : secondPlayer!.image,
                  radius: 35,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.025),
            ),
            //chose who to serve container
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Player Serving'),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                DropdownButton<String>(
                  value: playerServing,
                  onChanged: (playerName) {
                    setState(() {
                      playerServing = playerName;
                    });
                  },
                  items: [
                    ...widget.matchProv.matchPlayers
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: Text(e.name),
                            value: e.name,
                            onTap: () =>
                                widget.matchProv.matchPlayers.forEach((player) {
                              player.id == e.id
                                  ? player.switchServe(true)
                                  : player.switchServe(false);
                            }),
                          ),
                        )
                        .toList(),
                    DropdownMenuItem(
                      child: const Text('Random'),
                      onTap: () {
                        widget.matchProv.randomizeServe();
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium!.color,
              ),
            )),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _startMatch(widget.matchProv, context);
            firstPlayer = null;
            secondPlayer = null;
          },
          child: Text(
            'Confirm',
            style: TextStyle(
              color: Theme.of(context).textTheme.labelMedium!.color,
            ),
          ),
        ),
      ],
    );
  }

  DropdownButton _selectFirstPlayer(MatchProvider matchProv,
      List<Player> seasonPlayers, BuildContext context) {
    return DropdownButton<Player>(
      hint: SizedBox(
        width: MediaQuery.of(context).size.width * 0.20,
        child: FittedBox(
          child: firstPlayer == null
              ? const Text(
                  'Chose Player',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              //it dose not matter since it really on the value from dropDownMenuItem
              : null,
        ),
      ),
      value: firstPlayer,
      menuMaxHeight: 250,
      items: items(seasonPlayers, matchProv, secondPlayer),
      onChanged: (p) {
        setState(() {
          if (firstPlayer != null) {
            matchProv.removePlayer(firstPlayer!.id);
          }
          firstPlayer = Player.overridePlayer(firstPlayer, p!, seasonPlayers);
          matchProv.selectPlayer(firstPlayer!.id, seasonPlayers);
        });
      },
    );
  }

  List<DropdownMenuItem<Player>> items(
    List<Player> seasonPlayers,
    MatchProvider matchProvider,
    Player? otherPlayer,
  ) {
    final List<DropdownMenuItem<Player>> players = [];
    for (var i = 0; i < seasonPlayers.length; i++) {
      if (otherPlayer != null) {
        if (seasonPlayers[i].id == otherPlayer.id) continue;
      }
      players.add(
        DropdownMenuItem<Player>(
          child: Text(HelperMethods.capitalName(seasonPlayers[i].name)),
          value: seasonPlayers[i],
        ),
      );
    }
    return players;
  }
  /*            
seasonPlayers.map((p) {
      if(firstPlayer!=null || secondPlayer!=null){
        return null;
      }
      return DropdownMenuItem<Player>(
        child: Text(HelperMethods.capitalName(p.name)),
        value: p,
      );
    }).toList();*/

  DropdownButton _selectScondPlayer(MatchProvider matchProv,
      List<Player> seasonPlayers, BuildContext context) {
    return DropdownButton<Player>(
      hint: SizedBox(
        width: MediaQuery.of(context).size.width * 0.20,
        child: FittedBox(
          child: secondPlayer == null
              ? const Text(
                  'Chose Player',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : null,
        ),
      ),
      value: secondPlayer,
      menuMaxHeight: 250,
      items: items(seasonPlayers, matchProv, firstPlayer),
      onChanged: (p) {
        setState(() {
          if (secondPlayer != null) {
            matchProv.removePlayer(secondPlayer!.id);
          }
          secondPlayer = Player.overridePlayer(secondPlayer, p!, seasonPlayers);
          matchProv.selectPlayer(secondPlayer!.id, seasonPlayers);
        });
      },
    );
  }

  void _startMatch(MatchProvider matchProvider, BuildContext context) {
    matchProvider.startMatch();
    Navigator.of(context).pushNamed(MatchPage.routeName);
  }
}
