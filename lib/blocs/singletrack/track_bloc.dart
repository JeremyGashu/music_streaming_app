import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/data/repository/track_repository.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  int page = 1;
  bool isLoading = false;
  final TrackRepository trackRepository;
  TrackBloc({@required this.trackRepository}) : super(InitialState());

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    yield InitialState();
    if (event is LoadTracks) {
      try {
        yield LoadingTrack();
        var tracksResponse = await trackRepository.getTracks(page: page);
        if (page > tracksResponse.data.metaData.pageCount) {
          yield LoadedTracks(tracks: []);
        } else {
          List<Track> tracks = tracksResponse.data.data.songs
              .map((songElement) => songElement.song)
              .toList();

          yield LoadedTracks(tracks: tracks);
          page++;
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error on loading songs!");
        // throw Exception(e);
      }
    } else if (event is LoadTracksInit) {
      try {
        yield LoadingTrack();
        var tracksResponse = await trackRepository.getTracks(page: 1);
        List<Track> tracks = tracksResponse.data.data.songs
            .map((songElement) => songElement.song)
            .toList();

        yield LoadedTracks(tracks: tracks);
        page = 1;
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error on loading songs");
        // throw Exception(e);
      }
    } else if (event is LoadSongsByArtistId) {
      try {
        yield LoadingTrack();
        var songsResponse =
            await trackRepository.getTracksByArtisId(artistId: event.artistId);
        List<Track> tracks = songsResponse.data.data.songs
            .map((songElement) => songElement.song)
            .toList();

        yield LoadedTracks(tracks: tracks);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error on loading songs!");
      }
    }

    if (event is LoadSongsByGenre) {
      try {
        yield LoadingTrack();
        var tracksResponse = await trackRepository.getTracksByGenre(genreId: event.genreId,page: page);
        if (page > tracksResponse.data.metaData.pageCount) {
          yield LoadedTracks(tracks: []);
        } else {
          List<Track> tracks = tracksResponse.data.data.songs
              .map((songElement) => songElement.song)
              .toList();

          yield LoadedTracks(tracks: tracks);
          page++;
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingTrackError(message: "Error on loading songs");
      }
    }
  }
}
