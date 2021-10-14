import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';

import '../../../locator.dart';

class CreatePrivatePlaylistWidget extends StatefulWidget {
  @override
  _CreatePrivatePlaylistWidgetState createState() =>
      _CreatePrivatePlaylistWidgetState();
}

class _CreatePrivatePlaylistWidgetState
    extends State<CreatePrivatePlaylistWidget> {
  final PlaylistBloc playlistBloc = sl<PlaylistBloc>();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo make another bloc for this and load the items from here

    return BlocConsumer<PlaylistBloc, PlaylistState>(
        bloc: playlistBloc,
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                    content: CustomAlertDialog(
                  type: AlertType.ERROR,
                  message: 'Error creating playlist',
                )));
          }
          if (state is SuccessState) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                    content: CustomAlertDialog(
                  type: AlertType.SUCCESS,
                  message: 'Playlist created!',
                )));
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 265,
              width: kWidth(context),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 10, right: 10, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: SvgPicture.asset('assets/svg/playlist.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: _controller,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          alignLabelWithHint: true,
                          hintText: 'Create a name for your playlist',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    state is LoadingState
                        ? Center(
                            child: SpinKitRipple(
                              color: Colors.grey,
                              size: 40,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    String title = _controller.value.text;
                                    if (title != '') {
                                      playlistBloc.add(
                                          CreatePrivatePlaylist(title: title));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Playlist name cannot be empty!!')));
                                    }
                                  },
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange,
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Continue',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
