import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// A singleton service to manage audio playback across the app
/// Ensures only one audio player can play at a time
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  AudioPlayer? _currentPlayer;
  bool _isPlaying = false;
  final StreamController<void> _playerChangedController =
      StreamController<void>.broadcast();

  /// Get the current active player
  AudioPlayer? get currentPlayer => _currentPlayer;

  /// Check if any audio is currently playing
  bool get isPlaying => _isPlaying;

  /// Stream that emits when the current player changes
  Stream<void> get onPlayerChanged => _playerChangedController.stream;

  /// Set a new current player and pause others
  Future<void> setCurrentPlayer(AudioPlayer newPlayer) async {
    // Pause current player if different
    if (_currentPlayer != null && _currentPlayer != newPlayer) {
      await _currentPlayer!.pause();
    }

    _currentPlayer = newPlayer;
    _isPlaying = true;
    _playerChangedController.add(null);
  }

  /// Clear the current player
  void clearCurrentPlayer(AudioPlayer player) {
    if (_currentPlayer == player) {
      _currentPlayer = null;
      _isPlaying = false;
      _playerChangedController.add(null);
    }
  }

  /// Pause all audio
  Future<void> pauseAll() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.pause();
      _isPlaying = false;
      _playerChangedController.add(null);
    }
  }

  /// Stop all audio and reset position
  Future<void> stopAll() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      _isPlaying = false;
      _playerChangedController.add(null);
    }
  }

  /// Set callback for when current player changes
  void setOnCurrentPlayerChanged(VoidCallback callback) {
    _playerChangedController.stream.listen((_) => callback());
  }

  /// Dispose the audio manager
  void dispose() {
    _playerChangedController.close();
  }
}
