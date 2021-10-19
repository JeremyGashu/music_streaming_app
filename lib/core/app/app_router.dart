import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_all.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';
import 'package:streaming_mobile/presentation/album/pages/liked_albums.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_all.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_detail_page.dart';
import 'package:streaming_mobile/presentation/artist/pages/liked_artists.dart';
import 'package:streaming_mobile/presentation/auth/pages/otp_page.dart';
import 'package:streaming_mobile/presentation/downloads/downloads_page.dart';
import 'package:streaming_mobile/presentation/sign_up/pages/phone_input_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/verify_password_reset_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/login/login_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_albums.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_tracks.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlist_detail.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlists_all.dart';
import 'package:streaming_mobile/presentation/playlist/pages/private_playlists_page.dart';
import 'package:streaming_mobile/presentation/search/pages/search_page.dart';
import 'package:streaming_mobile/presentation/sign_up/pages/sign_up_page.dart';
import 'package:streaming_mobile/presentation/tracks/liked_songs.dart';
import 'package:streaming_mobile/presentation/tracks/tracks_all.dart';
import 'package:streaming_mobile/presentation/tracks/tracks_by_genre.dart';

class AppRouter {
  static Route onGeneratedRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case LoginPage.loginPageRouteName:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case AllAlbumsPage.allAlbumsRouterName:
        return MaterialPageRoute(builder: (_) => AllAlbumsPage());

      case AlbumDetail.albumDetailRouterName:
        return MaterialPageRoute(builder: (_) => AlbumDetail(album: args));

      case AllArtistsPage.allPArtistsRouterName:
        return MaterialPageRoute(builder: (_) => AllArtistsPage());

      case ArtistDetailPage.artistDetailPageRouteName:
        return MaterialPageRoute(
            builder: (_) => ArtistDetailPage(artist: args));

      case ArtistDetailPage.artistDetailPageRouteName:
        return MaterialPageRoute(
            builder: (_) => ArtistDetailPage(artist: args));
      case SearchPage.searchPageRouteName:
        return MaterialPageRoute(builder: (_) => SearchPage());

      case OTP.otpPageRouterName:
        return MaterialPageRoute(builder: (_) => OTP(phoneNumber: args));

      case PhoneInputPage.phoneInputStorageRouterName:
        return MaterialPageRoute(builder: (_) => PhoneInputPage());

      case ResetPasswordPage.resetPasswordPageRouterName:
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());

      case VerifyPasswordResetPage.verifyPasswordResetPageRouterName:
        return MaterialPageRoute(
            builder: (_) => VerifyPasswordResetPage(phoneNo: args));

      case MainPage.mainPageRouterName:
        return MaterialPageRoute(builder: (_) => MainPage());

      case AllNewReleaseTracks.allNewReleaseTracksRouterName:
        return MaterialPageRoute(builder: (_) => AllNewReleaseTracks());

      case AllNewReleasedAlbumsPage.allNewReleaseAlbumsRouterName:
        return MaterialPageRoute(builder: (_) => AllNewReleasedAlbumsPage());

      case SingleTrackPlayerPage.singleTrackPlayerPageRouteName:
        return MaterialPageRoute(
            builder: (_) => SingleTrackPlayerPage(track: args));

      case PlaylistDetail.playlistDetailRouterName:
        return MaterialPageRoute(
            builder: (_) => PlaylistDetail(playlistInfo: args));

      case AllNewReleasedAlbumsPage.allNewReleaseAlbumsRouterName:
        return MaterialPageRoute(builder: (_) => AllNewReleasedAlbumsPage());

      case AllPlaylistsPage.allPlaylistsRouterName:
        return MaterialPageRoute(builder: (_) => AllPlaylistsPage());

      case SignUpPage.signUpPageRouterName:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case LikedArtistsPage.likedArtistsRouteName:
        return MaterialPageRoute(builder: (_) => LikedArtistsPage());

      case LikedAlbumsPage.likedAlbumsRouteName:
        return MaterialPageRoute(builder: (_) => LikedAlbumsPage());
      case LikedSongsPage.likedSongsPage:
        return MaterialPageRoute(builder: (_) => LikedSongsPage());

      case AllTracks.allTracksRouterName:
        return MaterialPageRoute(builder: (_) => AllTracks());
      case WelcomePage.welcomePageRouteName:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case PrivatePlaylistsPage.privatePlaylistRouteName:
        return MaterialPageRoute(builder: (_) => PrivatePlaylistsPage());

        case DownloadsPage.downloadsPageRouteName:
        return MaterialPageRoute(builder: (_) => DownloadsPage());

      case TracksByGenre.tracksByGenreRouteName:
        return MaterialPageRoute(
            builder: (_) => TracksByGenre(
                  genre: args,
                ));

      default:
        return null;
    }
  }
}
