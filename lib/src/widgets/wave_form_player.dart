import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_manager.dart';
import '../services/waveform_generator.dart';
import '../styles.dart';
import 'button_glow.dart';
import 'basic_audio_slider.dart';

/// A customizable audio waveform player widget
/// A complete waveform player widget with audio visualization, play/pause controls,
/// and extensive customization options.
///
/// This widget provides a comprehensive audio player interface with:
/// - Real-time waveform visualization
/// - Customizable progress slider with multiple thumb shapes
/// - Play/pause controls with animated effects
/// - Duration display
/// - Extensive theming and styling options
///
/// Example:
/// ```dart
/// WaveformPlayer(
///   audioUrl: 'https://example.com/audio.mp3',
///   waveformHeight: 24.0,
///   thumbSize: 16.0,
///   thumbShape: ThumbShape.verticalBar,
///   activeColor: Colors.blue,
///   inactiveColor: Colors.grey,
/// )
/// ```
class WaveformPlayer extends StatefulWidget {
  const WaveformPlayer({
    super.key,
    required this.audioUrl,
    this.waveformHeight = 24.0,
    this.thumbSize = 16.0,
    this.thumbShape = ThumbShape.verticalBar,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.backgroundColor,
    this.showPlayButton = true,
    this.showDuration = true,
    this.autoPlay = false,
    this.playButtonSize = 40.0,
    this.playButtonColor,
    this.playButtonIconColor,
    this.durationTextStyle,
    this.borderColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onPlayPause,
    this.onPositionChanged,
    this.onCompleted,
    this.onError,
    this.glowColor,
    this.barWidth = 4.0,
    this.barSpacing = 1.0,
  });

  /// URL of the audio file to play
  final String audioUrl;

  /// Height of the waveform visualization
  final double waveformHeight;

  /// Size of the draggable thumb
  final double thumbSize;

  /// Shape of the thumb (circle, verticalBar, etc.)
  final ThumbShape thumbShape;

  /// Color for the active (played) portion of the waveform
  final Color? activeColor;

  /// Color for the inactive (unplayed) portion of the waveform
  final Color? inactiveColor;

  /// Color of the draggable thumb
  final Color? thumbColor;

  /// Background color of the player container
  final Color? backgroundColor;

  /// Whether to show the play/pause button
  final bool showPlayButton;

  /// Whether to show the duration text
  final bool showDuration;

  /// Whether to auto-play when loaded
  final bool autoPlay;

  /// Size of the play/pause button
  final double playButtonSize;

  /// Color of the play/pause button background
  final Color? playButtonColor;

  /// Color of the play/pause button icon
  final Color? playButtonIconColor;

  /// Text style for duration display
  final TextStyle? durationTextStyle;

  /// Color of the border
  final Color? borderColor;

  /// Duration of animations (play button, etc.)
  final Duration animationDuration;

  /// Callback when play/pause state changes
  final ValueChanged<bool>? onPlayPause;

  /// Callback when position changes during playback
  final ValueChanged<Duration>? onPositionChanged;

  /// Callback when playback completes
  final VoidCallback? onCompleted;

  /// Callback when an error occurs
  final ValueChanged<String>? onError;

  /// Color of the play/pause button glow
  final Color? glowColor;

  /// Width of each waveform bar
  final double barWidth;

  /// Spacing between waveform bars
  final double barSpacing;

  @override
  State<WaveformPlayer> createState() => _WaveformPlayerState();
}

class _WaveformPlayerState extends State<WaveformPlayer>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = true;
  List<double> _waveformData = [];
  bool _isSeeking = false;
  Timer? _debounceTimer;
  double? _lastGeneratedWidth;
  bool _audioInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  double? _cachedWaveformWidth;
  static final Map<String, List<double>> _waveformCache = {};

  // Animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initAudio();
    _setupAudioManagerListener();
  }

  void _setupAudioManagerListener() {
    AudioManager().setOnCurrentPlayerChanged(() {
      if (mounted) {
        setState(() {
          _isPlaying = AudioManager().currentPlayer == _audioPlayer &&
              AudioManager().isPlaying;
        });
      }
    });
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 16), // 60fps
      vsync: this,
    );
  }

  void _updatePositionWithAnimation(Duration position) {
    _updateDurationIfNeeded();

    if (_shouldAutoStop(position)) {
      _handleAutoStop();
      return;
    }

    if (_isPlaying && position != _position) {
      _updatePosition(position);
      _animationController.forward(from: 0.0);
    }
  }

  void _updateDurationIfNeeded() {
    final currentDuration = _audioPlayer.duration;
    if (currentDuration != null && currentDuration != _duration) {
      _duration = currentDuration;
    }
  }

  bool _shouldAutoStop(Duration position) {
    final currentDuration = _audioPlayer.duration;
    return currentDuration != null &&
        position.inMilliseconds >= currentDuration.inMilliseconds - 100 &&
        _isPlaying;
  }

  void _handleAutoStop() {
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
      _isLoading = false;
      _isSeeking = false;
    });
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.pause();
  }

  void _updatePosition(Duration position) {
    if (mounted) {
      setState(() {
        _position = position;
      });

      // Callback for position changes
      widget.onPositionChanged?.call(position);
    }
  }

  @override
  void dispose() {
    AudioManager().clearCurrentPlayer(_audioPlayer);
    _audioPlayer.dispose();
    _debounceTimer?.cancel();
    _animationController.dispose();
    _audioInitialized = false;
    super.dispose();
  }

  Future<void> _initAudio() async {
    if (_audioInitialized) return;

    _audioPlayer = AudioPlayer();
    _audioInitialized = true;

    try {
      await _setupAudioPlayer();
      _setupAudioListeners();
    } catch (e) {
      _handleAudioError(e);
    }
  }

  Future<void> _setupAudioPlayer() async {
    await _audioPlayer.setUrl(widget.audioUrl);
    _duration = _audioPlayer.duration ?? Duration.zero;
    setState(() {
      _isLoading = false;
    });
  }

  void _setupAudioListeners() {
    _audioPlayer.positionStream.listen(_onPositionChanged);
    _audioPlayer.playerStateStream.listen(_onPlayerStateChanged);
  }

  void _onPositionChanged(Duration position) {
    if (!_isSeeking && _isPlaying) {
      _updatePositionWithAnimation(position);
    }
  }

  void _onPlayerStateChanged(PlayerState state) {
    setState(() {
      _isPlaying = state.playing;
    });

    _updateLoadingState(state);

    if (state.processingState == ProcessingState.completed) {
      _handlePlaybackCompleted();
    }
  }

  void _updateLoadingState(PlayerState state) {
    if (state.processingState == ProcessingState.ready) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePlaybackCompleted() {
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
      _isLoading = false;
      _isSeeking = false;
    });
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.pause();

    // Callback for playback completed
    widget.onCompleted?.call();
  }

  void _handleAudioError(dynamic error) {
    setState(() {
      _isLoading = false;
      _hasError = true;
      _errorMessage = error.toString();
    });

    // Callback for error
    widget.onError?.call(error.toString());
  }

  Future<void> _generateWaveformDataForWidth(double width) async {
    if (_hasError) return;

    const barWidth = 4.0;
    const barSpacing = 1.0;
    final barCount = ((width + barSpacing) / (barWidth + barSpacing)).floor();

    final cacheKey = '${widget.audioUrl}_$barCount';

    if (_waveformCache.containsKey(cacheKey)) {
      _waveformData = _waveformCache[cacheKey]!;
      return;
    }

    try {
      _waveformData = await RealWaveformGenerator.generateWaveformFromAudio(
        widget.audioUrl,
        targetBars: barCount,
        minHeight: 2.0,
        maxHeight: 25.0,
      );

      _waveformCache[cacheKey] = _waveformData;
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _togglePlayPause() async {
    if (_isLoading) return;

    if (_isPlaying) {
      await _handlePause();
    } else {
      await _handlePlay();
    }

    // Callback for play/pause state change
    widget.onPlayPause?.call(_isPlaying);
  }

  Future<void> _handlePause() async {
    setState(() {
      _isPlaying = false;
    });

    await _audioPlayer.pause();
    AudioManager().clearCurrentPlayer(_audioPlayer);
  }

  Future<void> _handlePlay() async {
    if (_isLoading) return;

    await AudioManager().setCurrentPlayer(_audioPlayer);
    _resetPlaybackState();

    setState(() {
      _isPlaying = true;
    });

    if (_duration.inMilliseconds > 0 &&
        _position.inMilliseconds >= _duration.inMilliseconds) {
      setState(() {
        _position = Duration.zero;
      });
      await _audioPlayer.seek(Duration.zero);
    }

    await _audioPlayer.play();
  }

  void _resetPlaybackState() {
    setState(() {
      _isSeeking = false;
    });
  }

  void _handleSeekStart() {
    setState(() {
      _isSeeking = true;
    });
    if (_isPlaying) {
      _audioPlayer.pause();
    }
  }

  void _handleSeekEnd() {
    setState(() {
      _isSeeking = false;
    });
    if (_duration.inMilliseconds > 0) {
      _audioPlayer.seek(_position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.showPlayButton) ...[
          _buildPlayButton(),
          const SizedBox(width: 7),
        ],
        Expanded(child: _buildWaveform()),
        if (widget.showDuration) ...[
          const SizedBox(width: 7),
          _buildDurationDisplay(),
        ],
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _hasError ? null : _togglePlayPause,
      child: Container(
        width: widget.playButtonSize,
        height: widget.playButtonSize,
        decoration: _buildPlayButtonDecoration(),
        child: _buildPlayButtonContent(),
      ),
    );
  }

  BoxDecoration _buildPlayButtonDecoration() {
    return BoxDecoration(
      color: _hasError
          ? WavePlayerColors.neutral60
          : (widget.playButtonColor ?? WavePlayerColors.playButton),
      shape: BoxShape.circle,
    );
  }

  Widget _buildPlayButtonContent() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    if (_hasError) {
      return _buildErrorIcon();
    }

    return _buildAnimatedPlayButton();
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return const Icon(
      Icons.error_outline,
      color: Colors.white,
      size: 20,
    );
  }

  Widget _buildAnimatedPlayButton() {
    return ButtonGlow(
      animate: _isPlaying,
      glowColor: widget.glowColor ?? WavePlayerColors.primary,
      child: InkWell(
        onTap: _togglePlayPause,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: PlayPauseButton(isPlaying: _isPlaying),
        ),
      ),
    );
  }

  Widget _buildDurationDisplay() {
    return SizedBox(
      width: 45,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          _formatDuration(_isPlaying ? _position : _duration),
          style: (widget.durationTextStyle ??
                  WavePlayerTextStyles.smallMedium.copyWith(
                    color: WavePlayerColors.textSecondary,
                  ))
              .copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final waveformWidth = _calculateWaveformWidth(constraints.maxWidth);

        if (_hasError) {
          return _buildWaveformError(waveformWidth);
        }

        _generateWaveformIfNeeded(constraints.maxWidth);

        if (_waveformData.isEmpty) {
          return _buildWaveformLoading(waveformWidth);
        }

        return _buildWaveformSlider(waveformWidth, constraints.maxWidth);
      },
    );
  }

  double _calculateWaveformWidth(double availableWidth) {
    final waveformWidth =
        _cachedWaveformWidth ?? (availableWidth * 0.8).clamp(120.0, 200.0);
    _cachedWaveformWidth ??= waveformWidth;
    return waveformWidth;
  }

  Widget _buildWaveformError(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        const Icon(Icons.error_outline, size: 16, color: Color(0xFFFF3B30)),
        Flexible(
          child: Text(
            _errorMessage ?? 'Error',
            style: WavePlayerTextStyles.smallMedium.copyWith(
              color: WavePlayerColors.error,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveformLoading(double width) {
    return Container(
      height: 24,
      width: width,
      decoration: BoxDecoration(
        color: WavePlayerColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
          ),
        ),
      ),
    );
  }

  void _generateWaveformIfNeeded(double availableWidth) {
    if (_lastGeneratedWidth != availableWidth) {
      _generateWaveformDataForWidth(availableWidth).then((_) {
        if (mounted) {
          setState(() {
            _lastGeneratedWidth = availableWidth;
          });
        }
      });
    }
  }

  Widget _buildWaveformSlider(double width, double availableWidth) {
    final displayData = _prepareWaveformData(availableWidth);
    final currentDuration = _getCurrentDuration();

    return Container(
      height: 24,
      width: width,
      decoration: BoxDecoration(
        color: WavePlayerColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RepaintBoundary(
        child: BasicAudioSlider(
          value: _position.inMilliseconds.toDouble(),
          max: currentDuration.inMilliseconds.toDouble(),
          onChanged: _onWaveformChanged,
          onChangeStart: _handleSeekStart,
          onChangeEnd: _handleSeekEnd,
          waveformData: displayData,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          thumbColor: widget.thumbColor,
          height: widget.waveformHeight,
          thumbSize: widget.thumbSize,
          thumbShape: widget.thumbShape,
          barWidth: widget.barWidth,
          barSpacing: widget.barSpacing,
        ),
      ),
    );
  }

  List<double> _prepareWaveformData(double availableWidth) {
    const barWidth = 4.0;
    const barSpacing = 1.0;
    final maxBars =
        ((availableWidth + barSpacing) / (barWidth + barSpacing)).floor();
    final actualBarCount = math.min(_waveformData.length, maxBars);
    return _waveformData.take(actualBarCount).toList();
  }

  Duration _getCurrentDuration() {
    return _duration.inMilliseconds > 0
        ? _duration
        : (_audioPlayer.duration ?? Duration.zero);
  }

  void _onWaveformChanged(double value) {
    setState(() {
      _position = Duration(milliseconds: value.round());
    });
  }
}

class PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  const PlayPauseButton({
    super.key,
    required this.isPlaying,
  });

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.isPlaying) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant PlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: _controller,
      color: WavePlayerColors.white,
      size: 20,
    );
  }
}
