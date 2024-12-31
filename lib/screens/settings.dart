import 'package:flutter/material.dart';
import '../widgets/settings_widgets/alarm_widgets.dart';
import '../widgets/settings_widgets/slider_widgets.dart';
import '../widgets/settings_widgets/switch_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SliderWidget(),
                  SettingsDarkModeSwitch(),
                  AutoStartSwitch(),
                  AlarmSettingsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
