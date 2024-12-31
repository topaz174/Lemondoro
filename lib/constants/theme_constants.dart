import 'package:flutter/material.dart';

class ThemeConstants {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Nunito', 
    
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 218, 218, 78), // Bright yellow for focused border
          width: 2,
        ),
      ),
    ),
    colorSchemeSeed: const Color.fromARGB(255, 218, 218, 78),  // Bright yellow for the seed
    brightness: Brightness.light,
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color.fromARGB(255, 218, 218, 78),
      inactiveTrackColor: Colors.yellow.withOpacity(0.8),
      thumbColor: const Color.fromARGB(255, 218, 218, 78),
      showValueIndicator: ShowValueIndicator.always,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Color.fromARGB(255, 218, 218, 78)), // Switch thumb color
      trackColor: WidgetStateProperty.all(Colors.yellow.withOpacity(0.7)), // Track color
      overlayColor: WidgetStateProperty.all(Colors.yellow.withOpacity(0.3)), // Overlay color
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Nunito',
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.yellow, // Focused border color for dark theme
          width: 2,
        ),
      ),
    ),
    colorSchemeSeed: Colors.yellow,  // Bright yellow for dark theme as well
    brightness: Brightness.dark,
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.yellow,
      inactiveTrackColor: Colors.yellow.withOpacity(0.4),
      thumbColor: Colors.yellow,
      showValueIndicator: ShowValueIndicator.always, 
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.yellow), // Switch thumb color
      trackColor: WidgetStateProperty.all(Colors.yellow.withOpacity(0.7)), // Track color
      overlayColor: WidgetStateProperty.all(Colors.yellow.withOpacity(0.3)), // Overlay color
    ),
  );
}
