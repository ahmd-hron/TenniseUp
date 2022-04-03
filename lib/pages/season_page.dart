import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';

import '../widgets/season/select_match_players.dart';

import '../providers/players_provider.dart';
import '../providers/seasons_provider.dart';
import '../providers/matches_provider.dart';

import '../widgets/season/top_scoreboard.dart';
import '../widgets/season/start_match_button.dart';
import '../widgets/history/match_history_list.dart';

class SeasonPage extends StatelessWidget {
  static const String routeName = '/season-page';
  const SeasonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seasonPlayers = Provider.of<PlayerProvider>(context).seasonPlayers;
    final matchProvider = Provider.of<MatchProvider>(context);
    final seasonProv = Provider.of<SeasonProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        bool? resoults = await _onPop(
          ctx: context,
          matchProvider: matchProvider,
          seasonPlayers: seasonPlayers,
          seasonProv: seasonProv,
        );
        resoults ?? false;
        return resoults!;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopScoreBoard(
                seasonPlayers: seasonPlayers, matchProv: matchProvider),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  startMuch(matchProvider, context, seasonPlayers),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget startMuch(MatchProvider matchProvider, BuildContext context,
      List<Player> seasonPlayers) {
    return Expanded(
      child: Column(
        children: [
          StartMatchButton(
            onTap: () =>
                _startMatchDialog(context, matchProvider, seasonPlayers),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          MatchHistoryList(matchProvider: matchProvider),
        ],
      ),
    );
  }

  void _startMatchDialog(BuildContext context, MatchProvider matchProvider,
      List<Player> seasonPlayers) {
    showDialog(
      context: context,
      builder: (ctx) => SelectMatchPlayers(
          matchProv: matchProvider, seasonPlayers: seasonPlayers),
    );
  }

  Future<bool?> _onPop(
      {required SeasonProvider seasonProv,
      required List<Player> seasonPlayers,
      required MatchProvider matchProvider,
      required BuildContext ctx}) async {
    return showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        actions: [
          backButtonOption(ctx, () async {
            //save
            Navigator.of(ctx).pop();
            _saveAndExite(
              seasonProv,
              seasonPlayers,
              matchProvider,
              ctx,
            );
            return Navigator.of(ctx).pop(true);
          }, 'Save And Exite Season'),
          backButtonOption(
            ctx,
            () {
              _exiteWithoutSaving(matchProvider);
              return Navigator.of(ctx).pop(true);
            },
            'Exite without saving',
          ),
          backButtonOption(
            ctx,
            () => Navigator.of(
              ctx,
            ).pop(false),
            'Cancel',
          )
        ],
      ),
    );
  }

  void _saveAndExite(SeasonProvider seasonProv, List<Player> seasonPlayers,
      MatchProvider matchProvider, BuildContext context) {
    seasonProv.addSeason(
      seasonPlayers,
      matchProvider.matches,
      DateTime.now(),
    );
    matchProvider.clearMatches();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _exiteWithoutSaving(MatchProvider matchProvider) async {
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => matchProvider.clearMatches());
  }

  Widget backButtonOption(
      BuildContext ctx, VoidCallback onPressed, String textValue) {
    return TextButton(
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          textValue,
          style: Theme.of(ctx).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
