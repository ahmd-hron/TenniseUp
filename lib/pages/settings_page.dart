import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_data_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // final _setsController = TextEditingController();

  @override
  void initState() {
    Provider.of<UserDataProvider>(context, listen: false).readUserDataSets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserDataProvider>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView(
          children: [
            settingsColumn(
              optionsLabel: 'Match',
              items: _gameItems(context),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            settingsColumn(
                items: _appItems(context), optionsLabel: 'Application')
          ],
        ),
      ),
    );
  }

  Widget settingsColumn({
    required List<Item> items,
    required String optionsLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          //option label
          Container(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              width: double.infinity,
              child: Text(
                optionsLabel,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18),
              )),
          //  items
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.08),
            ),
            child: Column(children: items),
          )
        ],
      ),
    );
  }

  List<Item> _gameItems(BuildContext context) {
    List<Item> items = [];
    String subtitle = 'Tap to change';
    final TextStyle style = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.labelMedium!.color);
    items.add(
      Item(
        label: 'Game for match',
        subtitle: subtitle,
        trail: Text(
          '2',
          style: style,
        ),
      ),
    );
    items.add(
      Item(
          label: 'max number in season',
          subtitle: subtitle,
          trail: Text(
            '4',
            style: style,
          ),
          shouldAddDivider: false),
    );
    return items;
  }

  List<Item> _appItems(BuildContext context) {
    List<Item> items = [];
    Color color = Theme.of(context).textTheme.labelMedium!.color!;

    items.add(
      Item(
        label: 'Dark Mode',
        trail: Switch(
          onChanged: (value) {},
          value: true,
          activeColor: color,
        ),
      ),
    );
    items.add(
      Item(
        label: 'Alert message',
        subtitle: 'show warning on deleting players data',
        trail: Switch(
          onChanged: (value) {},
          value: true,
          activeColor: color,
        ),
      ),
    );
    items.add(
      Item(
        label: 'Allow same players name',
        subtitle: 'add numbers for exsiying player names',
        trail: Switch(
          onChanged: (value) {},
          value: false,
          activeColor: color,
        ),
      ),
    );
    return items;
  }
}

class Item extends StatelessWidget {
  final String label;
  final String? subtitle;
  final Widget? trail;
  final bool shouldAddDivider;
  const Item(
      {this.shouldAddDivider = true,
      required this.label,
      this.subtitle,
      this.trail,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  '   $subtitle!',
                ),
          trailing: trail,
        ),
        if (shouldAddDivider) const Divider(height: 0),
      ],
    );
  }
}


/*Center(
        child: ListView(
      children: [
        ListTile(
          title: const Text('set for win'),
          subtitle: Text('${userData.setsForTheWin}'),
          trailing: IconButton(
            onPressed: () => changeSavedSet(userData),
            icon: const Icon(Icons.edit),
          ),
        )
      ],
    ));*/

    
  // void changeSavedSet(UserDataProvider userData) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('new Value'),
  //       content: TextField(
  //         controller: _setsController,
  //         keyboardType: TextInputType.number,
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('cancel')),
  //         TextButton(
  //           onPressed: () {
  //             userData.writeuserData(int.parse(_setsController.text));
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('save'),
  //         )
  //       ],
  //     ),
  //   );
  // }
