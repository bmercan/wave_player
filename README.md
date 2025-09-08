# Wave Player

A Flutter package for audio waveform visualization and playback with customizable UI components.

## Features

- 🎵 **Waveform Player** - Complete audio player UI with waveform visualization
- 📊 **Waveform Visualization** - Real-time audio waveform display with seek functionality
- 🎚️ **Audio Slider** - Customizable audio progress slider with multiple thumb shapes
- 🎨 **Customizable Styling** - Extensive theming and customization options
- 🔄 **Audio Management** - Singleton audio manager for coordinated playback

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  wave_player: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Waveform Player

```dart
import 'package:wave_player/wave_player.dart';

WaveformPlayer(
  audioUrl: 'https://example.com/audio.mp3',
  waveformHeight: 24.0,
  thumbSize: 16.0,
  thumbShape: ThumbShape.verticalBar,
)
```

### Custom Theme

```dart
// Set global theme
WavePlayerColors.theme = const WavePlayerTheme(
  primaryColor: Color(0xFF2196F3),
  successColor: Color(0xFF4CAF50),
  backgroundColor: Color(0xFFE3F2FD),
  surfaceColor: Color(0xFFFFFFFF),
  textColor: Color(0xFF1565C0),
  textSecondaryColor: Color(0xFF424242),
);

// Or create a custom theme
final customTheme = WavePlayerTheme(
  primaryColor: Colors.purple,
  successColor: Colors.green,
  backgroundColor: Colors.grey[100]!,
  surfaceColor: Colors.white,
  textColor: Colors.black87,
  textSecondaryColor: Colors.grey[600]!,
);

// Apply custom theme
WavePlayerColors.theme = customTheme;
```

### Volume Bar Indicator

```dart
VolumeBarIndicator(
  volume: 0.7, // 0.0 to 1.0
  barCount: 8,
  width: 100,
  height: 30,
  activeColor: Colors.green,
  inactiveColor: Colors.grey,
)
```

### Basic Audio Slider

```dart
BasicAudioSlider(
  value: currentPosition,
  max: totalDuration,
  onChanged: (value) {
    // Handle position change
  },
  onChangeStart: () {
    // Handle seek start
  },
  onChangeEnd: () {
    // Handle seek end
  },
  waveformData: waveformData,
  isSender: false,
  activeColor: WavePlayerColors.primary,
  inactiveColor: WavePlayerColors.neutral60,
  thumbColor: WavePlayerColors.primary,
  height: 30,
  thumbSize: 24,
  thumbShape: ThumbShape.verticalBar,
)
```


## Widgets

### WaveformPlayer

A complete waveform player widget with audio visualization, play/pause controls, and extensive customization options.

**Properties:**
- `audioUrl` - URL of the audio file
- `waveformHeight` - Height of the waveform display
- `thumbSize` - Size of the progress thumb
- `thumbShape` - Shape of the thumb (circle, verticalBar, roundedBar)
- `activeColor` - Color for played portion
- `inactiveColor` - Color for unplayed portion
- `thumbColor` - Color of the progress thumb
- `backgroundColor` - Background color
- `showPlayButton` - Whether to show play/pause button
- `showDuration` - Whether to show duration text
- `autoPlay` - Whether to auto-play on load
- `playButtonSize` - Size of the play/pause button
- `playButtonColor` - Color of the play/pause button background
- `playButtonIconColor` - Color of the play/pause button icon
- `durationTextStyle` - Text style for duration display
- `borderColor` - Color of the border
- `animationDuration` - Duration of animations
- `onPlayPause` - Callback when play/pause state changes
- `onPositionChanged` - Callback when position changes during playback
- `onCompleted` - Callback when playback completes
- `onError` - Callback when an error occurs
- `glowColor` - Color of the play/pause button glow
- `barWidth` - Width of waveform bars
- `barSpacing` - Spacing between waveform bars

### BasicAudioSlider

A customizable audio slider with waveform visualization and multiple thumb shapes.

**Properties:**
- `value` - Current position value
- `max` - Maximum value
- `onChanged` - Callback when value changes
- `onChangeStart` - Callback when seeking starts
- `onChangeEnd` - Callback when seeking ends
- `waveformData` - List of waveform bar heights
- `activeColor` - Color for played portion
- `inactiveColor` - Color for unplayed portion
- `thumbColor` - Color of the thumb
- `height` - Height of the slider
- `thumbSize` - Size of the thumb
- `thumbShape` - Shape of the thumb (circle, verticalBar, roundedBar)
- `barWidth` - Width of each waveform bar
- `barSpacing` - Spacing between waveform bars


## Services

### AudioManager

A singleton service for managing audio playback across the app.

```dart
// Set current player
await AudioManager().setCurrentPlayer(audioPlayer);

// Clear current player
AudioManager().clearCurrentPlayer(audioPlayer);

// Pause all audio
await AudioManager().pauseAll();

// Stop all audio
await AudioManager().stopAll();
```

### RealWaveformGenerator

Service for generating waveform data from audio files.

```dart
final waveformData = await RealWaveformGenerator.generateWaveformFromAudio(
  audioUrl,
  targetBars: 50,
  minHeight: 2.0,
  maxHeight: 25.0,
);
```

## Styling

The package includes a comprehensive set of colors and text styles:

### Colors

```dart
// Primary colors
WavePlayerColors.primary
WavePlayerColors.primary70
WavePlayerColors.primary50
WavePlayerColors.primary30
WavePlayerColors.primary10

// Neutral colors
WavePlayerColors.neutral0
WavePlayerColors.neutral7
WavePlayerColors.neutral10
// ... and more

// Semantic colors
WavePlayerColors.white
WavePlayerColors.black
WavePlayerColors.red
WavePlayerColors.green
WavePlayerColors.orange
WavePlayerColors.yellow
```

### Text Styles

```dart
WavePlayerTextStyles.regularSmall
WavePlayerTextStyles.regularMedium
WavePlayerTextStyles.regularLarge
WavePlayerTextStyles.mediumSmall
WavePlayerTextStyles.mediumMedium
WavePlayerTextStyles.mediumLarge
WavePlayerTextStyles.boldSmall
WavePlayerTextStyles.boldMedium
WavePlayerTextStyles.boldLarge
```

## Example

See the `example/` directory for a complete example app demonstrating all features.

## Dependencies

- `just_audio` - Audio playback
- `path_provider` - File system access
- `permission_handler` - Permission handling

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.