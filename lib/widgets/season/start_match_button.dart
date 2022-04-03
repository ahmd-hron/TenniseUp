import 'package:flutter/material.dart';

import '../circular_button.dart';

class StartMatchButton extends StatelessWidget {
  const StartMatchButton({required this.onTap, Key? key}) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      bottomPadding: 8,
      width: MediaQuery.of(context).size.height * 0.23,
      child: const Text('Start New Match'),
      gradientColors: [
        Colors.white.withOpacity(0.08),
        Colors.white.withOpacity(0.04)
      ],
      onTap: onTap,
      shadowBrightColor: Colors.white.withOpacity(0.01),
    );
  }
}
