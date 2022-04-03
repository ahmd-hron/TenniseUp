import 'package:flutter/material.dart';

import '../player_picture.dart';

import '../../providers/matches_provider.dart';

class MatchHistoryList extends StatelessWidget {
  const MatchHistoryList({required this.matchProvider, Key? key})
      : super(key: key);
  final MatchProvider matchProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.44,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: 10,
        ),
        child: ListView(
          children: matchesList(matchProvider, context),
        ),
      ),
    );
  }

  List<Widget> matchesList(MatchProvider matchesProv, BuildContext context) {
    List<Widget> widgetList = [];
    for (var i = 0; i < matchesProv.matches.length; i++) {
      final m = matchesProv.matches[i];
      widgetList.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: i % 2 == 0
              ? Colors.white.withOpacity(0.07)
              : Colors.white.withOpacity(0.03),
        ),
        height: MediaQuery.of(context).size.height * 0.16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PlayerPicture(
              image: m.players[0].image,
              radius: 35,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Text(
                  '${m.timeInSeconds ~/ 60} min',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '${matchesProv.getTotalSets(m.id, m.players[0])} - ${matchesProv.getTotalSets(m.id, m.players[1])}',
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.labelMedium!.color),
              ),
            ]),
            PlayerPicture(
              image: m.players[1].image,
              radius: 35,
            ),
          ],
        ),
      ));
    }
    if (widgetList.isEmpty) {
      widgetList.add(
        const Center(
          child: Text('No match records yet '),
        ),
      );
    }
    return widgetList;
  }
}
