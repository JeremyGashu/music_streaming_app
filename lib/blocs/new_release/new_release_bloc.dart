import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/data/repository/new_release_repository.dart';

class NewReleaseBloc extends Bloc<NewReleaseEvent, NewReleaseState> {
  int page = 1;
  bool isLoading = false;
  final NewReleaseRepository newReleaseRepository;
  NewReleaseBloc({@required this.newReleaseRepository}) : super(InitialState());

  @override
  Stream<NewReleaseState> mapEventToState(NewReleaseEvent event) async* {
    yield InitialState();
    if (event is LoadNewReleases) {
      try {
        yield LoadingNewReleases();
        var newReleaseResponse =
            await newReleaseRepository.getNewReleases(page: page);

        yield LoadedNewReleases(newRelease: newReleaseResponse.data.data);
        page++;
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingNewReleasesError(message: "Error on New Releases");
        throw Exception(e);
      }
    } else if (event is LoadNewReleasesInit) {
      try {
        yield LoadingNewReleases();
        var newReleaseResponse =
            await newReleaseRepository.getNewReleases(page: 1);

        yield LoadedNewReleases(newRelease: newReleaseResponse.data.data);
        page = 1;
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingNewReleasesError(message: "Error on New Releases");
        throw Exception(e);
      }
    }
  }
}
