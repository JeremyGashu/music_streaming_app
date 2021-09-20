import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
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
import 'package:streaming_mobile/core/services/location_service.dart';
import 'package:streaming_mobile/data/data_provider/album_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/artist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/config_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/featured_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/genre_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/new_release_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/search_data_provider.dart';
import 'package:streaming_mobile/data/data_provider/signup_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/analytics.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/data/repository/album_repository.dart';
import 'package:streaming_mobile/data/repository/artist_repository.dart';
import 'package:streaming_mobile/data/repository/auth_repository.dart';
import 'package:streaming_mobile/data/repository/config_repository.dart';
import 'package:streaming_mobile/data/repository/featured_repository.dart';
import 'package:streaming_mobile/data/repository/new_release_repository.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/data/repository/search_repository.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';
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
import 'data/data_provider/auth_dataprovider.dart';
import 'data/repository/genre_repository.dart';
import 'data/repository/signup_repository.dart';

final _authRepo =
    AuthRepository(dataProvider: AuthDataProvider(client: http.Client()));
final _signUpRepo =
    SignUpRepository(dataProvider: SignUpDataProvider(client: http.Client()));



final _artistRepo =
    ArtistRepository(dataProvider: ArtistDataProvider(client: http.Client()));

final _newReleaseRepo = NewReleaseRepository(
    dataProvider: NewReleaseDataProvider(client: http.Client()));

final _playlistRepo = PlaylistRepository(
    dataProvider: PlaylistDataProvider(client: http.Client()));
final _albumRepository =
    AlbumRepository(dataProvider: AlbumDataProvider(client: http.Client()));
final _trackRepo =
    TrackRepository(dataProvider: TrackDataProvider(client: http.Client()));
final _searchRepo =
    SearchRepository(dataProvider: SearchDataProvider(client: http.Client()));

final _genreRepo = GenreRepository(
    genreDataProvider: GenreDataProvider(client: http.Client()));
final _configRepo = ConfigRepository(
    configDataProvider: ConfigDataProvider(client: http.Client()));
final _featuredAlbumRepo = FeaturedAlbumRepository(
    dataProvider: FeaturedDataProvider(client: http.Client()));
    

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthDataAdapter());
  Hive.registerAdapter(AnalyticsAdapter());
  Hive.registerAdapter(TrackAdapter());
  
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
    BlocProvider(
      create: (context) => SignUpBloc(signUpRepository: _signUpRepo),
    ),
    BlocProvider(
      create: (context) =>
          AlbumBloc(albumRepository: _albumRepository)..add(LoadInitAlbums()),
    ),
    BlocProvider(
      create: (context) =>
          AuthBloc(authRepository: _authRepo)..add(CheckAuthOnStartUp()),
    ),
    BlocProvider(
        create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider(
        create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider(create: (context) => _localDatabaseBloc),
    BlocProvider(
        create: (context) => _userLocationBloc..add(UserLocationEvent.Init)),
    BlocProvider(
      create: (context) => PlaylistBloc(playlistRepository: _playlistRepo)
        ..add(LoadPlaylistsInit()),
    ),
    BlocProvider(
        create: (context) =>
            VPNBloc()..add(StartListening(intervalInSeconds: 2))),
    BlocProvider(
      create: (context) =>
          TrackBloc(trackRepository: _trackRepo)..add(LoadTracksInit()),
    ),
    BlocProvider(
      create: (context) =>
          ArtistBloc(artistRepository: _artistRepo)..add(LoadInitArtists()),
    ),
    BlocProvider(
      create: (context) =>
          FeaturedAlbumBloc(featuredAlbumRepo: _featuredAlbumRepo)
            ..add(LoadFeaturedAlbumsInit()),
    ),
    BlocProvider(
      create: (context) =>
          GenresBloc(genreRepository: _genreRepo)..add(FetchGenres()),
    ),
    BlocProvider(
      create: (context) => SearchBloc(searchRepository: _searchRepo),
    ),
    BlocProvider(
      create: (context) => NewReleaseBloc(newReleaseRepository: _newReleaseRepo)
        ..add(LoadNewReleasesInit()),
    ),
    BlocProvider(
        create: (context) =>
            ConfigBloc(configRepository: _configRepo)..add(LoadConfigData())),
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
      title: 'Streaming App',
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
