import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/genres/genres_event.dart';
import 'package:streaming_mobile/blocs/genres/genres_state.dart';
import 'package:streaming_mobile/data/models/genre.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/data/repository/genre_repository.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState>{
  final GenreRepository genreRepository;
  GenresBloc({@required this.genreRepository}) : super(GenresInitial());

  @override
  Stream<GenresState> mapEventToState(GenresEvent event) async* {
    try{
      yield GenresLoadInProgress();
      if(event is FetchGenres){
        List<Genre> genres = await genreRepository.fetchGenres();
        yield GenresLoadSuccess(genres: genres);
      }
    }catch(error, stc){
      print(error);
      print(stc);
      yield GenresLoadFailed();
    }
  }

}