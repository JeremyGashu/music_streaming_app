import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:test/test.dart';

void main() async{

  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );
  group('MediaDownloaderBloc', (){
    MediaDownloaderBloc mediaDownloaderBloc;
    
    setUp((){
      mediaDownloaderBloc = MediaDownloaderBloc();
    });
    //
    test('initial state is DownloadOnProgressState', (){
      expect(mediaDownloaderBloc.state, DownloadOnProgressState());
    });
  });
}