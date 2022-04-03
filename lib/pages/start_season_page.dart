import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/players_provider.dart';
import '../providers/seasons_provider.dart';

import './season_page.dart';

import './/pages/create_player.dart';

class StartSeasonPage extends StatefulWidget {
  static const String routeName = '/start season';
  const StartSeasonPage({Key? key}) : super(key: key);

  @override
  _StartSeasonPageState createState() => _StartSeasonPageState();
}

class _StartSeasonPageState extends State<StartSeasonPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<PlayerProvider>(context, listen: false).resetSeasonPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final playerProv = Provider.of<PlayerProvider>(context);
    return Scaffold(
      floatingActionButton: floatingActionButton(playerProv),
      body: FutureBuilder(
        future: playerProv.readDataBasePlayers(),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.active
              ? const Center(child: Text('Loading'))
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 0,
                    right: 20,
                    left: 20,
                  ),
                  child: Column(children: [
                    const Text(
                      ' Season Players',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.90,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: ListView(
                                        children: seasonListViw(playerProv)),
                                  ),
                                  const Text(
                                    'Add Season Players',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  //database players
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: ListView(
                                        children: playersListView(playerProv)),
                                  ),
                                ],
                              ),
                            ),
                            startSeasonButton(playerProv),
                            //start season button
                          ]),
                    ),
                  ]),
                );
        },
      ),
    );
  }

  FloatingActionButton floatingActionButton(PlayerProvider playerProv) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).iconTheme.color,
      onPressed: () => Navigator.of(context).pushNamed(CreatePlayer.routeName),
      child: const Icon(
        Icons.group_add_rounded,
        size: 25,
      ),
    );
  }

  Widget startSeasonButton(
    PlayerProvider playerProv,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {
          //if number of players are below 2 show warning
          if (playerProv.seasonPlayers.length < 2) {
            _notEnoughSeasonPlayers();
            return;
          }
          //start season and save start time
          Provider.of<SeasonProvider>(context, listen: false).startSeason();
          Navigator.of(context).pushReplacementNamed(SeasonPage.routeName);
        },
        child: const Text('Start Season'),
      ),
    );
  }

  List<Widget> seasonListViw(PlayerProvider pp) {
    List<Widget> widgetList = [];
    for (var i = 0; i < pp.seasonPlayers.length; i++) {
      widgetList.add(
        Column(
          children: [
            Container(
              height: 40,
              color: i % 2 == 0
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(pp.seasonPlayers[i].name),
                  Text('M ${pp.seasonPlayers[i].gamePlayed.toString()}'),
                  Text('W ${pp.seasonPlayers[i].totalWins}'),
                  Text('L ${pp.seasonPlayers[i].totalLost}'),
                  IconButton(
                    onPressed: () =>
                        pp.removePlayerSeason(pp.seasonPlayers[i].id),
                    icon: Icon(
                      Icons.remove,
                      size: 12,
                      color: Theme.of(context).textTheme.labelMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            )
          ],
        ),
      );
    }
    return widgetList;
  }

  List<Widget> playersListView(PlayerProvider pp) {
    List<Widget> widgetList = [];
    for (var i = 0; i < pp.players.length; i++) {
      widgetList.add(
        Column(
          children: [
            Container(
              height: 35,
              color: i % 2 == 0
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(pp.players[i].name),
                  Text('M ${pp.players[i].gamePlayed.toString()}'),
                  Text('W ${pp.players[i].totalWins}'),
                  Text('L ${pp.players[i].totalLost}'),
                  IconButton(
                    onPressed: () => pp.addSeasonPlayer(pp.players[i].id),
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.labelMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            )
          ],
        ),
      );
    }
    return widgetList;
  }

  void _notEnoughSeasonPlayers() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text('Season Players should have atleast 2 players '),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
