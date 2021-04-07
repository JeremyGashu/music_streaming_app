import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'blocs/local_database/local_database_bloc.dart';
import 'blocs/local_database/local_database_event.dart';
import 'blocs/single_media_downloader/media_downloader_bloc.dart';
import 'blocs/single_media_downloader/media_downloader_event.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await Hive.initFlutter();

  await Firebase.initializeApp();
  await initMessaging();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };

  await FlutterDownloader.initialize(debug: true);

  MediaDownloaderBloc _mediaDownloaderBloc = MediaDownloaderBloc();
  LocalDatabaseBloc _localDatabaseBloc = LocalDatabaseBloc(mediaDownloaderBloc: _mediaDownloaderBloc);
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
        BlocProvider(create: (context) => _localDatabaseBloc..add(InitLocalDB())),
      ],
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Material App Bar'),
          ),
          body: Center(
            child: Text('Hello World'),
          ),
        ));
  }
}

initMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  String token = await messaging.getToken();
  print("USER TOKEN:" + token);

  FirebaseMessaging.onMessage.listen((message) {
    print('NOTIFICATION RECEIVED');
    print('TITLE: ' + message.notification.title);
    print('BODY: ' + message.notification.body);
  });

  print('User granted permission: ${settings.authorizationStatus}');
}
