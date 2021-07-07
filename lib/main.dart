import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/blocs/genres/genres_bloc.dart';
import 'package:streaming_mobile/blocs/genres/genres_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_bloc.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_events.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_state.dart';
import 'package:streaming_mobile/core/services/audio_service_initializer.dart';
import 'package:streaming_mobile/core/services/location_service.dart';
import 'package:streaming_mobile/data/data_provider/album_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/artist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/genre_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/signup_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/repository/album_repository.dart';
import 'package:streaming_mobile/data/repository/artist_repository.dart';
import 'package:streaming_mobile/data/repository/auth_repository.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_profie_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/info/location_disabled_page.dart';
import 'package:streaming_mobile/presentation/info/no_vpn_page.dart';
import 'package:streaming_mobile/presentation/library/pages/library_page.dart';
import 'package:streaming_mobile/presentation/search/pages/search_page.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthDataAdapter());
  await FlutterDownloader.initialize(debug: true);

  await Firebase.initializeApp();
  initMessaging();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };

  final _authRepo =
      AuthRepository(dataProvider: AuthDataProvider(client: http.Client()));
  final _signUpRepo =
      SignUpRepository(dataProvider: SignUpDataProvider(client: http.Client()));

  final _artistRepo =
      ArtistRepository(dataProvider: ArtistDataProvider(client: http.Client()));

  final _playlistRepo = PlaylistRepository(
      dataProvider: PlaylistDataProvider(client: http.Client()));
  final _albumRepository =
      AlbumRepository(dataProvider: AlbumDataProvider(client: http.Client()));
  final _trackRepo =
      TrackRepository(dataProvider: TrackDataProvider(client: http.Client()));

  final _genreRepo = GenreRepository(genreDataProvider: GenreDataProvider(client: http.Client()));

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
          AlbumBloc(albumRepository: _albumRepository)..add(LoadAlbums()),
    ),
    BlocProvider(
      create: (context) =>
          AuthBloc(authRepository: _authRepo)..add(CheckAuthOnStartUp()),
    ),
    BlocProvider(
        create: (context) => _mediaDownloaderBloc..add(InitializeDownloader())),
    BlocProvider(create: (context) => _localDatabaseBloc),
    BlocProvider(
        create: (context) => _userLocationBloc..add(UserLocationEvent.Init)),
    BlocProvider(
      create: (context) =>
          PlaylistBloc(playlistRepository: _playlistRepo)..add(LoadPlaylists()),
    ),
    BlocProvider(
        create: (context) =>
            VPNBloc()..add(StartListening(intervalInSeconds: 2))),
    BlocProvider(
      create: (context) =>
          TrackBloc(trackRepository: _trackRepo)..add(LoadTracks()),
    ),
    BlocProvider(
      create: (context) =>
          ArtistBloc(artistRepository: _artistRepo)..add(LoadArtists()),
    ),
    BlocProvider(
      create: (context) => GenresBloc(genreRepository: _genreRepo)..add(FetchGenres()),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _widgets = [
    AudioServiceWidget(child: HomePage()),
    SearchPage(),
    LibraryPage(),
    ArtistProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    initializeAudioService();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return BlocListener<UserLocationBloc, UserLocationState>(
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
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Streaming App',
                      home: Scaffold(
                        body: _widgets[_currentIndex],
                        bottomNavigationBar: BottomNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          items: [
                            BottomNavigationBarItem(
                              label: '',
                              icon: Icon(
                                Icons.home,
                                color: _currentIndex == 0
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: Icon(
                                Icons.search,
                                color: _currentIndex == 1
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: Icon(
                                Icons.library_books_outlined,
                                color: _currentIndex == 2
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: Icon(
                                Icons.person,
                                color: _currentIndex == 3
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ));
                } else if (state is VPNEnabled) {
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Streaming App',
                      home: Scaffold(body: VPNEnabledPage()));
                }
                return Container();
                // return AudioServiceWidget(child: HomePage());
              },
            ), //Search(),
          );
        } else if (state is CheckingAuthOnStartup) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Streaming App',
            home: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                    child: SpinKitCubeGrid(
                  color: Colors.blue,
                )),
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Streaming App',
            home: WelcomePage(),
          );
        }
      },
    );
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
