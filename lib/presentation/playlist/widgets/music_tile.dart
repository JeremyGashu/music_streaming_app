import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_bloc.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

Widget musicTile(Track music, BuildContext context,
    {bool addToRecentlySearhed = false, bool addToRecentlyPlayed = true, bool fromPlaylist = false}) {
  return BlocBuilder<CacheBloc, CacheState>(builder: (context, snapshot) {
    return BlocListener<UserDownloadBloc, UserDownloadState>(
      listener: (_, __) {},
      child: GestureDetector(
        onTap: () async {
          if (addToRecentlyPlayed) {
            var recentlyPlaedSongs =
                await Hive.openBox<Track>('recently_played_songs');
            bool added = false;
            recentlyPlaedSongs.values.forEach((song) {
              if (song.songId == music.songId) {
                added = true;
              }
            });
            if (!added) {
              await recentlyPlaedSongs.add(music);
            }

            print(
                'current recently played songs => ${recentlyPlaedSongs.values.length}');
          }
          if (addToRecentlySearhed) {
            var recentlySearchedSongs =
                await Hive.openBox<Track>('recently_searched');
            bool added = false;
            recentlySearchedSongs.values.forEach((song) {
              if (song.songId == music.songId) {
                added = true;
              }
            });
            if (!added) {
              await recentlySearchedSongs.add(music);
            }

            print(
                'current recently searched songs => ${recentlySearchedSongs.values.length}');
          }
          if(fromPlaylist) {
            print('play from mediaid and return');
            String currentlyPlayingId = await AudioService.currentMediaItem.id;
            if(music.songId != currentlyPlayingId) {
              await AudioService.playFromMediaId(music.songId);
            }
            else{
              Navigator.pushNamed(context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName);
            }
             return;
          }
          print('play from mediaid and return');
          playAudio(music, context);
        },
        child: StreamBuilder(
            stream: AudioService.currentMediaItemStream,
            builder: (context, AsyncSnapshot<MediaItem> mediaItemStream) {
              return StreamBuilder(
                  stream: AudioService.playbackStateStream,
                  builder:
                      (context, AsyncSnapshot<PlaybackState> playbackSnapshot) {
                    return ListTile(
                      leading: Card(
                        elevation: 3,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/images/album_one.jpg',
                                  fit: BoxFit.contain,
                                );
                              },
                              imageUrl: music != null
                                  ? music.coverImageUrl
                                  : mediaItemStream.data.artUri.toString(),
                              placeholder: (context, url) =>
                                  SpinKitRipple(color: Colors.orange,size: 20,),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        music.title ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 16,
                          letterSpacing: 1.01,
                        ),
                      ),
                      subtitle: Text(
                        music.artist != null
                            ? '${music.artist.firstName} ${music.artist.lastName}'
                            : 'Unkown Artist',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 13,
                          letterSpacing: 1.01,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (playbackSnapshot.hasData &&
                                  playbackSnapshot.data.playing &&
                                  mediaItemStream.data.id == music.songId)
                              ? Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/playing_wave.gif",
                                      height: 16,
                                      color: kRed,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                )
                              : SizedBox(),
                          Text(
                            prettyDuration(music != null
                                ? (music.duration != null
                                    ? Duration(seconds: music.duration)
                                    : mediaItemStream.data.duration)
                                : Duration(seconds: 0)),
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FutureBuilder<bool>(
                              future: LocalHelper.allDownloaded(music),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print('current data ${snapshot.data}');
                                }
                                return IconButton(
                                    onPressed: () async {
                                      var status =
                                          await Permission.storage.status;
                                      if (status.isGranted) {
                                        if (snapshot.hasData && snapshot.data) {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Already downloaded...')));
                                          return;
                                        }

                                        if (await LocalHelper
                                            .downloadAlreadyAdded(
                                                music.songId)) {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Download task exists...')));
                                          return;
                                        }
                                        // if()
                                        BlocProvider.of<UserDownloadBloc>(
                                                context)
                                            .add(StartDownload(track: music));
                                        return;
                                      } else {
                                        PermissionStatus stat =
                                            await Permission.storage.request();
                                        if (stat == PermissionStatus.granted) {
                                          if (snapshot.hasData &&
                                              snapshot.data) {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Already downloaded...')));
                                            return;
                                          }
                                          if (await LocalHelper
                                              .downloadAlreadyAdded(
                                                  music.songId)) {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Download task exists!')));
                                            return;
                                          }
                                          BlocProvider.of<UserDownloadBloc>(
                                                  context)
                                              .add(StartDownload(track: music));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please grant permission to download files!')));
                                        }
                                      }
                                    },
                                    icon: snapshot.hasData && snapshot.data
                                        ? Icon(
                                            Icons.file_download_done,
                                            color: Colors.orange,
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.file_download,
                                            color: Colors.grey,
                                            size: 20,
                                          ));
                              })
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  });
}

void playAudio(Track track, BuildContext context) async {
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
        genre: track.genre != null ?  '${track.genre.name}' : '',
        artist: track.artist != null ? '${track.artist.firstName} ${track.artist.lastName}' : 'Unknown Artist',
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
  } catch (e, st) {
    print(st);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error playing song')));
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
