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
        title: const Text('Wave Player Example',
            style: TextStyle(color: Colors.black)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waveform Player',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WavePlayerColors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: WaveformPlayer(
                backgroundColor: Colors.white,
                audioUrl:
                    'https://d38nvwmjovqyq6.cloudfront.net/va90web25003/companions/ws_smith/1%20Comparison%20Of%20Vernacular%20And%20Refined%20Speech.mp3',
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Basic Audio Slider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WavePlayerColors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
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
                      thumbShape: ThumbShape.verticalBar,
                    ),
                  ],
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
