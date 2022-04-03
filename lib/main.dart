import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './providers/themes._provider.dart';
import './providers/players_provider.dart';
import './providers/seasons_provider.dart';
import './providers/matches_provider.dart';
import './providers/user_data_provider.dart';

import './pages/taps_page.dart';
import './pages/settings_page.dart';
import './pages/history_page.dart';
import './pages/home_page.dart';
import './pages/season_page.dart';
import './pages/start_season_page.dart';
import './pages/match_page.dart';
import './pages/create_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SeasonProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MatchProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
          builder: (context, _) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              //todo wrap this in feturebuilder and wait for user prefrences
              theme: MyTheme.darkTheme,
              darkTheme: MyTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              home: const TapsPage(),
              routes: {
                SettingsPage.routeName: (ctx) => const SettingsPage(),
                HomePage.routeName: (ctx) => const HomePage(),
                HistoryPage.routeName: (ctx) => const HistoryPage(),
                SeasonPage.routeName: (ctx) => const SeasonPage(),
                StartSeasonPage.routeName: (ctx) => const StartSeasonPage(),
                MatchPage.routeName: (ctx) => const MatchPage(),
                CreatePlayer.routeName: (ctx) => const CreatePlayer(),
              },
            );
          },
        ),
      ],
    );
  }
}
