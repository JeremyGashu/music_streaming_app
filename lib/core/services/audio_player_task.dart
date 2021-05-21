import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
final pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
final skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Skip Previous',
  action: MediaAction.skipToPrevious,
);
final skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Skip Next',
  action: MediaAction.skipToNext,
);

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  int _queueIndex = -1;
  static int clickDelay = 0;

  List<MediaItem> _queue = <MediaItem>[];
  StreamSubscription playerEventSubscription;
  SharedPreferences prefs;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get _mediaItem => _queue[_queueIndex];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    prefs = await SharedPreferences.getInstance();

    /// Audio playback event listener.
    ///
    /// This [playerEventSubscription] maps the [Processingstate] of the
    /// just_audio's [AudioPlayer] state to the [AudioProcessingState] state
    /// of the audio_services to sync background service to the player
    playerEventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.ready:
          _setState(state: AudioProcessingState.ready);
          break;
        case ProcessingState.buffering:
          _setState(state: AudioProcessingState.buffering);
          break;
        case ProcessingState.completed:
          _handlePlaybackCompleted();
          break;
        case ProcessingState.idle:
          _setState(state: AudioProcessingState.none);
          break;
        default:
          break;
      }
    });

    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  void _handlePlaybackCompleted() => hasNext ? onSkipToNext() : onStop();

  void playPause() => _audioPlayer.playing ? onPause() : onPlay();

  @override
  Future<void> onPlay() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    debugPrint('CALLED METHOD => onPause');
    if (_audioPlayer.processingState == ProcessingState.loading ||
        _audioPlayer.playing) {
      await _audioPlayer.pause();
      // Save the current player position in seconds.
      await prefs.setInt('position', _audioPlayer.position.inSeconds);
    }
  }

  @override
  Future<void> onSkipToNext() => skip(1);

  @override
  Future<void> onSkipToPrevious() => skip(-1);

  Future<void> skip(int offset) async {
    debugPrint('CALLED METHOD => skip');
    debugPrint("CURRENT INDEX => " + _queueIndex.toString());
    debugPrint("CURRENT QUEUE LENGTH => " + _queue.length.toString());
    final newIndex = _queueIndex + offset;
    if (!(newIndex >= 0 && newIndex < _queue.length)) return;

    await _audioPlayer.stop();

    _queueIndex = newIndex;
    // Broadcast that we're skipping.
    _setState(
      state: offset == -1
          ? AudioProcessingState.skippingToPrevious
          : AudioProcessingState.skippingToNext,
    );

    if (_mediaItem.extras['source'].toString().startsWith('/')) {
      /// To play from local path
      await _audioPlayer.setFilePath(_mediaItem.extras['source']);
    } else {
      /// To play directly from the given url in [MediaItem]
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }
    await onUpdateMediaItem(_mediaItem);
    debugPrint("NEXT PLAYING => " + _queueIndex.toString());
    await onPlay();

    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await prefs.setInt('position', position.inSeconds);
    _audioPlayer.seek(position);

    /// Broadcast that we're seeking.
    _setState(state: AudioServiceBackground.state.processingState);
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onClick(MediaButton button) async {
    switch (button) {
      case MediaButton.media:
        // 'double click to skip' feature for
        // headset using a click delay.
        clickDelay++;
        if (clickDelay == 1)
          Future.delayed(Duration(milliseconds: 250), () {
            if (clickDelay == 1) playPause();
            if (clickDelay == 2) onSkipToNext();
            clickDelay = 0;
          });
        break;
      case MediaButton.next:
        onSkipToNext();
        break;
      case MediaButton.previous:
        onSkipToPrevious();
        break;
      default:
    }
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    await _audioPlayer.stop();
    // Get queue index by mediaId.
    _queueIndex = _queue.indexWhere((media) => media.id == mediaId);

    if (_mediaItem.extras['source'].toString().startsWith('/')) {
      /// To play from local path
      await _audioPlayer.setFilePath(_mediaItem.extras['source']);
    } else {
      /// To play directly from the given url in [MediaItem]
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }
    await onUpdateMediaItem(_mediaItem);
    await onPlay();
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    await _audioPlayer.stop();

    if (mediaItem.extras['source'].toString().startsWith('/')) {
      /// To play from local path
      await _audioPlayer.setFilePath(mediaItem.extras['source']);
    } else {
      /// To play directly from the given url in [MediaItem]
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }

    await onUpdateMediaItem(mediaItem);
    await onPlay();
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onStop() async {
    await _audioPlayer.stop();

    // Save the current media item details.
    await save();

    // Broadcast that we've stopped.
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    // Clean up resources
    _queue = null;
    playerEventSubscription.cancel();
    await _audioPlayer.dispose();
    // Shutdown background task
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
    await super.onStop();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    await AudioServiceBackground.setMediaItem(mediaItem);
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> mediaItems) async {
    _queue = mediaItems;
    await AudioServiceBackground.setQueue(_queue);
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  /// This method sets background state with ease
  ///
  /// It accepts the audio_services [AudioProcessingState]
  void _setState({@required AudioProcessingState state}) {
    AudioServiceBackground.setState(
      controls: getControls(),
      processingState: state,
      playing: _audioPlayer.playing,
      position: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
    );
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      _audioPlayer.playing ? pauseControl : playControl,
      skipToNextControl
    ];
  }

  /// Save the current media item into shared preferences.
  Future<void> save() async {
    await prefs.setString('id', _mediaItem.id);
    await prefs.setString('album', _mediaItem.album);
    await prefs.setString('title', _mediaItem.title);
    await prefs.setString('artist', _mediaItem.artist);
    await prefs.setString('genre', _mediaItem.genre);
    await prefs.setString('artUri', _mediaItem.artUri.toString());
    await prefs.setInt('duration', _mediaItem.duration.inSeconds);
    await prefs.setString('source', _mediaItem.extras['source']);
  }
}
