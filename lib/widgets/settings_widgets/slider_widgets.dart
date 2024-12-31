import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/slider_provider.dart';
import '../../provider/time_provider.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sliderProvider = Provider.of<SliderProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        DurationWidget(
          title: 'Focus Duration',
          sliderValue: SliderProvider.studyDurationSliderValue,
          max: 60,
          min: 5,
          updateValue: (newValue) {
            sliderProvider.updateWorkDurationSliderValue(newValue);
          },
          minText: 'min',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        DurationWidget(
          title: 'Short Break Duration',
          sliderValue: SliderProvider.shortBreakDurationSliderValue,
          max: 30,
          min: 1,
          updateValue: (newValue) {
            sliderProvider.updateShortBreakDurationSliderValue(newValue);
          },
          minText: 'min',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        DurationWidget(
          title: 'Long Break Duration',
          sliderValue: SliderProvider.longBreakDurationSliderValue,
          max: 45,
          min: 1,
          updateValue: (newValue) {
            sliderProvider.updateLongBreakDurationSliderValue(newValue);
          },
          minText: 'min',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        DurationWidget(
          title: 'Rounds',
          sliderValue: SliderProvider.roundSliderValue,
          max: 15,
          min: 2,
          updateValue: (newValue) {
            sliderProvider.updateRoundSliderValue(newValue);
          },
          minText: '',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ],
    );
  }
}

class DurationWidget extends StatelessWidget {
  DurationWidget({
    super.key,
    required this.title,
    required this.sliderValue,
    required this.max,
    required this.min,
    required this.updateValue,
    required this.minText,
    required this.screenWidth,
    required this.screenHeight,
  });

  final String title;
  final double max;
  final double min;
  int sliderValue;
  String minText;
  void Function(int newValue) updateValue;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    TextEditingController controller =
        TextEditingController(text: sliderValue.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWithPadding(text: title, screenWidth: screenWidth),
        Row(
          children: [
            Expanded(
              child: Slider(
                label: "$sliderValue",
                max: max,
                min: min,
                value: sliderValue.toDouble(),
                onChanged: (value) {
                  sliderValue = value.toInt();
                  controller.text = sliderValue.toString();
                  updateValue(sliderValue);
                  timerProvider.resetTimer();
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.02), // Adjusted from 10
            SizedBox(
              width: screenWidth * 0.146, // 60 / 411.43 ≈ 0.146
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.0087), // 8 / 914.29 ≈ 0.0087
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (value) {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= min && newValue <= max) {
                    sliderValue = newValue;
                    updateValue(sliderValue);
                    timerProvider.resetTimer();
                  } else {
                    controller.text = sliderValue.toString();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please enter a value between ${min.toInt()} and ${max.toInt()}'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.0164, // 15 / 914.29 ≈ 0.0164
        ),
      ],
    );
  }
}

class TextWithPadding extends StatelessWidget {
  const TextWithPadding({
    required this.text,
    required this.screenWidth,
    super.key,
  });

  final String text;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.0487), // 20 / 411.43 ≈ 0.0487
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
