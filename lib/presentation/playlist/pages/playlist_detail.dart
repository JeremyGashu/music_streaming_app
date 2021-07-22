import 'dart:io';

import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/player_overlay.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/playlistStat.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/search_bar.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/upper_section.dart';

class PlaylistDetail extends StatefulWidget {
  final List<Track> tracks;
  PlaylistDetail({this.tracks});
  @override
  _PlaylistDetailState createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //upper section containing the image, svg, shuffle button and healing track
              upperSection(context),
              SizedBox(
                height: 20,
              ),
              playListStat(),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.8),
              ),
              SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 160,
                  height: 40,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () async {
                      // TODO: play playlist
                      if (!AudioService.running) {
                        await AudioService.start(
                          backgroundTaskEntrypoint: backgroundTaskEntryPoint,
                          androidNotificationChannelName: 'Playback',
                          androidNotificationColor: 0xFF2196f3,
                          androidStopForegroundOnPause: true,
                          androidEnableQueue: true,
                        );
                      }
                      await AudioService.setShuffleMode(
                          AudioServiceShuffleMode.all);
                      playAudio(Random().nextInt(widget.tracks.length),
                          sharedPreferences);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Shuffle Play',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //ad section
              // _adContainer('ad.png'),
              SizedBox(
                height: 15,
              ),
              searchBar(),
              SizedBox(
                height: 15,
              ),
              Container(
                child: StreamBuilder(
                    stream: AudioService.currentMediaItemStream,
                    builder: (context, AsyncSnapshot<MediaItem> snapshot) {
                      print("Snapshot: ${snapshot.data}");
                      print(snapshot.hasData &&
                          (snapshot.data.id == widget.tracks[0].songId));
                      // print(snapshot.hasData &&
                      //     (snapshot.data.id == tracks[0].data.id));
                      return StreamBuilder(
                        stream: AudioService.playbackStateStream,
                        builder: (context,
                                AsyncSnapshot<PlaybackState>
                                    playbackSnapshot) =>
                            Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.tracks.length,
                                itemBuilder: (context, index) {
                                  return musicTile(widget.tracks[index], () {
                                    print("play playlist");
                                    playAudio(index, sharedPreferences);
                                  },
                                      snapshot.hasData &&
                                          (snapshot.data.id ==
                                              widget.tracks[index].songId) &&
                                          playbackSnapshot.hasData &&
                                          playbackSnapshot.data.playing);
                                }),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder(
            stream: AudioService.playbackStateStream,
            builder: (context, AsyncSnapshot<PlaybackState> snapshot) {
              if (snapshot.hasData) {
                print("SnapshotData: ${snapshot.data.processingState}");
              }
              if (snapshot.hasData) {
                var snapShotData = snapshot.data.processingState;
                if (snapShotData != AudioProcessingState.stopped) {
                  return StreamBuilder(
                      stream: AudioService.currentMediaItemStream,
                      builder: (context,
                          AsyncSnapshot<MediaItem> currentMediaItemSnapshot) {
                        return currentMediaItemSnapshot.hasData &&
                                currentMediaItemSnapshot.data != null
                            ? PlayerOverlay(playing: snapshot.data.playing)
                            : SizedBox();
                      });
                }
              }
              return SizedBox();
            },
          ),
        ),
      ]),
    ));
  }

  void playAudio(int index, SharedPreferences prefs) async {
    if (AudioService.playbackState.playing) {
      if (widget.tracks[index].songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SingleTrackPlayerPage(track: widget.tracks[index])));
        return;
      }
    }

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print("audio service not running");
      int pos = sharedPreferences.getInt('position');
      Duration position = Duration(seconds: 0);
      if (pos != null) {
        position = Duration(seconds: pos);
      }
      playPlayList(context, position, index);
    }
    // else{
    //   AudioService.play();
    //   print("here");
    // }
  }

  Future<void> playPlayList(context, Duration position, index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SingleTrackPlayerPage(track: widget.tracks[index])));
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    print("tracks length: ${widget.tracks.length}");
    print("index: $index");
    print("tracks: ${widget.tracks}");
    print("trackId: ${widget.tracks[0].trackId}");
    print("songId: ${widget.tracks[0].songId}");

    for (Track track in widget.tracks) {
      print("trackId: ${track.songId}");
      String source = 'https://138.68.163.236:8787/track/${track.songId}';
      if (await LocalHelper.isFileDownloaded(track.songId)) {
        print("${track.songId}: downloaded");
        source = '$dir/${track.songId}/main.m3u8';
      }

      print("Source: $source");
      mediaItems.add(MediaItem(
          id: track.songId,
          album: track.albumId,
          title: track.song.title,
          genre: 'genre goes here',
          // artist: track.artist.firstName,
          duration: Duration(milliseconds: track.song.duration),
          artUri: Uri.parse(track.song.coverImageUrl),
          // extras: {'source': m3u8FilePath});
          extras: {'source': source}));
    }

    // await tracks.forEach((element) async {
    //   String source = element.data.trackUrl;
    //   if (await LocalHelper.isFileDownloaded(element.data.id)) {
    //     print("${element.data.id}: downloaded");
    //     source = '$dir/${element.data.id}/main.m3u8';
    //   }
    //   print("Source: $source");
    //   mediaItems.add(MediaItem(
    //       id: element.data.id,
    //       album: element.data.albumId,
    //       title: element.data.title,
    //       genre: 'genre goes here',
    //       artist: element.data.artistId,
    //       duration: Duration(milliseconds: element.data.duration),
    //       artUri: Uri.parse(element.data.coverImgUrl),
    //       // extras: {'source': m3u8FilePath});
    //       extras: {'source': source}));
    // });

    // await AudioService.addQueueItems(mediaItems);
    /// check if currently clicked media file is not downloaded and start download
    var _trackToPlay = widget.tracks[index];
    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(_trackToPlay.songId))) {
      // var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile(
                  'https://138.68.163.236:8787/track/${_trackToPlay.songId}',
                  '$dir/${_trackToPlay.songId}',
                  "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: _trackToPlay.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${_trackToPlay.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${_trackToPlay.songId}/main.m3u8';

      /// TODO: uncomment for encryption key download
      await parseHLS.updateLocalM3u8(m3u8FilePath);
      print("mediaItems: ${mediaItems}");
      print("the file is downloaded playing from local: ${mediaItems[index]}");
      await parseHLS.writeLocalM3u8File(m3u8FilePath);
    }

    await _startPlaying(mediaItems, index);
  }

  _startPlaying(mediaItems, index) async {
    if (AudioService.running) {
      print("running");
      await AudioService.updateQueue(mediaItems);
      await AudioService.playMediaItem(mediaItems[index]);
    } else {
      if (await AudioService.start(
      backgroundTaskEntrypoint: backgroundTaskEntryPoint,
      androidNotificationChannelName: 'Playback',
      androidNotificationColor: 0xFF2196f3,
      androidStopForegroundOnPause: true,
      androidEnableQueue: true,
      )) {
    await AudioService.updateQueue(mediaItems);
    await AudioService.playMediaItem(mediaItems[index]);
    }
  }
  }
}

class Music {
  String name;
  String artistName;
  String duration;
  String imageName;
  Music({this.artistName, this.name, this.imageName, this.duration});
}
