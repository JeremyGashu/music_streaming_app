import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';

class DownloadingPage extends StatelessWidget {
  final Future<List<LocalDownloadTask>> tasks;
  DownloadingPage({@required this.tasks}) : assert(tasks != null);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocConsumer<MediaDownloaderBloc, MediaDownloaderState>(
            listener: (context, state) {
              print("HERE_HERE");
            },
          buildWhen: (previous, current) => true,
          listenWhen: (previous, current) => true,
            builder: (context, state) => Text(state.toString()),));
  }
}
