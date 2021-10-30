import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/imports.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloaded_page.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloading_page.dart';

class DownloadsPage extends StatefulWidget {
  static const String downloadsPageRouteName = 'downloads_page_route_name';
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Downloads',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: BlocConsumer<MediaDownloaderBloc, MediaDownloaderState>(
          listener: (c, mds) async {
        if (mds is DownloadDone) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Download finished!')));

          //==============================================================================
          //read the saved StringList preference and start the download if it is not empty
          // SharedPreferences preferences = await SharedPreferences.getInstance();
          // List<String> currentDownloads =
          //     preferences.getStringList('download_medias');
          // print('current downloads => ${currentDownloads.toString()}');
          // if (currentDownloads != null && currentDownloads.isNotEmpty) {
          //   currentDownloads.forEach((element) async {
          //     bool downloaded = await LocalHelper.isFileDownloaded(element);
          //     if (!downloaded) {
          //       Track track =
          //           await UserDownloadManager.getTrackByIdFromRemote(element);
          //       BlocProvider.of<UserDownloadBloc>(context)
          //           .add(StartDownload(track: track));
          //     }
          //   });
          //   await preferences.remove('download_medias');
          //   //===============================================================================
          // }
        } else if (mds is DownloadStarted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Downloading...'),
            action: SnackBarAction(
                textColor: Colors.orange,
                label: 'View',
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(DownloadsPage.downloadsPageRouteName);
                }),
          ));
        }
      }, builder: (context, userDownloaderState) {
        return BlocConsumer<UserDownloadBloc, UserDownloadState>(
            listener: (context, userDownloaderState) {
          if (userDownloaderState is DownloadDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Download deleted!')));
            });
          }
        }, builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: DownloadingPage()),
              SliverToBoxAdapter(
                child: FutureBuilder(
                    future: getIt<UserDownloadManager>().downloadTaskStream(),
                    builder:
                        (context, AsyncSnapshot<List<LocalDownloadTask>> s) {
                      if (s.hasData && s.data.length != 0) {
                        return Divider();
                      }
                      return SizedBox();
                    }),
              ),
              SliverToBoxAdapter(child: DownloadedPage()),
              SliverToBoxAdapter(
                child: BackgroundDownloadedSongs(),
              )
            ],
          );
        });
      }),
    );
  }
}

class BackgroundDownloadedSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        // future: ,
        builder: (context, snapshot) {
      return Container();
    });
  }
}
