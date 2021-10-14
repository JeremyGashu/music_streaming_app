import 'package:flutter/material.dart';
import 'imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthDataAdapter());
  Hive.registerAdapter(AnalyticsAdapter());
  Hive.registerAdapter(TrackAdapter());

  setupLocator();

  Hive.registerAdapter(LocalDownloadTaskAdapter());
  await FlutterDownloader.initialize(debug: true);

  /// Initialized DIO
  final Dio dio = Dio();
  /// setup getit

  await Firebase.initializeApp();

  await initLocator();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };

  /// initialize [UserLocationBloc]
  UserLocationBloc _userLocationBloc =
      UserLocationBloc(locationService: LocationService());

  /// initialize [MediaDownloaderBLoc]
  // MediaDownloaderBloc _mediaDownloaderBloc = getIt<MediaDownloaderBloc>();
  LocalDatabaseBloc _localDatabaseBloc =
      getIt<LocalDatabaseBloc>()
        ..add(InitLocalDB());

  runApp(MultiBlocProvider(providers: [
    BlocProvider<SignUpBloc>(
      create: (_) => sl<SignUpBloc>(),
    ),

    BlocProvider<LikedAlbumBloc>(
      create: (_) => sl<LikedAlbumBloc>(),
    ),

    BlocProvider<LikedArtistsBloc>(
      create: (_) => sl<LikedArtistsBloc>(),
    ),

    BlocProvider<LikedSongsBloc>(
      create: (_) => sl<LikedSongsBloc>(),
    ),

    BlocProvider<AlbumBloc>(
      create: (_) => sl<AlbumBloc>()..add(LoadInitAlbums()),
    ),
    BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(CheckAuthOnStartUp()),
    ),

    BlocProvider<LikeBloc>(create: (_) => sl<LikeBloc>()),

    BlocProvider(
        create: (context) => getIt<MediaDownloaderBloc>()..add(InitializeDownloader())),
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
      create: (_) => sl<GenresBloc>()..add(FetchGenres())),
    BlocProvider(create: (context) => UserDownloadBloc(dio: dio)..add(Init()), lazy: false,),
    BlocProvider(
      create: (context) => SearchBloc(searchRepository: sl()),
    ),
    BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>(),
    ),
    BlocProvider<NewReleaseBloc>(
      create: (_) => sl<NewReleaseBloc>()..add(LoadNewReleasesInit()),
    ),
    BlocProvider<ConfigBloc>(create: (_) => sl<ConfigBloc>()..add(LoadConfigData())),
  ], child: StreamingApp()));
}

class StreamingApp extends StatefulWidget {
  @override
  _StreamingAppState createState() => _StreamingAppState();
}

class _StreamingAppState extends State<StreamingApp> {
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
