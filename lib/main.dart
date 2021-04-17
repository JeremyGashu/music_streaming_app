import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_bloc.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_events.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_state.dart';
import 'package:streaming_mobile/core/services/location_service.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/info/location_disabled_page.dart';
import 'package:streaming_mobile/presentation/info/no_vpn_page.dart';
import 'package:streaming_mobile/simple_bloc_observer.dart';

import 'blocs/local_database/local_database_bloc.dart';
import 'blocs/local_database/local_database_event.dart';
import 'blocs/single_media_downloader/media_downloader_bloc.dart';
import 'blocs/single_media_downloader/media_downloader_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();

  await Firebase.initializeApp();
  await initMessaging();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };

  final _playlistRepo = PlaylistRepository(
      dataProvider: PlaylistDataProvider(client: http.Client()));
  final _trackRepo =
      TrackRepository(dataProvider: TrackDataProvider(client: http.Client()));

  /// initialize [UserLocationBloc]
  UserLocationBloc _userLocationBloc =
      UserLocationBloc(locationService: LocationService());

  /// initialize [MediaDownloaderBLoc]
  MediaDownloaderBloc _mediaDownloaderBloc = MediaDownloaderBloc();
  LocalDatabaseBloc _localDatabaseBloc =
      LocalDatabaseBloc(mediaDownloaderBloc: _mediaDownloaderBloc);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider(create: (context) => _localDatabaseBloc..add(InitLocalDB())),
    BlocProvider(
        create: (context) => _userLocationBloc..add(UserLocationEvent.Init)),
    BlocProvider(
      create: (context) => PlaylistBloc(playlistRepository: _playlistRepo),
    ),
    BlocProvider(
      create: (context) => TrackBloc(trackRepository: _trackRepo),
    ),
    BlocProvider(
      create: (context) => PlaylistBloc(playlistRepository: _playlistRepo),
    ),
    BlocProvider(
        create: (context) =>
            VPNBloc()..add(StartListening(intervalInSeconds: 2))),
    BlocProvider(
      create: (context) => TrackBloc(trackRepository: _trackRepo),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
        //Here after you can use the flutter_local_notification
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: BlocListener<UserLocationBloc, UserLocationState>(
          listener: (context, state) {
            if (state is UserLocationLoadFailed) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return LocationDisabledPage();
                },
              );
            }
          },
          child: BlocBuilder<VPNBloc, VPNState>(
            buildWhen: (prev, current) => prev != current,
            builder: (ctx, state) {
              if (state is VPNDisabled) {
                return AudioServiceWidget(child: HomePage());
              } else if (state is VPNEnabled) {
                return Scaffold(
                  body: Center(
                    child: VPNEnabledPage(),
                  ),
                );
              }
              return AudioServiceWidget(child: HomePage());
            },
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
