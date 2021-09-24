import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

class DownloadListItem extends StatelessWidget {
  final LocalDownloadTask downloadTask;
  final bool completed;
  DownloadListItem({@required this.downloadTask, this.completed = false})
      : assert(downloadTask != null);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (downloadTask.progress == 100.0) {
          // playSingleTrack(context, Track(album: Album(albumId: null, artist: Artist(firstName: "None")), songId: downloadTask.songId, trackId: downloadTask.songId, song: Song(songId: downloadTask.songId, duration: downloadTask.duration, coverImageUrl: downloadTask.coverImageUrl)));

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SingleTrackPlayerPage(track: null),
          ));
        }
      },
      title: Text("${downloadTask.title}"),
      leading: Container(
        width: 40,
        height: 40,
        child: Image.network(
          downloadTask.coverImageUrl,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completed
                ? "completed"
                : "${downloadTask.progress.toStringAsFixed(1)} %",
          ),
          SizedBox(
            height: 5,
          ),
          completed
              ? SizedBox()
              : LinearProgressIndicator(
                  value: downloadTask.progress / 100,
                  color: kYellow,
                  backgroundColor: kYellow.withOpacity(0.2),
                )
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Delete file"),
              content: Text("Do you want to delete this file"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("no")),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<UserDownloadBloc>(context)
                          .add(DeleteDownload(trackId: downloadTask.songId));
                      Navigator.pop(context);
                    },
                    child: Text("yes")),
              ],
            ),
          );
        },
        icon: Icon(
          Icons.delete,
          size: 20,
        ),
      ),
    );
  }
}
