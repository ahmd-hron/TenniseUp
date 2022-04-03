import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double width;
  final List<Color> gradientColors;
  final Color shadowBrightColor;
  final VoidCallback onTap;
  final Widget child;
  final double? bottomPadding;
  const CircularButton({
    required this.width,
    required this.child,
    required this.gradientColors,
    required this.onTap,
    required this.shadowBrightColor,
    this.bottomPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 0),
      height: width,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowBrightColor,
            offset: const Offset(-3, -1),
          ),
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(1, 3),
          ),
        ],
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.01, 0.8]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width),
          ),
          shadowColor: Colors.black,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.2),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
