import 'package:flutter/material.dart';

class TenniseCourt extends StatelessWidget {
  final bool? matchPoint;
  final bool? setPoint;
  const TenniseCourt({Key? key, this.matchPoint, this.setPoint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.green[800],
        border: const Border(
          top: BorderSide(color: Colors.white, width: 2),
          left: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: Column(children: [
        Expanded(child: _playerSide(true)),
        _net(),
        Expanded(child: _playerSide(false)),
      ]),
    );
  }

  Widget _net() {
    return Container(
      height: 4,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black, offset: Offset(2, 2)),
        BoxShadow(color: Colors.black, offset: Offset(0, 0)),
      ]),
    );
  }

  Widget _playerSide(bool isBottomSide) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white, width: isBottomSide ? 0 : 0),
            left: const BorderSide(color: Colors.white, width: 2),
            right: const BorderSide(color: Colors.white, width: 2),
            bottom:
                BorderSide(color: Colors.white, width: isBottomSide ? 0 : 0),
          ),
        ),
        child: Column(children: [
          Flexible(
            child: Container(
              child: isBottomSide
                  ? SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Center(
                        child: Text(
                          infoText(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : _scoreROw(true, isBottomSide),
            ),
            flex: 1,
          ),
          Flexible(
            child: Container(
              child: isBottomSide
                  ? _scoreROw(false, isBottomSide)
                  : SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Center(
                        child: Text(
                          infoText(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            flex: 1,
          ),
        ]),
      ),
    );
  }

  Widget _scoreROw(bool isRightSide, bool isBottomSide) {
    return Row(
      children: [
        Flexible(
            child: Container(
              decoration: BoxDecoration(
                // color: isRightSide ? Colors.blue : Colors.red,
                border: Border(
                  top: BorderSide(
                      color: Colors.white, width: isBottomSide ? 2 : 0),
                  bottom: BorderSide(
                      color: Colors.white, width: isBottomSide ? 0 : 2),
                  left: BorderSide(
                      color: Colors.white, width: isRightSide ? 0 : 0),
                  right: BorderSide(
                      color: Colors.white, width: isRightSide ? 1 : 1),
                ),
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(fontSize: 22, fontFamily: 'Scoreboard'),
                ),
              ),
            ),
            flex: 1),
        Flexible(
            child: Container(
              decoration: BoxDecoration(
                // color: isRightSide ? Colors.red : Colors.blue,
                border: Border(
                  top: BorderSide(
                      color: Colors.white, width: isBottomSide ? 2 : 0),
                  bottom: BorderSide(
                      color: Colors.white, width: isBottomSide ? 0 : 2),
                  left: BorderSide(
                      color: Colors.white, width: !isRightSide ? 1 : 1),
                  right: BorderSide(
                      color: Colors.white, width: !isRightSide ? 0 : 0),
                ),
              ),
              child: const Center(
                child: Text(
                  '30',
                  style: TextStyle(fontSize: 22, fontFamily: 'Scoreboard'),
                ),
              ),
            ),
            flex: 1)
      ],
    );
  }

  String infoText() {
    if (matchPoint == true) return 'Match Point !';
    if (setPoint == true) return 'Set Point !';
    return '';
  }
}
