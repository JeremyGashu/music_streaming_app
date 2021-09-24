import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

class SingleTrack extends StatefulWidget {
  final Track track;
  SingleTrack({@required this.track});

  @override
  _SingleTrackState createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          /// Start playing the audio
          playAudio(sharedPreferences);

          /// Pass the track data to [SingletrackPlayer] page
          /// using state.track
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => SingleTrackPlayerPage(
          //               track: widget.track,
          //             )));
        },
        child: Container(
          width: 140,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 140,
              height: 120,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: SpinKitRipple(
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    imageUrl: widget.track.coverImageUrl,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/images/singletrack_one.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                    width: 140.0,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '${widget.track.artist.firstName} ${widget.track.artist.lastName} ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${widget.track.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kGray,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    '${prettyDuration(Duration(
                      seconds: widget.track.duration,
                    ))}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kYellow,
                        fontSize: 12.0),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  void playAudio(SharedPreferences prefs) async {
    if (AudioService.playbackState.playing) {
      if (widget.track.songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SingleTrackPlayerPage(track: widget.track)));
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
      playSong(context, position);
    }
  }

  Future<void> playSong(context, Duration position) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleTrackPlayerPage(track: widget.track)));
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    // print("tracks length: ${widget.tracks.length}");
    // print("index: $index");
    // print("tracks: ${widget.tracks}");
    // print("trackId: ${widget.tracks[0].songId}");
    // print("songId: ${widget.tracks[0].songId}");

    String source = 'https://138.68.163.236:8787/track/${widget.track.songId}';

    if (await LocalHelper.isFileDownloaded(widget.track.songId)) {
      print("${widget.track.songId}: downloaded");
      source = '$dir/${widget.track.songId}/main.m3u8';
    }

    mediaItems.add(MediaItem(
        id: widget.track.songId,
        album: '',
        title: widget.track.title,
        genre: '${widget.track.genre.name}',
        artist:
            '${widget.track.artist.firstName} ${widget.track.artist.lastName}',
        duration: Duration(seconds: widget.track.duration),
        artUri: Uri.parse(widget.track.coverImageUrl),
        extras: {'source': source}));

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
    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(widget.track.songId))) {
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile(
                  'https://138.68.163.236:8787/track/${widget.track.songId}',
                  '$dir/${widget.track.songId}',
                  "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: widget.track.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${widget.track.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${widget.track.songId}/main.m3u8';

      await parseHLS.updateLocalM3u8(m3u8FilePath);
      print("mediaItems: ${mediaItems}");
      print("the file is downloaded playing from local: ${mediaItems}");
      await parseHLS.writeLocalM3u8File(m3u8FilePath);
    }

    await _startPlaying(mediaItems);
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
