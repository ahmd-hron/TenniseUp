import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tennis_scoreboard/helper/database.dart';

import 'package:tennis_scoreboard/models/player.dart';
import 'package:tennis_scoreboard/models/oppacity_text.dart';
import 'package:tennis_scoreboard/helper/image_picker.dart';

import '../player_picture_select.dart';

class PlayerView extends StatefulWidget {
  final Player player;
  const PlayerView({required this.player, Key? key}) : super(key: key);

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  File? newImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
      ),
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      height: 182,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.07),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //player photo and name
        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width * 0.3,
          // player photo and edite text
          child: Column(
            children: [
              //player photo and edite text
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.15),
                ),
                child: FutureBuilder<bool>(
                    future: checkIfImageExist(),
                    builder: (ctx, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      bool? existe = snapShot.data!;
                      return PlayerPictureSelect(
                        image: existe ? widget.player.image : newImage,
                        onTaped: () async {
                          newImage = await Picker.showImagePickDialoge(context);
                          if (newImage == null) return;
                          _updatePlayerImage(existe);
                          setState(() {
                            widget.player.image = newImage;
                          });
                        },
                      );
                    }),
              ),
              //player name
              Text(
                widget.player.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        //player info
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: playerInfo(),
        ),
      ]),
    );
  }

  void _updatePlayerImage(bool? exist) async {
    if (exist == null || !exist) {
      String? location = await Picker.saveImage(newImage, widget.player.id);
      DB.updatePlayerData(widget.player.id, {'imagePath': location});
    } else if (exist) {
      Picker.updateImage(newImage, widget.player.image!.path);
    }
  }

  Widget playerInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        rowInfo(
            'Play time', (widget.player.timePlayed ~/ 60).toString() + ' m'),
        rowInfo('Game played', widget.player.gamePlayed.toString()),
        rowInfo('Wins', widget.player.totalWins.toString()),
        rowInfo('loses', widget.player.totalLost.toString()),
      ],
    );
  }

  Widget rowInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const OppacityText(1)),
          Text(
            info,
            style: const OppacityText(0.85),
          )
        ],
      ),
    );
  }

  Future<bool> checkIfImageExist() async {
    if (widget.player.image == null) return false;
    return widget.player.image!.exists();
  }
}
