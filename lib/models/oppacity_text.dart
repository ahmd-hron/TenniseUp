import 'package:flutter/material.dart';

class OppacityText extends TextStyle {
  final double opacity;
  @override
  Color? get color => Colors.white.withOpacity(opacity);
  const OppacityText(
    this.opacity,
  );
}
