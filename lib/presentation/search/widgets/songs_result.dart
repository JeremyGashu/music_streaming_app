import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class SongsResult extends StatefulWidget {
  final Map<String, dynamic> result;

  SongsResult({this.result});

  @override
  _SongsResultState createState() => _SongsResultState();
}

class _SongsResultState extends State<SongsResult> {
  @override
  void initState() {
    BlocProvider.of<SearchBloc>(context)
        .add(SetCurrentPage(currentPage: SearchIn.SONGS));
    if (widget.result['songs'] == null) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.SONGS));
    } else if (widget.result['currentKey'] != widget.result['songsParam']) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.SONGS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int length;
    if ((widget.result['songs'] as TracksResponse) != null &&
        (widget.result['songs'] as TracksResponse).data != null) {
      length =
          (widget.result['songs'] as TracksResponse).data.data.songs.length;
    }

    return length == null
        ? SpinKitRipple(
            color: Colors.grey,
          )
        : length != 0
            ? ListView(
                children: (widget.result['songs'] as TracksResponse)
                    .data
                    .data
                    .songs
                    .map((songElement) {
                  return GestureDetector(
                    onTap: () async {
                      var recentlySearchedBox =
                          await Hive.openBox<Track>('recently_searched');
                      recentlySearchedBox.add(songElement.song);
                      playAudio(songElement.song);
                    },
                    child: musicTile(songElement.song, context),
                  );
                  // return SingleTrack(track: songElement.song);
                }).toList(),
              )
            : Center(child: Text('No song found!'));
  }

  void playAudio(Track track) async {
    if (AudioService.playbackState.playing) {
      if (track.songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.pushNamed(
            context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
            arguments: track);
        return;
      }
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print("audio service not running");
      int pos = sharedPreferences.getInt('position');
      Duration position = Duration(seconds: 0);
      if (pos != null) {
        position = Duration(seconds: pos);
      }
      playSong(context, position, track);
    }
  }

  Future<void> playSong(context, Duration position, Track track) async {
    try {
      Navigator.pushNamed(
          context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
          arguments: track);
      var dir = await LocalHelper.getFilePath(context);

      List<MediaItem> mediaItems = [];

      String source = '$M3U8_URL/${track.songId}';

      if (await LocalHelper.isFileDownloaded(track.songId) &&
          await LocalHelper.allSegmentsDownloaded(id: track.songId)) {
        print("${track.songId}: downloaded");
        source = '$dir/${track.songId}/main.m3u8';
      }

      mediaItems.add(MediaItem(
          id: track.songId,
          album: '',
          title: track.title,
          genre: '${track.genre.name}',
          artist: '${track.artist.firstName} ${track.artist.lastName}',
          duration: Duration(seconds: track.duration),
          artUri: Uri.parse(track.coverImageUrl),
          extras: {'source': source}));

      ParseHls parseHLS = ParseHls();
      print("mediaItems: ${mediaItems}");
      if (!(await LocalHelper.isFileDownloaded(track.songId)) ||
          !(await LocalHelper.allSegmentsDownloaded(id: track.songId))) {
        BlocProvider.of<UserDownloadBloc>(context)
            .add(StartDownload(track: track));
      } else {
        var m3u8FilePath = '$dir/${track.songId}/main.m3u8';

        File file = File(m3u8FilePath);
        if (file.existsSync()) {
          await parseHLS.updateLocalM3u8(m3u8FilePath);
          print("mediaItems: ${mediaItems}");
          print("the file is downloaded playing from local: ${mediaItems}");
          await parseHLS.writeLocalM3u8File(m3u8FilePath);
        } else {
          BlocProvider.of<UserDownloadBloc>(context)
              .add(StartDownload(track: track));
        }
      }

      await _startPlaying(mediaItems);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing song!')));
      Navigator.pop(context);
    }
  }

  _startPlaying(mediaItems) async {
    if (AudioService.running) {
      print("running");
      await AudioService.updateQueue(mediaItems);
      await AudioService.playMediaItem(mediaItems[0]);
    } else {
      if (await AudioService.start(
        backgroundTaskEntrypoint: backgroundTaskEntryPoint,
        androidNotificationChannelName: 'Playback',
        androidNotificationColor: 0xFF2196f3,
        androidStopForegroundOnPause: true,
        androidEnableQueue: true,
      )) {
        await AudioService.updateQueue(mediaItems);
        await AudioService.playMediaItem(mediaItems[0]);
      }
    }
  }
}
