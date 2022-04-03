import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/players_provider.dart';

import './player_picture_select.dart';

import '../helper/image_picker.dart';

class NewPlayerForm extends StatefulWidget {
  const NewPlayerForm({Key? key}) : super(key: key);

  @override
  State<NewPlayerForm> createState() => _NewPlayerFormState();
}

class _NewPlayerFormState extends State<NewPlayerForm> {
  final TextEditingController _newPlayerName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? newImage;

  final padding = const Padding(padding: EdgeInsets.symmetric(vertical: 20));

  @override
  dispose() {
    _newPlayerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProv = Provider.of<PlayerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: Column(children: [
                  TextFormField(
                    controller: _newPlayerName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text('name')),
                    validator: (value) => value!.length < 3
                        ? 'name should have atleast 3 letters'
                        : null,
                  ),
                  //middle name
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration:
                        const InputDecoration(label: Text('middle name')),
                  ),
                  //last name
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text('last name')),
                  ),
                  //age
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text('age')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter player age here';
                      }
                      int? age = int.tryParse(value);
                      if (age == null) return 'please enter valued age ';

                      if (age > 100 || age < 3) {
                        return 'please enter valid age between 3 and 100';
                      }
                      return null;
                    },
                  ),
                  padding,
                  //picture
                  PlayerPictureSelect(
                    image: newImage,
                    onTaped: () async {
                      File? temp = await Picker.showImagePickDialoge(context);
                      if (temp == null) return;
                      setState(() {
                        newImage = temp;
                      });
                    },
                  ),
                ]),
              ),
            ),
            ElevatedButton(
                onPressed: () => _sumbitForm(playerProv),
                child: const Text('submit'))
          ],
        ),
      ),
    );
  }

  Future _sumbitForm(PlayerProvider playerProv) async {
    String newPlayerId = DateTime.now().toIso8601String();
    bool valid = _formKey.currentState!.validate();
    //image name should be player id
    String? savedLocation = await Picker.saveImage(newImage, newPlayerId);
    if (valid) {
      await playerProv.addDataBasePlayer(
        name: _newPlayerName.text,
        id: newPlayerId,
        imagePath: savedLocation ?? '',
      );
      _newPlayerName.text = '';
      Navigator.of(context).pop();
    }
  }
}
