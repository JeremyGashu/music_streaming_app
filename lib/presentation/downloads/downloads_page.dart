import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
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
      body: SafeArea(
        child: BlocConsumer<MediaDownloaderBloc, MediaDownloaderState>(
            listener: (c, mds) {
          if (mds is DownloadDone) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Download finished!')));
          } else if (mds is DownloadStarted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Downloading...'),
              action: SnackBarAction(
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
                SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: DownloadedPage()),
                SliverToBoxAdapter(
                  child: BackgroundDownloadedSongs(),
                )
              ],
            );
          });
        }),
      ),
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
