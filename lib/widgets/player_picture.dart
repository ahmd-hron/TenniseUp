import 'dart:io';

import 'package:flutter/material.dart';

class PlayerPicture extends StatelessWidget {
  const PlayerPicture({
    Key? key,
    this.image,
    this.color,
    this.radius,
  }) : super(key: key);
  final File? image;
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius == null ? 25 : radius! + 2,
      backgroundColor: Colors.blue.withOpacity(0.5),
      child: CircleAvatar(
        backgroundColor: color ?? Colors.white,
        radius: radius ?? 25,
        backgroundImage: backGroundImage(),
      ),
    );
  }

  ImageProvider backGroundImage() {
    if (image != null) {
      if (image!.path.isEmpty) {
        return const AssetImage('assets/images/no_image.png');
      }
    }

    return image != null
        ? FileImage(image!)
        : const AssetImage('assets/images/no_image.png') as ImageProvider;
  }
}
