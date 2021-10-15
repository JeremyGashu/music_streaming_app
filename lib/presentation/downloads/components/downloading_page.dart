import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/downloads/widgets/download_list_item.dart';

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
                .map((item) => DownloadListItem(downloadTask: item))
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
