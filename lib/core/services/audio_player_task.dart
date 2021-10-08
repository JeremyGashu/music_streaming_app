import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/data/models/analytics.dart';

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

  int _queueIndex = 0;
  static int clickDelay = 0;
  int _timeCounter = -1;
  String userId;
  String latLang;
  Map<String, List<Map>> _analyticsData = {'data': []};

  List<MediaItem> _queue = <MediaItem>[];
  StreamSubscription playerEventSubscription;

  StreamSubscription analyticsTimerStream;
  String _currentMediaItemId;

  SharedPreferences prefs;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get _mediaItem => _queue[_queueIndex];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    prefs = await SharedPreferences.getInstance();

    analyticsTimerStream = Stream.periodic(Duration(seconds: 1)).listen((_) {
      _timeCounter++;
    });
    print('analytics => started analytics');
    analyticsTimerStream.pause();
    print('analytics => started analytics');
    print('analytics => current data $_timeCounter');
    userId = prefs.getString('user_id');
    latLang = prefs.getString('lat_lang');

    // LocationData locationData = await LocalHelper.getUserLocation();
    // print('location => ${locationData.toString()}');

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
    _audioPlayer.play();
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
    if ((_currentMediaItemId != null) &&
        (_currentMediaItemId != _mediaItem.id)) {
      Analytics _analytics = Analytics(
        duration: _timeCounter,
        songId: _mediaItem.id,
        userId: userId,
        location: latLang != null
            ? latLang
            : '');
      print('analytics => to save ${_analytics.toJson()}');
      _analyticsData['data'].add(_analytics.toJson());
      prefs.setString('analytics_data', jsonEncode(_analyticsData));

      print('analytics => after write ${_analyticsData}}');
      _currentMediaItemId = _mediaItem.id;
      _timeCounter = -1;
      debugPrint(
          'analytics => changed music, reset the counter and save the data');
    }
    if (analyticsTimerStream.isPaused) {
      analyticsTimerStream.resume();
      print('analytics => resumed counter again');
      print('analytics => current data $_timeCounter');
      _currentMediaItemId = _mediaItem.id;
      print('analytics => current media_id ${_mediaItem.id}');
    }
  }

  @override
  Future<void> onPause() async {
    debugPrint('CALLED METHOD => onPause');
    if (_audioPlayer.processingState == ProcessingState.loading ||
        _audioPlayer.playing) {
      await _audioPlayer.pause();
      analyticsTimerStream.pause();
      print('analytics => paused counter');
      print('analytics => current data $_timeCounter');
      print('analytics => current data ${_mediaItem.id}');
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
    print("Shuffle mode enabled: ${_audioPlayer.shuffleModeEnabled}");
    int newIndex = _queueIndex + offset;
    if (_audioPlayer.shuffleModeEnabled) {
      newIndex = Random().nextInt(_queue.length);
      while (newIndex == _queueIndex) {
        newIndex = Random().nextInt(_queue.length);
      }
      print("New idnex: $newIndex");
    }
    print("Queue index: ${_queueIndex}");
    print("Playing index: ${newIndex}");
    print("queue length: ${_queue.length}");
    if (_audioPlayer.loopMode == LoopMode.one) {
      newIndex = _queueIndex;
    }
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
      /// To play from local pathz
      await playFromLocal(_mediaItem.extras['source']);
    } else {
      print("download started from skip method");
      LocalHelper.downloadMedia(_mediaItem.extras['source'], _mediaItem.id);
      // await _audioPlayer.setUrl(_mediaItem.extras['source']);
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }
    analyticsTimerStream.pause();
    print('analytics => paused and sending analytics data');
    print('analytics => current data $_timeCounter');
    print('analytics => current data $_currentMediaItemId}');
    _timeCounter = -1;

    print('analytics => reset data $_timeCounter}');

    await onUpdateMediaItem(_mediaItem);
    await onPlay();
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
    if (_mediaItem.extras['initializing'] != null &&
        _mediaItem.extras['initializing']) {
      debugPrint('Initializing: AudioService on startup.');
      await _audioPlayer.setAsset(_mediaItem.extras['source']);
    } else if (_mediaItem.extras['source'].toString().startsWith('/')) {
      /// To play from local path
      await playFromLocal(_mediaItem.extras['source']);
    } else {
      /// To play directly from the given url in [MediaItem]
      // await _audioPlayer.setUrl(_mediaItem.extras['source']);
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }
    await onUpdateMediaItem(_mediaItem);
    await onPlay();
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    await _audioPlayer.stop();
    _queueIndex = _queue.indexWhere((media) => media.id == mediaItem.id);
    print(_queueIndex);
    print(_mediaItem);

    if (mediaItem.extras['source'].toString().startsWith('/')) {
      /// To play from local path
      print("playing from local");
      await playFromLocal(mediaItem.extras['source']);
    } else {
      /// To play directly from the given url in [MediaItem]
      print("playing from remote");
      // await _audioPlayer.setUrl(mediaItem.extras['source']);
      HlsAudioSource _hlsAudioSource = HlsAudioSource(
        Uri.parse(_mediaItem.extras['source']),
      );
      await _audioPlayer.setAudioSource(_hlsAudioSource);
    }

    await onUpdateMediaItem(mediaItem);
    await onPlay();
  }

  Future<void> playFromLocal(String source) async {
    var dir = await LocalHelper.getLocalFilePath();
    var filePathEnc = "$dir/${_mediaItem.id}/enc.key.aes";
    var filePathDec = "$dir/${_mediaItem.id}/enc.key";
    await LocalHelper.decryptFile(filePathEnc);
    await _audioPlayer.setFilePath(source);
    File decryptedFile = File(filePathDec);
    await Future.delayed(Duration(milliseconds: 50));
    await decryptedFile.delete();
    // await LocalHelper.encryptFile(filePathDec);
  }

  @override
  Future<void> onStop() async {
    print('analytics => onStop being called');

    analyticsTimerStream.pause();
    Analytics _analytics = Analytics(
        duration: _timeCounter,
        songId: _mediaItem.id,
        userId: userId,
        location: latLang != null
            ? latLang
            : '');
    print('analytics => to send $_analytics');
    _analyticsData['data'].add(_analytics.toJson());

    print('analytics => after write ${_analyticsData}');
    await prefs.setString('analytics_data', jsonEncode(_analyticsData));
    print('analytics => saved _analytics data');
    _timeCounter = -1;

    print('analytics => paused and sending analytics data');
    print('analytics => current data $_timeCounter');
    print('analytics => current data $_currentMediaItemId}');

    await _audioPlayer.stop();

    // Save the current media item details.
    await save();

    // Broadcast that we've stopped.

    // Clean up resources
    _queue = null;
    playerEventSubscription.cancel();
    await _audioPlayer.dispose();
    // Shutdown background task
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');

    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );

    await super.onStop();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    await AudioServiceBackground.setMediaItem(mediaItem);
    debugPrint(
        'AUDIO SERVICE BACKGROUND CURRENT STATE : ${AudioServiceBackground.state.playing}');
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) {
    if (repeatMode != AudioServiceRepeatMode.none) {
      switch (repeatMode) {
        case AudioServiceRepeatMode.all:
          _audioPlayer.setLoopMode(LoopMode.all);
          break;
        case AudioServiceRepeatMode.none:
          _audioPlayer.setLoopMode(LoopMode.off);
          break;
        case AudioServiceRepeatMode.one:
          _audioPlayer.setLoopMode(LoopMode.one);
          break;
        case AudioServiceRepeatMode.group:
          break;
      }
      _audioPlayer.setLoopMode(LoopMode.one);
    }
    AudioServiceBackground.setState(repeatMode: repeatMode);
    return super.onSetRepeatMode(repeatMode);
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) {
    if (shuffleMode != AudioServiceShuffleMode.none) {
      _audioPlayer.setShuffleModeEnabled(true);
    }
    AudioServiceBackground.setState(shuffleMode: shuffleMode);
    return super.onSetShuffleMode(shuffleMode);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> mediaItems) async {
    _queue = mediaItems;
    print("Onupdatequeue[queuelength]:${mediaItems.length}");
    await AudioServiceBackground.setQueue(_queue);
  }

  /// This method sets background state with ease
  ///
  /// It accepts the audio_services [AudioProcessingState]
  void _setState({@required AudioProcessingState state}) {
    AudioServiceBackground.setState(
      controls: getControls(),
      // systemActions: [MediaAction.seekTo],
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
