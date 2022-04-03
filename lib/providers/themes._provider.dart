import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  //TODO change this later to check for saved themes before changing
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleDarkTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    //todo save new theme value here
    notifyListeners();
  }
}

class MyTheme {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      indicatorColor: AppDarkColors.accentsColor,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(
        color: AppDarkColors.accentsColor,
      ),
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          color: AppDarkColors.iconColors,
          fontSize: 15,
        ),
      ));

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white54,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red.shade200, opacity: 0.8),
  );
}

class AppDarkColors {
  static const iconColors = Color.fromRGBO(250, 37, 140, 1);
  static const accentsColor = Color.fromRGBO(47, 202, 145, 1);
}

class AppLightColors {}
