import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auto_start_provider.dart';
import '../../provider/theme_provider.dart';

class SettingsDarkModeSwitch extends StatelessWidget {
  const SettingsDarkModeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SwitchListTile(
      title: const Text('Dark Mode', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        value = !value;
        themeProvider.switchTheme();
      },
    );
  }
}

class AutoStartSwitch extends StatelessWidget {
  const AutoStartSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final autoStartProvider = Provider.of<AutoStartProvider>(context);
    return SwitchListTile(
      title: const Text('Auto Start', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
      value: AutoStartProvider.autoStart,
      onChanged: (value) {
        value = !value;
        autoStartProvider.switchMode();
      },
    );
  }
}