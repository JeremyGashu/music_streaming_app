import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_bloc.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_event.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_state.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloaded_page.dart';
import 'package:streaming_mobile/presentation/library/widgets/recent_musics.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

import '../../locator.dart';

class LikedSongsPage extends StatefulWidget {
  static const String likedSongsPage = 'liked_pongs_page';
  @override
  _LikedSongsPageState createState() => _LikedSongsPageState();
}

class _LikedSongsPageState extends State<LikedSongsPage> {
  final List<Track> _tracks = [];

  final ScrollController _scrollController = ScrollController();

  LikedSongsBloc likedSongsBloc;
  @override
  void initState() {
    likedSongsBloc = sl<LikedSongsBloc>();
    likedSongsBloc.add(LoadLikedSongs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          //back button and search page
          SliverToBoxAdapter(child: _upperSection(context)),
          // Divider(),
          SliverToBoxAdapter(
            child: SectionTitle(
                hasMore: false, title: 'Favourites', callback: () {}),
          ),
          SliverToBoxAdapter(
            child: BlocConsumer<LikedSongsBloc, LikedSongsState>(
                bloc: likedSongsBloc,
                listener: (context, state) {
                  if (state is ErrorState) {
                    likedSongsBloc.isLoading = false;
                  }
                  return;
                },
                builder: (context, state) {
                  if (state is LoadedLikedSongs) {
                    _tracks.addAll(state.tracks);
                    likedSongsBloc.isLoading = false;
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  } else if (state is InitialState ||
                      state is LoadingState && _tracks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 30),
                        child: SpinKitRipple(
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  } else if (state is ErrorState && _tracks.isEmpty) {
                    return Center(
                      child: CustomErrorWidget(
                          onTap: () {
                            likedSongsBloc.add(LoadLikedSongs());
                          },
                          message: 'Error Loading Tracks!'),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView(
                        controller: _scrollController
                      ..addListener(() {
                        if (_scrollController.offset ==
                                _scrollController
                                    .position.maxScrollExtent &&
                            !likedSongsBloc.isLoading) {
                          if (likedSongsBloc.state is LoadedLikedSongs) {
                            if ((likedSongsBloc.state as LoadedLikedSongs)
                                    .tracks
                                    .length ==
                                0) return;
                          }
                          likedSongsBloc
                            ..isLoading = true
                            ..add(LoadLikedSongs());
                        }
                      }),
                        shrinkWrap: true,
                        children: _tracks.map((track) {
                      return musicTile(track, context);
                        }).toList(),
                      ),
                      state is LoadingState
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedLikedSongs
                          ? state.tracks.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25),
                                  child: Text('No More Tracks!'),
                                )
                              : Container()
                          : Container(),
                    ],
                  );
                }),
          ),

          SliverToBoxAdapter(
            child: SectionTitle(
              callback: () {},
              title: 'Recent songs',
              hasMore: false,
            ),
          ),

          // SliverToBoxAdapter(
          //     child: SizedBox(
          //   height: 15,
          // )),
          SliverToBoxAdapter(
            child: RecentSongs(),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 10,
          )),
          SliverToBoxAdapter(
            child: SectionTitle(
                hasMore: false, title: 'Downloaded', callback: () {}),
          ),
          SliverToBoxAdapter(child: DownloadedPage()),
        ],
      ),
    ));
  }
}

Widget _upperSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      Text(
        'My Songs',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 20,
          ),
          onPressed: () {},
        ),
      ),
    ],
  );
}
