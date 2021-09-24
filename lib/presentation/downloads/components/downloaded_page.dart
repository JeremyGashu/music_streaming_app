import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/downloads/widgets/download_list_item.dart';

class DownloadedPage extends StatefulWidget {
  final Future<List<LocalDownloadTask>> tasks;
  DownloadedPage({@required this.tasks}) : assert(tasks != null);

  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  @override
  Widget build(BuildContext context) {
    var tasks = getIt<UserDownloadManager>().downloadedTasks();

    return Center(
      child: BlocConsumer<UserDownloadBloc, UserDownloadState>(
        listener: (context, state) {
          print(state.toString());
          print("HEREHERERERER");
          if (state is DownloadDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessengerState()
                  .showSnackBar(SnackBar(content: Text("Download deleted")));
            });
          }
        },
        builder: (context, state) {
          return FutureBuilder(
            future: getIt<UserDownloadManager>().downloadedTasks(),
            builder:
                (context, AsyncSnapshot<List<LocalDownloadTask>> snapshot) {
              if (snapshot.data.isEmpty) {
                return Text("You don't have any downloaded tasks");
              }
              if (snapshot.hasData) {
                print("Download data :${snapshot.data}");
                return Container(
                  color: Colors.white,
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        if (index < snapshot.data.length - 1) {
                          return Divider();
                        } else {
                          return SizedBox();
                        }
                      },
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => DownloadListItem(
                            downloadTask: snapshot.data[index],
                            completed: true,
                          )),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("something went wrong");
              } else {
                return SpinKitFadingCircle(
                  color: kYellow,
                  size: 30,
                );
              }
            },
          );
        },
      ),
    );
  }
}
