import 'package:flutter/material.dart';

class PresentageCircle extends StatelessWidget {
  const PresentageCircle({
    Key? key,
    required this.presentage,
    this.width,
    this.color,
    this.style,
  }) : super(key: key);
  final double? width;
  final Color? color;
  final double presentage;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width ?? 50,
          height: width ?? 50,
          decoration: const BoxDecoration(
              color: Colors.transparent, shape: BoxShape.circle),
          child: CircularProgressIndicator(
              backgroundColor: Colors.black, value: presentage),
        ),
        Container(
          width: width ?? 50,
          height: width ?? 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withOpacity(0.15),
          ),
          alignment: Alignment.center,
          child: FittedBox(
              child: Text(
            // '${presentage.toInt() * 100} %',
            '${(presentage * 100).toStringAsFixed(0)}%',
            style: style,
          )),
        ),
      ],
    );
  }
}
