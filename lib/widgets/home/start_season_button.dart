import 'package:flutter/material.dart';

import '../circular_button.dart';

import '../../pages/start_season_page.dart';

class StartSeassonButton extends StatelessWidget {
  const StartSeassonButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return startSeasonButton(context);
  }

  Widget startSeasonButton(BuildContext context) {
    return CircularButton(
      width: MediaQuery.of(context).size.width * 0.5,
      child: const Text('Start Season'),
      gradientColors: [
        Colors.white.withOpacity(0.2),
        Colors.white.withOpacity(0.14)
      ],
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext ctx, _, __) => const StartSeasonPage(),
          ),
        );
      },
      shadowBrightColor: Colors.white.withOpacity(0.015),
    );
  }
}
