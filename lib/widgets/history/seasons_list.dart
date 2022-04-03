import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../providers/seasons_provider.dart';
import '../../models/season.dart';
import '../../models/player.dart';
import '../../models/oppacity_text.dart';
import '../../models/match.dart';

class SeasonsList extends StatelessWidget {
  const SeasonsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seasonProv = Provider.of<SeasonProvider>(context);
    return _buildSeasonsList(seasonProv, context);
  }

  Widget _buildSeasonsList(SeasonProvider seasonProv, BuildContext ctx) {
    return seasonProv.seasons.isEmpty
        ? const Center(
            child: Text('season records are empty ..'),
          )
        : ListView(
            children: seasonProv.seasons.reversed
                .map((season) => _seasonContainer(ctx, seasonProv, season))
                .toList(),
          );
  }

  Widget _seasonContainer(
      BuildContext ctx, SeasonProvider seasonProv, Season season) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 20),
      child: Column(
        children: [
          //day and date
          _buildDateRow(season.startTime),
          //seasson details
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            height: 182,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.07),
            ),
            child: Column(
              children: [
                _buildInfoRow('games', '${season.matches.length}'),
                _playersAndWidRateColumn(seasonProv, season),
                _buildInfoRow('Season Time', seasonProv.seasonLenght(season)),
                _showMoreText(ctx, season),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(DateTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(DateFormat('E').format(time)),
        //date of the seasson
        Text(DateFormat('d/M/yyy').format((time)))
      ],
    );
  }

  Widget _buildInfoRow(String plainText, String infoText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(plainText),
        Text(
          infoText,
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        )
      ],
    );
  }

  Widget _playersAndWidRateColumn(SeasonProvider seasonProv, Season season) {
    List<Player> players = seasonProv.seasonPlayers(season);
    List<double> playersWinRate = [];

    for (var i = 0; i < players.length; i++) {
      playersWinRate.add(seasonProv.playerWInrRate(players[i], season));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //need players and winRates
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Players'),
                  _valuesRow(players, true, BoxFit.contain),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 1)),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('WR'),
                  _valuesRow(playersWinRate, false, BoxFit.scaleDown),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valuesRow(List list, bool shouldShowNames, BoxFit fit) {
    return SizedBox(
      width: 200,
      child: list.length > 4
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _valuesRowChildrens(list, shouldShowNames, fit),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _valuesRowChildrens(list, shouldShowNames, fit),
            ),
    );
  }

  List<Widget> _valuesRowChildrens(
      List list, bool shouldShowNames, BoxFit fit) {
    return list
        .map(
          (listValue) => SizedBox(
            width: 40,
            child: FittedBox(
              fit: fit,
              child: Text(
                shouldShowNames
                    ? listValue.name
                    : '${(listValue * 100).round()}%',
                style: const OppacityText(0.5),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _showMoreText(BuildContext ctx, Season season) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 3),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          child: Text(
            'Click to view match history',
            style: TextStyle(
              color: Theme.of(ctx).textTheme.labelMedium!.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => _showmatchListDialog(ctx, season)
          //should show match hisory fot this season,
          ,
        ),
      ),
    );
  }

  void _showmatchListDialog(BuildContext ctx, Season season) {
    showDialog(
      context: ctx,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Dialog(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.black,
          child: _matchList(ctx, season),
        ),
      ),
    );
  }

  Widget _matchList(BuildContext context, Season season) {
    double height = season.matches.length < 5
        ? season.matches.length * (MediaQuery.of(context).size.height * 0.14)
        : MediaQuery.of(context).size.height * 0.8;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      height: height,
      child: ListView(
        children: matchesList(context, season),
      ),
    );
  }

  List<Widget> matchesList(BuildContext context, Season season) {
    List<Widget> widgetList = [];
    for (var i = 0; i < season.matches.length; i++) {
      widgetList.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: i % 2 == 0
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.10),
        ),
        height: MediaQuery.of(context).size.height * 0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(season.matches[i].winner.name),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${season.matches[i].timeInSeconds ~/ 60} min',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${winnerSets(season.matches[i])} - ${loserSets(season.matches[i])}',
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.labelMedium!.color),
              ),
            ]),
            Text(loserName(season.matches[i])),
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

  int winnerSets(Match m) {
    int index = m.sets.keys.toList().indexWhere((k) => k.id == m.winner.id);
    int sets = m.sets.values.toList()[index];
    return sets;
  }

  int loserSets(Match m) {
    int index = m.sets.keys.toList().indexWhere((k) => k.id != m.winner.id);
    int sets = m.sets.values.toList()[index];
    return sets;
  }

  String loserName(Match m) {
    return m.players.firstWhere((p) => p.id != m.winner.id).name;
  }
}
