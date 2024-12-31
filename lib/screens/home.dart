// home.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/time_provider.dart';
import '../widgets/home_widgets/appbar_widgets.dart';
import '../widgets/home_widgets/body_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    // Calculate progress for LemonadeWidget
    double progress;
    if (timerProvider.isBreakTime) {
      progress =
          timerProvider.currentTimeInSeconds / timerProvider.maxTimeInSeconds;
    } else {
      progress = 1 -
          (timerProvider.currentTimeInSeconds / timerProvider.maxTimeInSeconds);
    }
    progress = progress.clamp(0.0, 1.0);

    // Determine which image to show based on state
    String stateImage;
    if (timerProvider.isBreakTime && timerProvider.isRunning) {
      stateImage = 'assets/image/break_on.png'; // girl_drinking + straw + cup
    } else if (timerProvider.isBreakTime && !timerProvider.isRunning) {
      stateImage = 'assets/image/break_off.png'; // girl_drinking + cup
    } else if (!timerProvider.isBreakTime && timerProvider.isRunning) {
      stateImage = 'assets/image/timer_on.png'; // lemon_on + cup
    } else {
      stateImage = 'assets/image/timer_off.png'; // lemon_off + cup
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const DarkModeButton(),
        title: const AppbarTitle(),
        actions: const [
          SettingsButton(),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TimeWidget(),
                  const SizedBox(height: 10.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TimeModeWidget(),
                      RoundsWidget(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const MediaButtons(),
                ],
              ),
            ),
          ),
          // Background Image and Overlays
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  children: [
                    // Base State Image
                    Positioned.fill(
                      child: Image.asset(
                        stateImage,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // DrippingAnimationWidget
                    if (timerProvider.isRunning && !timerProvider.isBreakTime)
                      Align(
                        alignment: Alignment(0.0, -0.2667),
                        child: FractionallySizedBox(
                          widthFactor: 0.022,
                          heightFactor: 0.036,
                          child: const DrippingAnimationWidget(),
                        ),
                      ),

                    // LemonadeWidget
                    if (timerProvider.showLemonade)
                      Align(
                        alignment: Alignment(-0.01, 0.78),
                        child: FractionallySizedBox(
                          widthFactor: 0.23,
                          heightFactor: 0.423,
                          child: LemonadeWidget(progress: progress),
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),

          // Foreground Widgets with Background
        ],
      ),
    );
  }
}
