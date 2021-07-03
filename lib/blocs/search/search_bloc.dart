import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/blocs/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is Search) {
      yield SearchingState();
      //TODO: do the search repo here and send the request here
      try {} catch (e) {
        yield SearchError(message: 'Error searching!');
      }
    }
  }
}
