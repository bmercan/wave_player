# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2024-12-19

### Added
- Initial release of Wave Player package
- `WaveformPlayer` widget with audio visualization and playback
- `BasicAudioSlider` widget with customizable waveform display
- `AudioManager` singleton service for audio management
- `RealWaveformGenerator` service for waveform data generation
- Comprehensive theming system with `WavePlayerTheme`
- Support for multiple thumb shapes (circle, verticalBar, roundedBar)
- Customizable colors, text styles, and animations
- Support for all Flutter platforms (Android, iOS, Web, Windows, macOS, Linux)

### Features
- Real-time waveform visualization
- Play/pause controls with animated effects
- Seek functionality with smooth animations
- Customizable UI components
- Global theme management
- Audio playback coordination
- Error handling and callbacks

### Dependencies
- `just_audio` for audio playback
- `path_provider` for file system access
- `permission_handler` for permission handling
- `http` for HTTP requests