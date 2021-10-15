import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/imports.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloaded_page.dart';
import 'package:streaming_mobile/presentation/downloads/components/downloading_page.dart';

class DownloadsPage extends StatefulWidget {
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: CustomAlertDialog(
                  type: AlertType.SUCCESS,
                  message: 'Download Finished!',
                )));
          } else if (mds is DownloadStarted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: CustomAlertDialog(
                  type: AlertType.SUCCESS,
                  message: 'Download Started!',
                )));
          }
        }, builder: (context, userDownloaderState) {
          return BlocConsumer<UserDownloadBloc, UserDownloadState>(
              listener: (context, userDownloaderState) {
            if (userDownloaderState is DownloadDeleted) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: CustomAlertDialog(
                      type: AlertType.SUCCESS,
                      message: 'Download Deleted!!',
                    )));
              });
            }
          }, builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: DownloadingPage()),
                SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: DownloadedPage()),
              ],
            );
          });
        }),
      ),
    );
  }
}
