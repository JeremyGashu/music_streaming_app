import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/like/like_bloc.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_bloc.dart';
import 'package:streaming_mobile/blocs/liked_artists/liked_artists_bloc.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_bloc.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_bloc.dart';
import 'package:streaming_mobile/data/data_provider/auth_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/like_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/liked_albums_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/liked_artists_dataprovider.dart';
import 'package:streaming_mobile/data/data_provider/liked_songs_dataprovider.dart';
import 'package:streaming_mobile/data/repository/like_repository.dart';
import 'package:streaming_mobile/data/repository/liked_albums_repository.dart';
import 'package:streaming_mobile/data/repository/liked_artists_repository.dart';
import 'package:streaming_mobile/data/repository/liked_songs_repository.dart';

import 'blocs/albums/album_bloc.dart';
import 'blocs/artist/artist_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/config/config_bloc.dart';
import 'blocs/featured/featured_bloc.dart';
import 'blocs/genres/genres_bloc.dart';
import 'blocs/new_release/new_release_bloc.dart';
import 'blocs/playlist/playlist_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/sign_up/sign_up_bloc.dart';
import 'blocs/singletrack/track_bloc.dart';
import 'core/services/location_service.dart';
import 'data/data_provider/album_dataprovider.dart';
import 'data/data_provider/artist_dataprovider.dart';
import 'data/data_provider/config_dataprovider.dart';
import 'data/data_provider/featured_dataprovider.dart';
import 'data/data_provider/genre_dataprovider.dart';
import 'data/data_provider/new_release_dataprovider.dart';
import 'data/data_provider/playlist_dataprovider.dart';
import 'data/data_provider/search_data_provider.dart';
import 'data/data_provider/signup_dataprovider.dart';
import 'data/data_provider/track_dataprovider.dart';
import 'data/repository/album_repository.dart';
import 'data/repository/artist_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/config_repository.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/genre_repository.dart';
import 'data/repository/new_release_repository.dart';
import 'data/repository/playlist_repository.dart';
import 'data/repository/search_repository.dart';
import 'data/repository/signup_repository.dart';
import 'data/repository/track_repository.dart';

final sl = GetIt.instance;

void setupLocator() {
  //http-client
  sl.registerFactory(() => http.Client());

  //repositories
  sl.registerFactory(() => LikeRepository(likeDataProvider: sl()));
  sl.registerFactory(() => AuthRepository(dataProvider: sl()));
  sl.registerFactory(() => SignUpRepository(dataProvider: sl()));
  sl.registerFactory(() => ArtistRepository(dataProvider: sl()));
  sl.registerFactory(() => NewReleaseRepository(dataProvider: sl()));
  sl.registerFactory(() => PlaylistRepository(dataProvider: sl()));
  sl.registerFactory(() => AlbumRepository(dataProvider: sl()));
  sl.registerFactory(() => TrackRepository(dataProvider: sl()));
  sl.registerFactory(() => SearchRepository(dataProvider: sl()));
  sl.registerFactory(() => GenreRepository(genreDataProvider: sl()));
  sl.registerFactory(() => ConfigRepository(configDataProvider: sl()));
  sl.registerFactory(() => FeaturedAlbumRepository(dataProvider: sl()));
  sl.registerFactory(() => LikedAlbumsRepository(dataProvider: sl()));
  sl.registerFactory(() => LikedSongsRepository(dataProvider: sl()));
  sl.registerFactory(() => LikedArtistsRepository(dataProvider: sl()));

  //data-providers
  sl.registerFactory(() => LikeDataProvider(client: sl()));
  sl.registerFactory(() => AuthDataProvider(client: sl()));
  sl.registerFactory(() => SignUpDataProvider(client: sl()));
  sl.registerFactory(() => ArtistDataProvider(client: sl()));
  sl.registerFactory(() => NewReleaseDataProvider(client: sl()));
  sl.registerFactory(() => PlaylistDataProvider(client: sl()));
  sl.registerFactory(() => AlbumDataProvider(client: sl()));
  sl.registerFactory(() => TrackDataProvider(client: sl()));
  sl.registerFactory(() => SearchDataProvider(client: sl()));
  sl.registerFactory(() => GenreDataProvider(client: sl()));
  sl.registerFactory(() => ConfigDataProvider(client: sl()));
  sl.registerFactory(() => FeaturedDataProvider(client: sl()));
  sl.registerFactory(() => LikedAlbumsDataprovider(client: sl()));
  sl.registerFactory(() => LikedSongsDataProvider(client: sl()));
  sl.registerFactory(() => LikedArtistsDataProvider(client: sl()));

  //blocs
  sl.registerFactory(() => LikeBloc(likeRepository: sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => SignUpBloc(signUpRepository: sl()));
  sl.registerFactory(() => ArtistBloc(artistRepository: sl()));
  sl.registerFactory(() => NewReleaseBloc(newReleaseRepository: sl()));
  sl.registerFactory(() => PlaylistBloc(playlistRepository: sl()));
  sl.registerFactory(() => AlbumBloc(albumRepository: sl()));
  sl.registerFactory(() => TrackBloc(trackRepository: sl()));
  sl.registerFactory(() => SearchBloc(searchRepository: sl()));
  sl.registerFactory(() => GenresBloc(genreRepository: sl()));
  sl.registerFactory(() => ConfigBloc(configRepository: sl()));
  sl.registerFactory(() => FeaturedAlbumBloc(featuredAlbumRepo: sl()));
  sl.registerFactory(() => LikedAlbumBloc(albumRepo: sl()));
  sl.registerFactory(() => LikedSongsBloc(trackRepository: sl()));
  sl.registerFactory(() => LikedArtistsBloc(artistsRepository: sl()));
  sl.registerFactory(() => VPNBloc());

  //others
  sl.registerFactory(() => LocationService());
}
