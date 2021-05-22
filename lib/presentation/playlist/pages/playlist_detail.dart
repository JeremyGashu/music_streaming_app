import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/playlistStat.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/search_bar.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/upper_section.dart';
import 'package:http/http.dart' as http;

class PlaylistDetail extends StatefulWidget {
  final String albumId;
  PlaylistDetail({@required this.albumId}) : assert(albumId != null);

  @override
  _PlaylistDetailState createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  // SliderThemeData _sliderThemeData;

  var testData1 = '''
{
  "data": {
    "id": "id",
    "likes": 123,
    "title": "title",
    "release_date": "2012-02-27 13:27:00,123456789z",
    "artist_id": "artist_id",
    "album_id": "album_id",
    "cover_img_url": "https://images.template.net/wp-content/uploads/2016/05/17050744/DJ-Album-Cover-Template-Sample.jpg?width=100",
    "track_url": "http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8/tears-of-steel-audio_eng=64008.m3u8",
    "views": 123,
    "duration": 300000,
    "lyrics_url": "lyrics_url",
    "created_by": "created_by" 
  },
  "success": true,
  "status": 200
}
''';

  var testData2 = '''
{
  "data": {
    "id": "id3",
    "likes": 123,
    "title": "title2",
    "release_date": "2012-02-27 13:27:00,123456789z",
    "artist_id": "artist_id",
    "album_id": "album_id",
    "cover_img_url": "https://images.template.net/wp-content/uploads/2016/05/17050744/DJ-Album-Cover-Template-Sample.jpg?width=100",
    "track_url": "https://138.68.163.236:8787/track/1",
    "views": 123,
    "duration": 300000,
    "lyrics_url": "lyrics_url",
    "created_by": "created_by" 
  },
  "success": true,
  "status": 200
}
''';


  TrackDataProvider trackDataProvider =
      TrackDataProvider(client: http.Client());
  List<Track> tracks = [];
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool _isPlaying = false;

  @override
  void initState() {
    var track1 = Track.fromJson(jsonDecode(testData1));
    var track2 = Track.fromJson(jsonDecode(testData2));
    tracks.addAll([track1, track2]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // _sliderThemeData = SliderTheme.of(context).copyWith(
    //   trackHeight: 2.0,
    // );
    super.didChangeDependencies();
  }

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
                    onPressed: () {},
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
                height: 320,
                child: StreamBuilder(
                    stream: AudioService.currentMediaItemStream,
                    builder: (context, AsyncSnapshot<MediaItem> snapshot) {
                      print("Snapshot: ${snapshot.data}");
                      print(snapshot.hasData &&
                          (snapshot.data.id == tracks[0].data.id));
                      return StreamBuilder(
                        stream: AudioService.playbackStateStream,
                        builder: (context,
                                AsyncSnapshot<PlaybackState>
                                    playbackSnapshot) =>
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tracks.length,
                                itemBuilder: (context, index) {
                                  return musicTile(tracks[index], () {
                                    print("play playlist");
                                    playAudio(index, sharedPreferences);
                                  },
                                      snapshot.hasData &&
                                          (snapshot.data.id ==
                                              tracks[index].data.id) &&
                                          playbackSnapshot.hasData &&
                                          playbackSnapshot.data.playing);
                                }),
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
                if (snapShotData != AudioProcessingState.stopped &&
                    snapShotData != AudioProcessingState.none) {
                  return bottomPlayer(playing: snapshot.data.playing);
                }
              }
              return SizedBox();
            },
          ),
        ),
      ]),
    ));
  }

  Widget bottomPlayer({bool playing}) {
    return StreamBuilder(
      stream: AudioService.queueStream,
      builder: (context, AsyncSnapshot<List<MediaItem>> snapshot) =>
          StreamBuilder(
        stream: AudioService.currentMediaItemStream,
        builder: (context, AsyncSnapshot<MediaItem> currentMediaSnapshot) =>
            Wrap(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0, 3))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // SliderTheme(
                      //   data: _sliderThemeData.copyWith(
                      //     trackHeight: 2.0,
                      //     activeTrackColor: Colors.red.shade300,
                      //     thumbColor: Colors.red.shade300,
                      //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      //     overlayColor: Colors.red.withAlpha(36),
                      //     overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                      //     inactiveTrackColor: Colors.transparent,
                      //   ),
                      //   child: Slider(
                      //     value: 0,
                      //     onChanged: (val) {},
                      //     min: 0,
                      //     max: 100,
                      //     activeColor: kRed,
                      //     inactiveColor: Colors.white,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisSize: MainAxisSize.max,
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       "01:25",
                            //     ),
                            //     Text(
                            //       "05:00",
                            //     ),
                            //   ],
                            // ),
                            StreamBuilder(
                              stream: AudioService.currentMediaItemStream,
                              builder: (context,
                                      AsyncSnapshot<MediaItem> snapshot) =>
                                  Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(children: [
                                  currentMediaSnapshot.hasData
                                      ? Text(
                                          "${currentMediaSnapshot.data.artist}:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "-----",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  currentMediaSnapshot.hasData
                                      ? Text(
                                          "${currentMediaSnapshot.data.title}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      : Text(
                                          "-----",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white54,
                            ),
                            _controlButtonsRow(playing),
                            Divider(
                              color: Colors.white54,
                            ),
                            () {
                              if (snapshot.hasData &&
                                  currentMediaSnapshot.hasData) {
                                var _currentIndex = snapshot.data
                                    .indexOf(currentMediaSnapshot.data);
                                print("current index: $_currentIndex");
                                if ((_currentIndex <
                                        snapshot.data.length - 1) &&
                                    _currentIndex != -1) {
                                  MediaItem nextMediaItem =
                                      snapshot.data[_currentIndex + 1];
                                  return _nextUpRow(nextMediaItem);
                                } else {
                                  return SizedBox();
                                }
                              } else {
                                return SizedBox();
                              }
                            }()
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _nextUpRow(MediaItem mediaItem) {
    return Row(
      children: [
        Icon(
          Icons.queue_music,
          color: kRed,
          size: 30.0,
        ),
        Text(
          "Next: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "${mediaItem.artist}-${mediaItem.title}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Widget _controlButtonsRow(bool playing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(Icons.shuffle, color: Colors.orange.shade300),
        GestureDetector(
          onTap: () async {
            await AudioService.skipToPrevious();
          },
          child: Icon(
            Icons.skip_previous,
            size: 34,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (playing) {
              AudioService.pause();
            } else {
              // play(widget.track, preferences);
              AudioService.play();
            }
            setState(() {
              _isPlaying = !_isPlaying;
            });
            print("SingleTrackPlayerPage[isPlaying]: ${_isPlaying}");
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.orange.shade300),
            child: playing
                ? Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 38,
                  )
                : Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 38,
                  ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await AudioService.skipToNext();
          },
          child: Icon(
            Icons.skip_next,
            size: 34,
          ),
        ),
        Icon(
          Icons.repeat,
          color: Colors.orange.shade300,
        )
      ],
    );
  }

  void playAudio(int index, SharedPreferences prefs) async {
    if(AudioService.playbackState.playing){
      if(tracks[index].data.id == AudioService.currentMediaItem.id){
        print("PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.push(context, MaterialPageRoute(builder:(context) =>SingleTrackPlayerPage(track: tracks[index])));
        return;
      }
    }

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print("audio service not running");
      int pos = sharedPreferences.getInt('position');
      Duration position = Duration(seconds: 0);
      if(pos!=null){
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
            builder: (context) => SingleTrackPlayerPage(track: tracks[index])));
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    print("tracks length: ${tracks.length}");
    print("index: $index");
    print("tracks: ${tracks}");

    for (Track track in tracks) {
      String source = track.data.trackUrl;
      if (await LocalHelper.isFileDownloaded(track.data.id)) {
        print("${track.data.id}: downloaded");
        source = '$dir/${track.data.id}/main.m3u8';
      }

      print("Source: $source");
      mediaItems.add(MediaItem(
          id: track.data.id,
          album: track.data.albumId,
          title: track.data.title,
          genre: 'genre goes here',
          artist: track.data.artistId,
          duration: Duration(milliseconds: track.data.duration),
          artUri: Uri.parse(track.data.coverImgUrl),
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
    var _trackToPlay = tracks[index];
    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(_trackToPlay.data.id))) {
      // var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile(_trackToPlay.data.trackUrl,
                  '$dir/${_trackToPlay.data.id}', "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: _trackToPlay.data.id,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${_trackToPlay.data.id}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';

      /// TODO: uncomment for encryption key download
      await parseHLS.updateLocalM3u8(m3u8FilePath);
      print("mediaItems: ${mediaItems}");
      print("the file is downloaded playing from local: ${mediaItems[index]}");
      await parseHLS.writeLocalM3u8File(m3u8FilePath);
    }

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
