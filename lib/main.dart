import 'package:flutter/material.dart';
import 'package:lemondoro/constants/theme_constants.dart';
import 'package:lemondoro/provider/auto_start_provider.dart';
import 'package:provider/provider.dart';
import 'provider/audio_provider.dart';
import 'provider/alarm_provider.dart';
import 'provider/slider_provider.dart';
import 'provider/theme_provider.dart';
import 'provider/time_provider.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sliderProvider = SliderProvider();
  final autoStartProvider = AutoStartProvider();
  final themeProvider = ThemeProvider();
  final notificationProvider = AlarmProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider.value(value: sliderProvider),
        ChangeNotifierProvider.value(value: notificationProvider),
        ChangeNotifierProvider(create: (context) => SoundSelectionProvider()),
        ChangeNotifierProvider.value(value: autoStartProvider)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      darkTheme: ThemeConstants.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      title: 'Lemondoro',
      theme: ThemeConstants.lightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
