import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';

import '../../../imports.dart';

class DownloadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<UserDownloadManager>().downloadTaskStream(),
      builder: (context, AsyncSnapshot<List<LocalDownloadTask>> snapshot) {
        if (snapshot.hasData) {
          print("Download data :${snapshot.data}");
          if (snapshot.data.isEmpty) {
            return Container();
          }
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data
                .map((item) => DownloadingTile(task: item))
                .toList(),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("something went wrong");
        } else {
          return SpinKitFadingCircle(
            color: Colors.yellow,
            size: 30,
          );
        }
      },
    );
  }
}

class DownloadingTile extends StatelessWidget {
  final LocalDownloadTask task;
  DownloadingTile({this.task});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          // padding: EdgeInsets.all(8),

          height: 80,
          width: kWidth(context) * (task.progress / 100),
          // width: kWidth(context) * 0.5,

          color: Colors.orange[200],
        ),
        Container(
          height: 80,
          padding: EdgeInsets.all(8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  task.coverImageUrl != null
                      ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/images/album_one.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                                imageUrl: task.coverImageUrl ?? '',
                                placeholder: (context, url) =>
                                    SpinKitRipple(
                                  color: Colors.orange,
                                  size: 10,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          // Container(
                          //   width: 48,
                          //   height: 48,
                          //   child: CircularProgressIndicator(
                          //     valueColor:
                          //         AlwaysStoppedAnimation<Color>(Colors.grey),

                          //     // valueColor: Colors.grey,
                          //   ),
                          // ),

                          const SpinKitRing(
                              size: 38,
                              color: Colors.grey,
                              lineWidth: 4,
                              duration: Duration(seconds: 2)),
                          Text(
                            '${task.progress.toStringAsFixed(0)}%',
                            style: TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ],
                      )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${task.title}',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  task.duration != null
                      ? Text(
                          prettyDuration(Duration(seconds: task.duration)),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        )
                      : Text(prettyDuration(Duration(seconds: 0))),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Cancel Download"),
                          content: Text("Do you want to cancel this download?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  BlocProvider.of<UserDownloadBloc>(context)
                                      .add(DeleteFailedDownload(
                                          track: task.toTrack()));
                                },
                                child: Text("Yes")),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),

                  // SizedBox(width: 5,),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
