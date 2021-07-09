import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/search/search_event.dart';

class SearchDataProvider {
  final http.Client client;

  SearchDataProvider({this.client}) : assert(client != null);

  Future<http.Response> search(
      {String searchBy,
      String searchKey,
      SearchIn searchIn = SearchIn.SONGS}) async {
    //TODO select endpoint based on searchBy and add header
    String url = '';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }
}
