import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/bloc/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/bloc/singletrack/track_bloc.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _playlistRepo = PlaylistRepository(
      dataProvider: PlaylistDataProvider(client: http.Client()));
  final _trackRepo =
      TrackRepository(dataProvider: TrackDataProvider(client: http.Client()));

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlaylistBloc(playlistRepository: _playlistRepo),
        ),
        BlocProvider(
          create: (context) => TrackBloc(trackRepository: _trackRepo),
        ),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
  }
}
