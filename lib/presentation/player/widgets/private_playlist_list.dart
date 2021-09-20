import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';

class PrivatePlaylistList extends StatefulWidget {
  @override
  _PrivatePlaylistListState createState() => _PrivatePlaylistListState();
}

class _PrivatePlaylistListState extends State<PrivatePlaylistList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo make another bloc for this and load the items from here
    BlocProvider.of<PlaylistBloc>(context).add(GetPrivatePlaylists());

    return BlocConsumer<PlaylistBloc, PlaylistState>(
        listener: (context, state) {
      if (state is LoadedPrivatePlaylist) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Loaded Private playlist!')));
      }
      if (state is LoadingState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Loading Private playlist!')));
      }

      if (state is LoadingPlaylistError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Loading Private playlist Error!')));
      }
    }, builder: (context, state) {
      return Container(
        height: kHeight(context) * 0.6,
        width: kWidth(context) * 0.8,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildOnState(context, state),
              ),
              Spacer(),
              Divider(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOnState(BuildContext context, PlaylistState state) {
    if (state is LoadingState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: SpinKitRipple(
          size: 40,
          color: Colors.grey,
        )),
      );
    } else if (state is LoadedPrivatePlaylist) {
      return ListView.builder(
          itemCount: state.playlists.length,
          itemBuilder: (context, index) {
            //yield listile and add sending state from here
            return Text(state.playlists[index].title);
          });
    } else if (state is ErrorState) {
      return CustomErrorWidget(
          onTap: () {
            BlocProvider.of<PlaylistBloc>(context).add(GetPrivatePlaylists());
          },
          message: 'Error Loading Playlists!');
    }
    return Container();
  }
}
