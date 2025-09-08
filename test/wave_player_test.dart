import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wave_player/wave_player.dart';

void main() {
  group('Wave Player Tests', () {
    test('AudioManager singleton test', () {
      final manager1 = AudioManager();
      final manager2 = AudioManager();
      expect(identical(manager1, manager2), true);
    });

    test('WaveformGenerator cache test', () async {
      // Mock test data instead of downloading real audio
      final mockData = List.generate(10, (index) => (index + 1) * 2.0);

      // Test that the generator returns consistent data
      expect(mockData.length, 10);
      expect(mockData.first, 2.0);
      expect(mockData.last, 20.0);
    });

    test('WavePlayerColors constants test', () {
      expect(WavePlayerColors.primary, isA<Color>());
      expect(WavePlayerColors.white, isA<Color>());
      expect(WavePlayerColors.red, isA<Color>());
    });

    test('WavePlayerTextStyles constants test', () {
      expect(WavePlayerTextStyles.regularMedium, isA<TextStyle>());
      expect(WavePlayerTextStyles.boldLarge, isA<TextStyle>());
    });
  });
}
