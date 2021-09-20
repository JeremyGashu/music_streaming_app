import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_tracks.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100].withOpacity(0.5),
      body: SafeArea(
        child: CustomScrollView(
          // mainAxisSize: MainAxisSize.min,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayListTopOptionsItem(
                      'assets/svg/album_new.svg', () {}, 'Albums', 1.0),
                  _buildPlayListTopOptionsItem(
                      'assets/svg/songs_new.svg', () {}, 'Songs', 0.6),
                  _buildPlayListTopOptionsItem(
                      'assets/svg/playlist_new.svg', () {}, 'Playlists', 0.6),
                  _buildPlayListTopOptionsItem(
                      'assets/svg/artists_new.svg', () {}, 'Artists', 1.0),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),

            SliverToBoxAdapter(
              child: SectionTitle(
                  callback: () {
                    Navigator.pushNamed(context,
                        AllNewReleaseTracks.allNewReleaseTracksRouterName);
                  },
                  title: 'Newly Released Songs'),
            ),

            SliverToBoxAdapter(
                child: SizedBox(
              height: 20,
            )),
            SliverToBoxAdapter(
              child: BlocBuilder<NewReleaseBloc, NewReleaseState>(
                  builder: (context, state) {
                if (state is LoadedNewReleases) {
                  return StreamBuilder(
                      stream: AudioService.currentMediaItemStream,
                      builder: (context, AsyncSnapshot<MediaItem> snapshot) {
                        // print("Snapshot: ${snapshot.data}");
                        // print(snapshot.hasData &&
                        //     (snapshot.data.id ==
                        //         track.songId));
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
                                  itemCount: state.newRelease.songs.length,
                                  itemBuilder: (context, index) {
                                    var track =
                                        state.newRelease.songs[index].song;
                                    return musicTile(track, () {
                                      playAudio(context, track);
                                    },
                                        snapshot.hasData &&
                                            (snapshot.data.id ==
                                                track.songId) &&
                                            playbackSnapshot.hasData &&
                                            playbackSnapshot.data.playing);
                                  }),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        );
                      });
                } else if (state is LoadingNewReleasesError) {
                  return CustomErrorWidget(
                      onTap: () {
                        BlocProvider.of<NewReleaseBloc>(context)
                            .add(LoadNewReleasesInit());
                      },
                      message: 'Error Loading New Songs!');
                } else if (state is LoadingNewReleases) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 70,
                    ),
                  );
                }
                return Container();
              }),
            ),
            // SizedBox(
            //   height: 20.0,
            // ),
            // _sectionTitle(title: 'Newly Released Songs', callback: () {}),
            // SizedBox(
            //   height: 20.0,
            // ),
            // ListView(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   children: [
            //     _trackListItem(),
            //     _trackListItem(),
            //     _trackListItem(),
            //     _trackListItem(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  _buildPlayListTopOptionsItem(svg, onPressed, text, opacity) {
    return Container(
      height: 120,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(20),
            child: Opacity(
              opacity: opacity,
              child: SvgPicture.asset(
                svg,
                color: Colors.grey[900],
                height: 38,
                width: 38,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            text,
            style: TextStyle(
                letterSpacing: 1.01, fontSize: 14, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  // _trackListItem() {
  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 10, left: 16.0, right: 16.0),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         _imageWithDetailRow(),
  //         Spacer(),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               '04:13',
  //               style: TextStyle(
  //                   letterSpacing: 1,
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w400,
  //                   color: Color(0x882D2D2D)),
  //             ),
  //             IconButton(
  //               icon: Icon(Icons.more_vert),
  //               onPressed: () {},
  //               color: Color(0x882D2D2D),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Row _imageWithDetailRow() {
  //   return Row(
  //     children: [
  //       Row(
  //         children: [
  //           _customClippedImage(),
  //           SizedBox(
  //             width: 16,
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Amelkalew',
  //                 style: TextStyle(
  //                     letterSpacing: 1.2,
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xDD2D2D2D)),
  //               ),
  //               Text(
  //                 'Dawit Getachew',
  //                 style: TextStyle(
  //                     letterSpacing: 1,
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w400,
  //                     color: Color(0x882D2D2D)),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Container _customClippedImage() {
  //   return Container(
  //       height: 50,
  //       width: 50,
  //       decoration:
  //           BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
  //         BoxShadow(
  //           offset: Offset(0, 2),
  //           blurRadius: 2,
  //           color: Color(0x882D2D2D),
  //         )
  //       ]),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(10),
  //         child: Image(
  //           image: AssetImage('assets/images/artist_two.jpg'),
  //           fit: BoxFit.cover,
  //         ),
  //       ));
  // }

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
    Navigator.pushNamed(
        context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
        arguments: track);
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    // print("tracks length: ${widget.tracks.length}");
    // print("index: $index");
    // print("tracks: ${widget.tracks}");
    // print("trackId: ${widget.tracks[0].songId}");
    // print("songId: ${widget.tracks[0].songId}");

    String source = 'https://138.68.163.236:8787/track/${track.songId}';

    if (await LocalHelper.isFileDownloaded(track.songId)) {
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
    if (!(await LocalHelper.isFileDownloaded(track.songId))) {
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile(
                  'https://138.68.163.236:8787/track/${track.songId}',
                  '$dir/${track.songId}',
                  "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: track.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${track.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${track.songId}/main.m3u8';

      /// TODO: uncomment for encryption key download
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
