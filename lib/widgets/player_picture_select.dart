import 'dart:io';
import 'package:flutter/material.dart';

class PlayerPictureSelect extends StatefulWidget {
  final Function onTaped;
  final File? image;
  const PlayerPictureSelect({required this.onTaped, this.image, Key? key})
      : super(key: key);

  @override
  State<PlayerPictureSelect> createState() => _PlayerPictureSelectState();
}

class _PlayerPictureSelectState extends State<PlayerPictureSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.05),
      ),
      height: 150,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Stack(clipBehavior: Clip.hardEdge, children: [
        Positioned(
          left: widget.image == null ? 5 : 0,
          bottom: 0,
          child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.3,
            child: widget.image != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: Image.file(
                      widget.image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width * 0.3,
          height: 25,
          bottom: 0,
          left: 0,
          child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                backgroundBlendMode: BlendMode.xor,
                color: Colors.white.withOpacity(0.5),
              ),
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  widget.onTaped();
                },
                child: const Text(
                  'tap to chage',
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ]),
    );
  }
}
