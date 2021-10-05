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
import 'package:streaming_mobile/core/app/urls.dart';
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
    return Container(
      margin: EdgeInsets.only(
        left: 15,
      ),
      child: GestureDetector(
        onTap: () {
          /// Start playing the audio
          playAudio();
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
                elevation: 1.0,
                shadowColor: Colors.grey.withOpacity(0.5),
                // shadowColor: Colors.grey,
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
            SizedBox(
              height: 5,
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
                        color: Colors.grey,
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

  void playAudio() async {
    if (AudioService.playbackState.playing) {
      if (widget.track.songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.pushNamed(
            context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
            arguments: widget.track);
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
    Navigator.pushNamed(
        context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
        arguments: widget.track);
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    // print("tracks length: ${widget.tracks.length}");
    // print("index: $index");
    // print("tracks: ${widget.tracks}");
    // print("trackId: ${widget.tracks[0].songId}");
    // print("songId: ${widget.tracks[0].songId}");

    String source = '$M3U8_URL/${widget.track.songId}';

    if (await LocalHelper.isFileDownloaded(widget.track.songId) && await LocalHelper.allSegmentsDownloaded(id : widget.track.songId)) {
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

    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(widget.track.songId)) || !(await LocalHelper.allSegmentsDownloaded(id : widget.track.songId))) {
      File m3u8File = File('$dir/${widget.track.songId}/main.m3u8');
      HlsMediaPlaylist hlsPlayList ;
      if(m3u8File.existsSync()) {
        hlsPlayList = await parseHLS.parseHLS(m3u8File.readAsStringSync());
      }
      else{
        hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile('$M3U8_URL/${widget.track.songId}',
                  '$dir/${widget.track.songId}', "main.m3u8"))
          .readAsStringSync());
      }

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

      File file = File(m3u8FilePath);
      if (file.existsSync()) {
        
        await parseHLS.updateLocalM3u8(m3u8FilePath);
        print("mediaItems: ${mediaItems}");
        print("the file is downloaded playing from local: ${mediaItems}");
        await parseHLS.writeLocalM3u8File(m3u8FilePath);
      } else {
        HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
                await parseHLS.downloadFile('$M3U8_URL/${widget.track.songId}',
                    '$dir/${widget.track.songId}', "main.m3u8"))
            .readAsStringSync());

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
      }

      // await parseHLS.updateLocalM3u8(m3u8FilePath);
      // print("mediaItems: ${mediaItems}");
      // print("the file is downloaded playing from local: ${mediaItems}");
      // await parseHLS.writeLocalM3u8File(m3u8FilePath);
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
