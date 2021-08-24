import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/blocs/search/search_state.dart';
import 'package:streaming_mobile/data/repository/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  Map<String, dynamic> searchResult = {
    'playlists': null,
    'artists': null,
    'songs': null,
    'albums': null,
    'playlistsParam': '',
    'artistsParam': '',
    'songsParam': '',
    'albumsParam': '',
    'currentPage': SearchIn.SONGS,
    'currentKey': '',
  };

  SearchBloc({this.searchRepository}) : super(InitialState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is Search) {
      yield SearchingState();
      try {
        var tempSearchResult;

        switch (searchResult['currentPage']) {
          case SearchIn.ARTISTS:
            tempSearchResult = await searchRepository.searchArtists(
                searchKey: event.searchKey);
            searchResult['artists'] = tempSearchResult;
            searchResult['artistsParam'] = event.searchKey;
            searchResult['currentKey'] = event.searchKey;
            break;
          case SearchIn.SONGS:
            tempSearchResult =
                await searchRepository.searchSongs(searchKey: event.searchKey);
            searchResult['songs'] = tempSearchResult;
            searchResult['songsParam'] = event.searchKey;
            searchResult['currentKey'] = event.searchKey;
            break;
          case SearchIn.ALBUMS:
            tempSearchResult =
                await searchRepository.searchAlbums(searchKey: event.searchKey);
            searchResult['albums'] = tempSearchResult;
            searchResult['albumsParam'] = event.searchKey;
            searchResult['currentKey'] = event.searchKey;
            break;
          case SearchIn.PLAYLISTS:
            tempSearchResult = await searchRepository.searchPlaylists(
                searchKey: event.searchKey);
            searchResult['playlists'] = tempSearchResult;
            searchResult['playlistsParam'] = event.searchKey;
            searchResult['currentKey'] = event.searchKey;
            break;
        }
        print(searchResult);
        yield SearchFinished(result: searchResult);
      } catch (e) {
        print(e);
        yield SearchError(message: 'Error searching!');
        throw Exception(e);
      }
    } else if (event is ExitSearch) {
      searchResult['artistsParam'] = '';
      searchResult['playlistsParam'] = '';
      searchResult['songsParam'] = '';
      searchResult['albumsParam'] = '';
      searchResult['isSearching'] = false;
      yield InitialState();
    } else if (event is SetCurrentPage) {
      searchResult['currentPage'] = event.currentPage;
      yield SearchFinished(result: searchResult);
    } else if (event is SetCurrentKey) {
      searchResult['currentKey'] = event.currentKey;
      yield SearchFinished(result: searchResult);
    }
  }
}
