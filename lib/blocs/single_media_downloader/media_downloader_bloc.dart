import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
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
  Queue<List<smd.DownloadTask>> _downloadQueue = Queue();
  var queueBox = Hive.box<List<smd.DownloadTask>>("downloadQueue");

  MediaDownloaderBloc() : super(DownloadOnProgressState()) {
    _bindBackgroundIsolate();
  }

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
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      print('////////////////////////////////////////////////////');
      print(data);
      String taskId = data[0];
      DownloadTaskStatus status = data[1];
      print(status);
      var _taskIndex = _tasks.indexWhere((element) => element.taskId == taskId);
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
            addDownload(_tasks[0].downloadTask)
                .then((value) => _tasks[0].taskId = value);
          } else {
            print('/////////////////////////////////////////');
            print('download done');
            print(
                '//////// TODO now download the key as all the files are downloads');
            add(UpdateDownloadState(
                state: DownloadDone(downloadedTask: _downloadTask)));
             String m3u8Path = '${await LocalHelper.getLocalFilePath()}/${_downloadTask.track_id}/main.m3u8';
             LocalHelper.downloadKeyFile(m3u8Path).then((val) {
               if(val) {
                 print('key file is downloaded');
               }
               else{
                 print('key file is not downloaded');
               }
             });
            _checkQueueAndContinueDownload();
          }
        } else if (status == DownloadTaskStatus.running) {
          print('current status => ${status}');
           print(status);
          add(UpdateDownloadState(state: DownloadOnProgressState()));

        } else if (status == DownloadTaskStatus.failed) {
          smd.DownloadTask _downloadTask = _tasks[_taskIndex].downloadTask;
          print('current status => ${status}');
           print(status);
           
          add(UpdateDownloadState(state: DownloadFailed(_downloadTask.track_id)));

        } else {
          //   DownloadTaskStatus.failed
          // DownloadTaskStatus.paused

          print('.//////////////////////// else');
          print(status);
          // add(UpdateDownloadState(state: DownloadFailed()));
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
    queueBox.addAll(_downloadQueue);
    return super.close();
  }

  @override
  Stream<MediaDownloaderState> mapEventToState(
      MediaDownloaderEvent event) async* {
    try {
      // _previousEvent = event;
      yield DownloadOnProgressState();
      if (event is InitializeDownloader) {
        // _bindBackgroundIsolate();
        if (queueBox.isNotEmpty) {
          _downloadQueue.addAll(queueBox.values);
        }
      } else if (event is BeginDownload) {
        List<smd.DownloadTask> dt = [];

        if (_tasks.length == 0) {
          var length = event.downloadTasks.length;
          for (int i = 0; i < length; i++) {
            var element = event.downloadTasks[i];
            File file = File(
                element.download_path + 'main${element.segment_number}.ts');
            print(file.path);
            if (!(file.existsSync())) {
              dt.add(element);
              print("file doesn't exist");
            }
          }
          if (dt.isEmpty) {
            print(
                "MediaDownloaderBloc: download tasks empty or downloaded before");
            yield DownloadDone(downloadedTask: event.downloadTasks[0]);
            _checkQueueAndContinueDownload();
          } else {
            String taskId = await addDownload(dt.first);
            _tasks.addAll(dt.map((smd.DownloadTask task) {
              if (task.url == dt.first.url)
                return Task(taskId: taskId, downloadTask: task);
              else
                return Task(taskId: '', downloadTask: task);
            }).toList());
          }
          // map [DownloadTask to Task]

          // _tasks.add(Task(downloadTask: event.downloadTask, taskId: taskId));
        }
      } else if (event is AddDownload) {
        print('add download event');
        // clear the download for stream download
        // _handleClearDownload();
        _addToQueue(event.downloadTasks);

        var query =
            "SELECT * FROM task WHERE status=${DownloadTaskStatus.running.value}";
        var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
        if (tasks.isEmpty) {
          add(BeginDownload(downloadTasks: event.downloadTasks));
          _downloadQueue.removeFirst();
        }
      } else if (event is RetryDownload) {
        if (_tasks.isNotEmpty) {
          await FlutterDownloader.cancelAll();
          addDownload(_tasks[0].downloadTask)
              .then((value) => _tasks[0].taskId = value);
        }
        // else {
        //   yield DownloadDone(downloadedTask: null);
        // }
      } else if (event is UpdateDownloadState) {
        print("UPDATING DOWNLOAD STATE");
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
      fileName: "main${task.segment_number}.ts",
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

  void _checkQueueAndContinueDownload() {
    if (_downloadQueue.isNotEmpty) {
      add(BeginDownload(downloadTasks: _downloadQueue.first));
      _downloadQueue.removeFirst();
    }
  }

  void _addToQueue(List<smd.DownloadTask> downloadTasks) {
    // queueBox.add(downloadTasks);
    _downloadQueue.add(downloadTasks);
  }
}
