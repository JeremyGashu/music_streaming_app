import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/blocs/search/search_state.dart';
import 'package:streaming_mobile/data/repository/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;
  final String re = '''
playlists : [],
artists : [],
songs : [],
albums : [],
keyUpdated : false
''';

  Map<String, dynamic> searchResult = {
    'playlists': null,
    'artists': null,
    'songs': null,
    'albums': null,
    'currentParam': '',
    'playlistsParam': '',
    'artistsParam': '',
    'songsParam': '',
    'albumsParam': ''
  };

  SearchBloc({this.searchRepository}) : super(InitialState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is Search) {
      yield SearchingState();
      switch (event.searchIn) {
        case SearchIn.ALBUMS:
          break;
        case SearchIn.ARTISTS:
          // TODO: Handle this case.
          break;
        case SearchIn.SONGS:
          // TODO: Handle this case.
          break;
        case SearchIn.PLAYLISTS:
          // TODO: Handle this case.
          break;
      }
      try {
        var searchResult = await searchRepository.search(
            searchKey: event.searchKey,
            searchIn: event.searchIn,
            searchBy: event.searchBy);
        print(searchResult);
        //todo check the response here and return success if it has no error and return false error if the response has errors
        //SearchSuccess or SearchError() // return
      } catch (e) {
        print(e);
        yield SearchError(message: 'Error searching!');
      }
    } else if (event is ExitSearch) {
      //TODO when the user has no typed anything or cleared all the texts, we will show the search page
    }
  }
}
