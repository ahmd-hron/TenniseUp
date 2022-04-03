import 'package:flutter/material.dart';

import '../widgets/new_player_form.dart';

class CreatePlayer extends StatefulWidget {
  static const String routeName = '/create-player';
  const CreatePlayer({Key? key}) : super(key: key);

  @override
  State<CreatePlayer> createState() => _CreatePlayerState();
}

class _CreatePlayerState extends State<CreatePlayer> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: NewPlayerForm(),
    );
  }
}
