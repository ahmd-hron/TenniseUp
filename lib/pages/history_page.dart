import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/seasons_provider.dart';
import '../widgets/history/seasons_list.dart';

class HistoryPage extends StatelessWidget {
  static const String routeName = '/History page';
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seasonProv = Provider.of<SeasonProvider>(context);

    return FutureBuilder(
        future: seasonProv.loadSeasonData(),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? _buildLoadingIndecator()
                : const SeasonsList());
  }

  Widget _buildLoadingIndecator() {
    return const Center(child: CircularProgressIndicator());
  }
}
