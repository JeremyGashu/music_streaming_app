import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/config/config_bloc.dart';
import 'package:streaming_mobile/blocs/config/config_event.dart';
import 'package:streaming_mobile/blocs/featured/featured_bloc.dart';
import 'package:streaming_mobile/blocs/featured/featured_event.dart';
import 'package:streaming_mobile/blocs/genres/genres_bloc.dart';
import 'package:streaming_mobile/blocs/genres/genres_event.dart';
import 'package:streaming_mobile/blocs/like/like_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_bloc.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_events.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_state.dart';
import 'package:streaming_mobile/core/app/app_router.dart';
import 'package:streaming_mobile/data/models/analytics.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/locator.dart';
import 'package:streaming_mobile/presentation/info/location_disabled_page.dart';
import 'package:streaming_mobile/presentation/info/no_vpn_page.dart';
import 'package:streaming_mobile/presentation/splashpage/splashpage.dart';
import 'package:streaming_mobile/simple_bloc_observer.dart';

import 'blocs/albums/album_bloc.dart';
import 'blocs/artist/artist_event.dart';
import 'blocs/local_database/local_database_bloc.dart';
import 'blocs/local_database/local_database_event.dart';
import 'blocs/single_media_downloader/media_downloader_bloc.dart';
import 'blocs/single_media_downloader/media_downloader_event.dart';
import 'core/services/location_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthDataAdapter());
  Hive.registerAdapter(AnalyticsAdapter());
  Hive.registerAdapter(TrackAdapter());

  setupLocator();

  await FlutterDownloader.initialize(debug: true);

  await Firebase.initializeApp();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };

  /// initialize [UserLocationBloc]
  UserLocationBloc _userLocationBloc =
      UserLocationBloc(locationService: LocationService());

  /// initialize [MediaDownloaderBLoc]
  MediaDownloaderBloc _mediaDownloaderBloc = MediaDownloaderBloc();
  LocalDatabaseBloc _localDatabaseBloc =
      LocalDatabaseBloc(mediaDownloaderBloc: _mediaDownloaderBloc)
        ..add(InitLocalDB());

  runApp(MultiBlocProvider(providers: [
    BlocProvider<SignUpBloc>(
      create: (_) => sl<SignUpBloc>(),
    ),
    BlocProvider<AlbumBloc>(
      create: (_) => sl<AlbumBloc>()..add(LoadInitAlbums()),
    ),
    BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(CheckAuthOnStartUp()),
    ),
    BlocProvider(
        create: (_) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider<LikeBloc>(create: (_) => sl<LikeBloc>()),

    BlocProvider(
        create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider(create: (context) => _localDatabaseBloc),

    BlocProvider<UserLocationBloc>(
        create: (_) => _userLocationBloc..add(UserLocationEvent.Init)),
    BlocProvider<PlaylistBloc>(
      create: (_) => sl<PlaylistBloc>()..add(LoadPlaylistsInit()),
    ),
    BlocProvider<VPNBloc>(
        create: (_) =>
            sl<VPNBloc>()..add(StartListening(intervalInSeconds: 10))),
    BlocProvider<TrackBloc>(
      create: (_) => sl<TrackBloc>()..add(LoadTracksInit()),
    ),
    BlocProvider<ArtistBloc>(
      create: (_) => sl<ArtistBloc>()..add(LoadInitArtists()),
    ),
    BlocProvider<FeaturedAlbumBloc>(
      create: (_) => sl<FeaturedAlbumBloc>()..add(LoadFeaturedAlbumsInit()),
    ),
    BlocProvider<GenresBloc>(
      create: (_) => sl<GenresBloc>()..add(FetchGenres()),
    ),
    BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>(),
    ),
    BlocProvider<NewReleaseBloc>(
      create: (_) => sl<NewReleaseBloc>()..add(LoadNewReleasesInit()),
    ),
    BlocProvider<ConfigBloc>(create: (_) => sl<ConfigBloc>()..add(LoadConfigData())),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    initMessaging();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zema Streaming',
      onGenerateRoute: AppRouter.onGeneratedRoute,
      home: MultiBlocListener(
        listeners: [
          BlocListener<UserLocationBloc, UserLocationState>(
            listener: (mContext, state) {
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
          ),
          BlocListener<VPNBloc, VPNState>(
            listener: (context, state) {
              if (state is VPNEnabled) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => VPNEnabledPage()),
                    (route) => false);
              }
              // return Container();
              // return AudioServiceWidget(child: HomePage());
            },
          ),
        ],
        child: SplashPage(),
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'FLUTTER_STREAMING_APP',
        'STREAMING_APP',
        'FLUTTER_CHANNEL_TO_SEND_NOTIFICATION',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
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
      //todo => use flutter local notification to show notification in the background
      print('NOTIFICATION RECEIVED');
      showNotification(message.notification.title, message.notification.body);
      print('TITLE: ' + message.notification.title);
      print('BODY: ' + message.notification.body);
    });

    print('User granted permission: ${settings.authorizationStatus}');
  }
}
