import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:streaming_mobile/data/models/download_task.dart' as smd;
import 'media_downloader_event.dart';
import 'media_downloader_state.dart';

class Task {
  smd.DownloadTask downloadTask;
  String taskId;

  Task({this.downloadTask, this.taskId});
}

class MediaDownloaderBloc
    extends Bloc<MediaDownloaderEvent, MediaDownloaderState> {
  ReceivePort _port = ReceivePort();
  List<Task> _tasks = [];
  // MediaDownloaderEvent _previousEvent;
  // Attach InitializeDownloader event when Instantiating the MediaDownloaderBloc;
  MediaDownloaderBloc() : super(DownloadOnProgressState()) {}

  // Handles download callback
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print('download callback');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  /// remove the background isolate binding
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  /// flutter downloader works in the background, this will subscribe to the
  /// background isolate and listens for the call back
  void _bindBackgroundIsolate(){
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if(!isSuccess){
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('////////////////////////////////////////////////////');
      print(data);
      String taskId = data[0];
      DownloadTaskStatus status = data[1];
      print(status);
      var _taskIndex =
      _tasks.indexWhere((element) => element.taskId == taskId);
      print('////////////////////////////////////////////////////');
      print('taskindex $_taskIndex');
      if (_taskIndex != -1) {
        if (status == DownloadTaskStatus.complete) {
          smd.DownloadTask _downloadTask = _tasks[_taskIndex].downloadTask;
          //
          // LocalDatabaseBloc localDatabaseBloc = LocalDatabaseBloc(mediaDownloaderBloc: this);
          // localDatabaseBloc.add(WriteToLocalDB(boxName: 'downloadTasks', key: '${_downloadTask.track_id}/${_downloadTask.segment_number}', value: _downloadTask));
          // check's if previous event is add download before changing state
          // if(_previousEvent is AddDownload){
          //   add(UpdateDownloadState(
          //       state: DownloadCompleted(downloadedTask: _downloadTask)));
          // }
          print('here');
          add(UpdateDownloadState(
              state: DownloadCompleted(downloadedTask: _downloadTask)));
          _tasks.removeAt(_taskIndex);
          if (_tasks.isNotEmpty) {
            // FlutterDownloader.cancelAll();
            print('here adfadfadfadfadfdf');
            addDownload(_tasks[0].downloadTask)
                .then((value) => _tasks[0].taskId = value);
            print('here 55555555555555555');
          } else {
            print('/////////////////////////////////////////');
            print('download done');
            add(UpdateDownloadState(state: DownloadDone()));
          }
        } else {
          // considering other states other than complete as failed
          // since no implementation is done for other states
          print('.//////////////////////// else');
          print(status);
          add(UpdateDownloadState(state: DownloadFailed()));
        }
      }
    });
    print('registering callback');
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Future<void> close() {
    /// remove the background isolate when bloc closes
    _unbindBackgroundIsolate();
    return super.close();
  }

  @override
  Stream<MediaDownloaderState> mapEventToState(
      MediaDownloaderEvent event) async* {
    try {
      // _previousEvent = event;
      yield DownloadOnProgressState();
      if (event is InitializeDownloader) {
        _bindBackgroundIsolate();
      } else if (event is AddDownload) {
        print('add download event');
        _handleClearDownload();
        if (_tasks.length == 0) {
          String taskId = await addDownload(event.downloadTasks.first);
          // map [DownloadTask to Task]
          _tasks.addAll(
            event.downloadTasks.map((smd.DownloadTask task) {
              if(task.url == event.downloadTasks.first.url)
              return Task(taskId: taskId, downloadTask: task);
              else
                return Task(taskId: '', downloadTask: task);
            }
            ).toList()
          );
          // _tasks.add(Task(downloadTask: event.downloadTask, taskId: taskId));
        }
      } else if (event is RetryDownload) {
        if (_tasks.isNotEmpty) {
          await FlutterDownloader.cancelAll();
          addDownload(_tasks[0].downloadTask)
              .then((value) => _tasks[0].taskId = value);
        } else {
          yield DownloadDone();
        }
      } else if (event is UpdateDownloadState) {
        yield event.state;
      } else if (event is ClearDownload) {
        // stops download and clear tasks
        _handleClearDownload();
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
    }
  }

  /// add download task to downloader
  Future<String> addDownload(smd.DownloadTask task) async {
    final taskId = await FlutterDownloader.enqueue(
      url: task.url,
      savedDir: task.download_path,
      showNotification:
          false, // click on notification to open downloaded file (for Android)
    );
    return taskId;
  }


  /// clear the download task
  void _handleClearDownload() {
    if (_tasks.length != 0) {
      FlutterDownloader.cancel(taskId: _tasks[0].taskId);
      FlutterDownloader.remove(
          taskId: _tasks[0].taskId, shouldDeleteContent: true);
      _tasks.clear();
    }
  }
}
