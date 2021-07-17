import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
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
        var tracksResponse = await trackRepository.getTracks();

        yield LoadedTracks(tracks: tracksResponse.data.data);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error one loading playlists");
        throw Exception(e);
      }
    }
  }
}
