import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/downloads/widgets/download_list_item.dart';

class DownloadingPage extends StatefulWidget {
  final Future<List<LocalDownloadTask>> tasks;
  DownloadingPage({@required this.tasks}) : assert(tasks != null);

  @override
  _DownloadingPageState createState() => _DownloadingPageState();
}

class _DownloadingPageState extends State<DownloadingPage> {
  @override
  Widget build(BuildContext context) {
    // Future<List<LocalDownloadTask>> tasks =
    //     getIt<UserDownloadManager>().downloadTaskStream();

    return Center(
        child: BlocConsumer<MediaDownloaderBloc, MediaDownloaderState>(
      listener: (context, state) {
        if (state is DownloadDeleted) {

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessengerState()
                  .showSnackBar(SnackBar(content: Text("Download deleted")));
            });
          }
        print("DOWNLOADING_PAGE: LISTENER ${state.toString()}");
      },
      builder: (context, state) {
        return FutureBuilder(
          future: getIt<UserDownloadManager>().downloadTaskStream(),
          builder: (context, AsyncSnapshot<List<LocalDownloadTask>> snapshot) {
            if (snapshot.hasData) {
              print("Download data :${snapshot.data}");
              if (snapshot.data.isEmpty) {
                return Text("You don't have ongoing download tasks");
              }
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    if (index < snapshot.data.length - 1) {
                      return Divider();
                    } else {
                      return SizedBox();
                    }
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      DownloadListItem(downloadTask: snapshot.data[index]));
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
      },
    ));
  }
}
