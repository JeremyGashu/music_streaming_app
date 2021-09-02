final BASE_URL = 'http://138.68.163.236:8889/v1';
final LOGIN_URL = 'http://138.68.163.236:8866/v1/login';
final SIGN_UP_URL = 'http://138.68.163.236:8866/v1/signup/user';
final PLAYLIST_URL =
    'http://138.68.163.236:8889/v1/playlists/?page=1&per_page=10&sort=ASC';
final ALBUM_URL =
    'http://138.68.163.236:8889/v1/albums?page=1&per_page=10&sort=ASC';
final BASE_ALBUM_URL = 'http://138.68.163.236:8889/v1/albums';
final ARTIST_URL =
    'http://138.68.163.236:8889/v1/artists/?page=1&per_page=10&sort=ASC';
final SONG_URL =
    'http://138.68.163.236:8889/v1/songs?page=1&per_page=10&single=true';
final FEATURED_URL =
    'http://138.68.163.236:8889/v1/featured/albums?page=1&per_page=10';
final REFRESH_TOKEN_URL = 'http://138.68.163.236:8866/v1/refresh_token';
final RESET_PASSWORD_URL =
    'http://138.68.163.236:8866/v1/request_reset_password';
final VERIFY_PASSWORD_RESET_URL =
    'http://138.68.163.236:8866/v1/verify_and_reset_password';
final SONG_BY_ARTIST =
    'http://138.68.163.236:8889/v1/songs/?page=1&per_page=10&sort=DESC&search_by=artist_id&search_key=';
final ALBUM_BY_ARTIST =
    'http://138.68.163.236:8889/v1/albums?page=1&per_page=10&sort=ASC&search_by=artist_id&search_key=';
final NEW_RELEASE =
    'http://138.68.163.236:8889/v1/new_releases?page=1&per_page=10';
final ANALYTICS_URL = 'http://138.68.163.236:8889/v1/analytics/bulk';

final POST_PLAYLIST_URL = '$BASE_URL/playlist/song';

//todo: genre
//todo: analytics
//todo: getOtp
//todo: verify otp
//todo: add custom playlist endpoint
