import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/* class ThemeManager implements IThemeModeManager{
  @override
  Future<String?> loadThemeMode() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString("THEME_PREF");
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString("THEME_PREF", value);
  }
} */

class MyThemes {
  static final darkTheme = ThemeData(
    //background color
    scaffoldBackgroundColor: Color(0xFFFF102526),
    appBarTheme: AppBarTheme(
      color: Color(0xFFFF1F2B85),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(     
      color: Color(0xFFFF102526),          //container
    ),
    backgroundColor: Colors.grey,     //search bar color
    primaryColor: Colors.black,
    highlightColor: Color(0xFFFFF37721),        //selected currency index
    secondaryHeaderColor: Color(0xFFFF444444),   //FAQ card 
    selectedRowColor: Color(0xFFFFC9C9C9),      //FAQ selected card
    colorScheme: ColorScheme.dark(
      secondary: Colors.white,          //theme title 
      //primary: Color.fromARGB(255, 50, 2, 52),     //settings button 
      //onPrimary: Colors.white,
      //tertiary: Color(0xFFFF37721),         //index type selection 
      //onTertiary: Colors.teal,       //logout button 
      primaryContainer: Color(0xFFFF252A34),         //bottom navigation bar
      secondaryContainer: Colors.purple,     //market_list:market_name
      tertiaryContainer: Color(0xFFFFF4F4F4)        //transaction_history container, settings, faqs button, amount & mins on details page, search bar 
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(234, 230, 230, 1),
    appBarTheme: AppBarTheme(
      color: Color(0xFF1F96B0),
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,        //container
    ),
    backgroundColor: Colors.blue.shade100,      //search bar color
    primaryColor: Colors.white,
    highlightColor: Color(0xFFFFF37721),        //selected currency index
    secondaryHeaderColor: Color(0xFFFFEAEAEA),       //FAQ color
    selectedRowColor: Color(0xFFFFC4C4C4),      //FAQ selected card
    colorScheme: ColorScheme.light(
      secondary: Colors.black,       //Theme title
      //primary: Color(0xFFF4F4F4),     //settings button 
      //onPrimary: Colors.black,        
      //tertiary: Colors.teal,    
      //onTertiary: Colors.teal,     //logout button 
      primaryContainer: Colors.black,       //bottom navigation bar 
      secondaryContainer: Colors.amberAccent,     //market_list:market_name
      tertiaryContainer: Color(0xFFFFC4C4C4)        //transaction_history container, settings, faqs button, amount & mins on details page, search bar 

    ),
    iconTheme: IconThemeData(color: Colors.black),
  );
}