import 'package:flutter/material.dart';

import '../widgets/playersView/players_list_view.dart';

class PlayersViewPage extends StatelessWidget {
  static const String routeName = '/players-list-view';
  const PlayersViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlayersListView();
  }
}
