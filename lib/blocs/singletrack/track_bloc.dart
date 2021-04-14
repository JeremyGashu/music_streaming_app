import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/bloc/singletrack/track_event.dart';
import 'package:streaming_mobile/bloc/singletrack/track_state.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final TrackRepository trackRepository;
  TrackBloc({@required this.trackRepository}) : super(InitialState());

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    yield InitialState();
    if (event is LoadTracks) {
      try {
        yield LoadingTrack();
        await Future.delayed(Duration(seconds: 5));
        var tracks = await trackRepository.getTracks();

        yield LoadedTrack(track: tracks);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error one loading playlists");
      }
    }
  }
}
