import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/seasons_provider.dart';

import '../widgets/home/start_season_button.dart';
import '../widgets/home/last_season.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SeasonProvider>(context).fetchLastSeason(),
      builder: (ctx, snapShot) => snapShot.connectionState ==
              ConnectionState.waiting
          ? circularCenterIndicator()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const StartSeassonButton(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.05),
                  ),
                  lastSeasonTitle(context),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                  LastSeason(snapShot: snapShot),
                ],
              ),
            ),
    );
  }

  Widget circularCenterIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget lastSeasonTitle(BuildContext ctx) {
    return SizedBox(
      width: MediaQuery.of(ctx).size.width * 0.8,
      child: const Text(
        '      LS',
        textAlign: TextAlign.start,
        style: TextStyle(),
      ),
    );
  }
}
