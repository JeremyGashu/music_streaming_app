import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';

import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart'
    as udb;
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart'
    as uds;
import 'package:streaming_mobile/core/app/size_configs.dart';

import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/imports.dart';
import 'package:streaming_mobile/presentation/album/pages/liked_albums.dart';
import 'package:streaming_mobile/presentation/artist/pages/liked_artists.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/library/widgets/recent_musics.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/pages/private_playlists_page.dart';
import 'package:streaming_mobile/presentation/tracks/liked_songs.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  initState() {
    super.initState();
    FocusNode myFocusNode = FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context).isCurrent) {
        myFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100].withOpacity(0.5),
      body: SafeArea(
        child: BlocBuilder<udb.UserDownloadBloc, uds.UserDownloadState>(
            builder: (context, userDownloadState) {
          return BlocBuilder<MediaDownloaderBloc, MediaDownloaderState>(
              builder: (context, state) {
            return CustomScrollView(
              // mainAxisSize: MainAxisSize.min,
              slivers: [
                // SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: 15,
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 18, right: 18),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPlayListTopOptionsItem(
                            'assets/svg/album_library.svg', () {
                          Navigator.pushNamed(
                              context, LikedAlbumsPage.likedAlbumsRouteName);
                        }, 'Albums', 1.0),
                        _buildPlayListTopOptionsItem(
                            'assets/svg/song_library.svg', () {
                          Navigator.pushNamed(
                              context, LikedSongsPage.likedSongsPage);
                        }, 'Songs', 1.0),
                        _buildPlayListTopOptionsItem(
                            'assets/svg/playlist_library.svg', () {
                          Navigator.pushNamed(context,
                              PrivatePlaylistsPage.privatePlaylistRouteName);
                        }, 'Playlists', 1.0),
                        _buildPlayListTopOptionsItem(
                            'assets/svg/artist_library.svg', () {
                          Navigator.pushNamed(
                              context, LikedArtistsPage.likedArtistsRouteName);
                        }, 'Artists', 1.0),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 15,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SectionTitle(
                    callback: () {},
                    title: 'Recent songs',
                    hasMore: false,
                  ),
                ),

                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 10,
                )),
                SliverToBoxAdapter(
                  child: RecentSongs(),
                ),
              ],
            );
          });
        }),
      ),
    );
  }

  _buildPlayListTopOptionsItem(svg, onPressed, text, opacity) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 120,
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // padding: EdgeInsets.all(5),
              child: Opacity(
                opacity: opacity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: SvgPicture.asset(
                    svg,
                    height: getHeight(70),
                    width: getWidth(70),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              text,
              style: TextStyle(
                  letterSpacing: 1.01,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  void playAudio(BuildContext context, Track track) async {
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
      // create mediaItem list
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
      if (!(await LocalHelper.isFileDownloaded(track.songId)) ||
          !(await LocalHelper.allSegmentsDownloaded(id: track.songId))) {
        BlocProvider.of<udb.UserDownloadBloc>(context)
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
          BlocProvider.of<udb.UserDownloadBloc>(context)
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
