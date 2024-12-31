import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/audio_provider.dart';
import '../../provider/alarm_provider.dart';

class AlarmSettingsWidget extends StatelessWidget {
  const AlarmSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<AlarmProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Alarm Sound',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8.0), 

        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Expanded(
                child: Consumer<SoundSelectionProvider>(
                  builder: (context, provider, child) {
                    return DropdownButtonFormField<String>(
                      value: provider.selectedAudioFile,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: provider.audioFiles.map((audioFile) {
                        return DropdownMenuItem<String>(
                          value: audioFile,
                          child: Text(audioFile),
                        );
                      }).toList(),
                      onChanged: (value) {
                        provider.setSelectedAudioFile(value!);
                        provider.playSelectedAudio();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0), 

              
              Switch(
                value: AlarmProvider.isActive,
                onChanged: (value) {
                  notificationProvider.switchMode();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
