import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';

void initializeAudioService() async {
  var assetPath = 'assets/audio/initial audio.mp3';
  var initId = 'initializer';
  MediaItem _mediaItem = MediaItem(
      id: initId,
      album: '',
      title: '',
      genre: '',
      artist: '',
      artUri: Uri.parse(''),
      duration: Duration(seconds: 1),
      extras: {
        'source': assetPath,
        'initializing': true,
      });

  if (await AudioService.start(
    backgroundTaskEntrypoint: backgroundTaskEntryPoint,
    androidNotificationChannelName: 'Playback',
    androidNotificationColor: 0xFF2196f3,
    androidStopForegroundOnPause: true,
    androidEnableQueue: true,
  )) {
    final List<MediaItem> queue = [];
    queue.add(_mediaItem);

    await AudioService.updateMediaItem(queue[0]);
    await AudioService.updateQueue(queue);

    debugPrint('playing the silent audio to initialization');
    await AudioService.playFromMediaId(initId);
  }
}
