import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/track.dart';

Widget musicTile(
  Track music,
  Function onPressed,
  BuildContext context, [
  isPlaying = false,
  MediaItem mediaItem,
]) {
  return BlocListener<UserDownloadBloc, UserDownloadState>(
    listener: (c, state) {
      if (state is DownloadFailed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
            // Future.delayed(Duration(seconds: 2));
        // if (state.id != null || state.id != '') {
        //   BlocProvider.of<UserDownloadBloc>(context)
        //       .add(UserRetryDownload(track: music));
        // }
      }
    },
    child: GestureDetector(
      onTap: () {
        onPressed();
      },
      child: ListTile(
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
                    : mediaItem.artUri.toString(),
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: Text(
          music != null
              ? music.title != null
                  ? music.title
                  : "-------"
              : mediaItem.title != null
                  ? mediaItem.title
                  : "-------",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: 18,
            letterSpacing: 1.01,
          ),
        ),
        subtitle: Text(
          music != null
              ? music.title
              : mediaItem.artist != null
                  ? mediaItem.artist
                  : "-----",
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 14,
            letterSpacing: 1.01,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isPlaying
                ? Row(
                    children: [
                      Image.asset(
                        "assets/images/playing_wave.gif",
                        height: 20,
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
                      : mediaItem.duration)
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
                      var status = await Permission.storage.status;
                      if (status.isGranted) {
                        if (snapshot.hasData && snapshot.data) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Already Downloaded!')));
                          return;
                        }

                        if (await LocalHelper.downloadAlreadyAdded(music.songId)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Download Already Added!')));
                          return;
                        }
                        // if()
                        BlocProvider.of<UserDownloadBloc>(context)
                            .add(StartDownload(track: music));
                        return;
                      } else {
                        PermissionStatus stat =
                            await Permission.storage.request();
                        if (stat == PermissionStatus.granted) {
                          if (snapshot.hasData && snapshot.data) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Already Downloaded!')));
                            return;
                          }
                          if (await LocalHelper.downloadAlreadyAdded(music.songId)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Download Already Added!')));
                            return;
                          }
                          BlocProvider.of<UserDownloadBloc>(context)
                              .add(StartDownload(track: music));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please grant permission to download files!')));
                        }
                      }
                    },
                    icon: Icon(
                      Icons.file_download,
                      color: snapshot.hasData && snapshot.data
                          ? Colors.orange
                          : Colors.grey,
                      size: 20,
                    ),
                  );
                })
          ],
        ),
      ),
    ),
  );
}
