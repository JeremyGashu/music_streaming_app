import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloaded_page.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloading_page.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadsPage> {
  Future<List<LocalDownloadTask>> tasks;
  Future<List<LocalDownloadTask>> downloadedTasks;

  @override
  void initState() {
    tasks = getIt<UserDownloadManager>().downloadTaskStream();
    downloadedTasks = getIt<UserDownloadManager>().downloadedTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Downloads",
              style: TextStyle(color: kBlack),
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelColor: kBlack,
              indicatorColor: kYellow,
              tabs: [
                Tab(
                  text: "Downloaded",
                ),
                Tab(
                  text: "In progress",
                )
              ],
            ),
          ),
          body: SafeArea(
            child: BlocListener<MediaDownloaderBloc, MediaDownloaderState>(
              listener: (context, state) {},
              child: TabBarView(children: [
                DownloadedPage(tasks: downloadedTasks),
                DownloadingPage(tasks: tasks)
              ]),
            ),
          )),
    );
  }
}
