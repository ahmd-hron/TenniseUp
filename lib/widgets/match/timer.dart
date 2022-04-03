// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  final bool stopTimer;
  final Color primaryColor;
  final Color backGroundColor;
  final Function(int s) providTime;

  const Timer({
    required this.stopTimer,
    required this.backGroundColor,
    required this.primaryColor,
    required this.providTime,
    Key? key,
  }) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  DateTime? time;
  int seconds = 0;
  @override
  void initState() {
    time = DateTime.now();
    super.initState();
    addSecond();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          (_minuteandSecondCounter()),
          style: TextStyle(
            color: widget.primaryColor,
            fontFamily: 'Scoreboard',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void addSecond() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (mounted) {
        setState(() {
          if (!widget.stopTimer) seconds++;
          widget.providTime(seconds);
        });
      }
      addSecond();
    });
  }

  // String _time() {
  //   int s = seconds;
  //   int minutes = 0;
  //   int hourse = 0;
  //   if (seconds > 59) {
  //     minutes = seconds ~/ 60;
  //     s = seconds % 60;
  //     if (minutes > 59) {
  //       hourse = minutes ~/ 60;
  //       minutes = minutes % 60;
  //     }
  //   }
  //   return '$hourse:$minutes:$s';
  // }

  String _minuteandSecondCounter() {
    int s = seconds;
    int minutes = 0;
    String secondsFormat = '00';
    String minutesFormat = '00';
    if (seconds > 59) {
      minutes = seconds ~/ 60;
      s = seconds % 60;
    }
    if (minutes < 10)
      minutesFormat = '0$minutes';
    else
      minutesFormat = '$minutes';
    if (s < 10)
      secondsFormat = '0${s % 60}';
    else
      secondsFormat = '$s';
    return '$minutesFormat:$secondsFormat';
  }
}
