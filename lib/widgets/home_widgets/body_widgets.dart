//body_widgets.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/time_provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';


class LemonadeWidget extends StatelessWidget {
  final double progress;

  const LemonadeWidget({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.215, // 90 / 411.43 ≈ 0.219
      height: screenHeight * 0.226, // 200 / 914.29 ≈ 0.218
      child: LiquidLinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color.fromARGB(175, 253, 229, 49),
        ),
        backgroundColor: Colors.transparent,
        borderColor: Colors.black,
        borderWidth: 1.0,
        direction: Axis.vertical,
      ),
    );
  }
}

class DrippingAnimationWidget extends StatefulWidget {
  const DrippingAnimationWidget({super.key});

  @override
  _DrippingAnimationWidgetState createState() =>
      _DrippingAnimationWidgetState();
}

class _DrippingAnimationWidgetState extends State<DrippingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dripAnimation;

  late double fadeStartPosition;
  late double fadeEndPosition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    _dripAnimation = Tween<double>(begin: 0, end: 298).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double screenHeight = MediaQuery.of(context).size.height;
    fadeStartPosition = screenHeight * (60 / 914.29); // 100 / 914.29 ≈ 0.1094
    fadeEndPosition = screenHeight * (61 / 914.29); // 101 / 914.29 ≈ 0.1105
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOpacity(double position) {
    if (position <= fadeStartPosition) {
      return 1.0;
    } else if (position >= fadeEndPosition) {
      return 0.2;
    } else {
      return 1.0 -
          ((position - fadeStartPosition) /
              (fadeEndPosition - fadeStartPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    double currentPosition = _dripAnimation.value;
    double currentOpacity = _calculateOpacity(currentPosition);

    return Transform.translate(
      offset: Offset(
          0,
          currentPosition *
              (screenHeight / 914.29)), // Relative to screenHeight
      child: Opacity(
        opacity: currentOpacity,
        child: Container(
          width: screenWidth *
              0.0219, // 10 / 411.43 ≈ 0.0243; adjusted to 0.0219 for better fit
          height: screenHeight * 0.0219, // 20 / 914.29 ≈ 0.0219
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 233, 0),
            borderRadius: BorderRadius.circular(
                screenWidth * 0.0243), // 10 / 411.43 ≈ 0.0243
          ),
        ),
      ),
    );
  }
}

class TimeModeWidget extends StatelessWidget {
  const TimeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      timerProvider.isBreakTime ? 'BREAK' : 'FOCUS',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04, // Adjusted from fixed size
          ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      timerProvider.currentTimeDisplay,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.16, // 70 / 1080 ≈ 0.065
          ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool isDisabled;

  const CircleButton({
    super.key,
    required this.icon,
    required this.size,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (size + 30) * (screenWidth / 411.43), // Adjust width
      height: (size + 30) * (screenWidth / 411.43), // Adjust height
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey[300]
            : const Color.fromARGB(255, 241, 241, 87),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size * (screenWidth / 411.43), // Adjust icon size
        color: isDisabled ? Colors.grey : Colors.black,
      ),
    );
  }
}

class MediaButtons extends StatelessWidget {
  const MediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: timerProvider.isEqual ? null : timerProvider.resetTimer,
          child: CircleButton(
            icon: Icons.replay,
            size: 30.0 * (screenWidth / 411.43), // 30 / 411.43 ≈ 0.073
            isDisabled: timerProvider.isEqual,
          ),
        ),
        GestureDetector(
          onTap: () {
            timerProvider.toggleTimer(isFromPlayButton: true);
          },
          child: CircleButton(
            icon: timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
            size: 50.0 * (screenWidth / 411.43), // 50 / 411.43 ≈ 0.122
          ),
        ),
        GestureDetector(
          onTap: timerProvider.nextRound, // Corrected from nextRound
          child: CircleButton(
            icon: Icons.fast_forward,
            size: 30.0 * (screenWidth / 411.43), // 30 / 411.43 ≈ 0.073
          ),
        ),
      ],
    );
  }
}

class RoundsWidget extends StatelessWidget {
  const RoundsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      timerProvider.currentRoundDisplay,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: screenWidth * 0.04, // Adjusted fontSize
          ),
    );
  }
}
