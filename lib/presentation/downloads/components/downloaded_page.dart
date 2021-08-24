import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/downloads/widgets/download_list_item.dart';

class DownloadedPage extends StatefulWidget {
  final Future<List<LocalDownloadTask>> tasks;
  DownloadedPage({@required this.tasks}):assert(tasks != null);

  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<UserDownloadBloc, UserDownloadState>(
      listenWhen: (previous, current) => true,
      listener: (context, state) {
        if(state is DownloadDeleted){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessengerState().showSnackBar(SnackBar(content: Text("Download deleted")));
          });
        }
      },
      child: FutureBuilder(
        future: widget.tasks,
        builder: (context, AsyncSnapshot<List<LocalDownloadTask>> snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data[0].coverImageUrl);
            return Container(
              color: Colors.white,
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    if(index < snapshot.data.length-1){
                      return Divider();
                    }else{
                      return SizedBox();
                    }
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => DownloadListItem(downloadTask: snapshot.data[index])),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text(
                "something went wrong"
            );
          } else {
            return SpinKitFadingCircle(
              color: Colors.yellow,
              size: 30,
            );
          }
        },
      ),
    );
  }
}