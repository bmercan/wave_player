import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wave_player/wave_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave Player Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WavePlayerExample(),
    );
  }
}

class WavePlayerExample extends StatefulWidget {
  const WavePlayerExample({super.key});

  @override
  State<WavePlayerExample> createState() => _WavePlayerExampleState();
}

class _WavePlayerExampleState extends State<WavePlayerExample> {
  Timer? _volumeTimer;

  @override
  void initState() {
    super.initState();
    _startVolumeSimulation();
  }

  void _startVolumeSimulation() {
    _volumeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _volumeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wave Player Example'),
        backgroundColor: WavePlayerColors.primary,
        foregroundColor: WavePlayerColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waveform Player',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: WavePlayerColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: WaveformPlayer(
                  backgroundColor: Colors.white,
                  audioUrl:
                      'https://d38nvwmjovqyq6.cloudfront.net/va90web25003/companions/ws_smith/1%20Comparison%20Of%20Vernacular%20And%20Refined%20Speech.mp3',
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Basic Audio Slider',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: WavePlayerColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Card(
                color: Colors.white,
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      BasicAudioSlider(
                        value: 0.0,
                        max: 100.0,
                        onChanged: (value) {
                          // Handle value change
                        },
                        onChangeStart: () {
                          // Handle start
                        },
                        onChangeEnd: () {
                          // Handle end
                        },
                        waveformData: _generateSampleWaveform(),
                        activeColor: WavePlayerColors.waveformActive,
                        inactiveColor: WavePlayerColors.waveformInactive,
                        thumbColor: WavePlayerColors.waveformThumb,
                        height: 30,
                        thumbSize: 24,
                        thumbShape: ThumbShape.verticalBar,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<double> _generateSampleWaveform() {
    final random = math.Random();
    return List.generate(50, (index) {
      return random.nextDouble() * 20 + 5;
    });
  }
}
