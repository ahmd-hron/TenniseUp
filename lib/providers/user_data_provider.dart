import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider with ChangeNotifier {
  int _set = 2;

  int get setsForTheWin {
    return _set;
  }

  Future writeuserData(int newSet) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('setsToWin', newSet);
    notifyListeners();
  }

  Future readUserDataSets() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('setsToWin')) {
      _set = prefs.getInt('setsToWin')!;
    } else {
      writeuserData(2);
    }
  }
}
