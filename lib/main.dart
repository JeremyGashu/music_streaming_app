import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/core/services/location_service.dart';

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

  /// initialize [UserLocationBloc]
  UserLocationBloc _userLocationBloc = UserLocationBloc(locationService: LocationService());
  /// initialize [MediaDownloaderBLoc]
  MediaDownloaderBloc _mediaDownloaderBloc = MediaDownloaderBloc();
  /// initialize [LocalDatabaseBloc]
  LocalDatabaseBloc _localDatabaseBloc = LocalDatabaseBloc(mediaDownloaderBloc: _mediaDownloaderBloc);
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
        BlocProvider(create: (context) => _localDatabaseBloc..add(InitLocalDB())),
        BlocProvider(create: (context) => _userLocationBloc..add(UserLocationEvent.Init)
        )
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
        home: BlocListener<UserLocationBloc, UserLocationState>(
          listener: (context, state){
            if(state is  UserLocationLoadFailed){
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (ctx){
                  return AlertDialog(
                    title: Text('Location required'),
                    content: Text('Please allow location permission from settings, to continue using the app'),
                    actions: <Widget>[
                      TextButton(onPressed: (){
                        BlocProvider.of<UserLocationBloc>(context).add(UserLocationEvent.Init);
                        Navigator.of(ctx).pop();
                      }, child: Text('try again'))
                    ],
                  );
                },
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Material App Bar'),
            ),
            body: Center(
              child: Text('Hello World'),
            ),
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
