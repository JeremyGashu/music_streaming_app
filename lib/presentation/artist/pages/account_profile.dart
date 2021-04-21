import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/presentation/artist/widgets/albums_widget.dart';
import 'package:streaming_mobile/presentation/artist/widgets/playlist.dart';

import '../../homepage/widgets/singletrack.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //the name and back navigator icon and vertical more option
              _upperSection(),
              //circular artist image
              Padding(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Container(
                    width: 140,
                    height: 140,
                    child: Image.asset(
                      'assets/images/artist_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //artist username
              Text(
                '@dawitgetachew',
                style: TextStyle(
                    fontSize: 17, color: Colors.black.withOpacity(0.5)),
              ),
              SizedBox(
                height: 20,
              ),

              _likeAndFollowersStat(),

              // _followSection(),
              SizedBox(
                height: 10,
              ),
              _descriptionSection(),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                  onPressed: () {},
                  child: Text(
                    'More',
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              //ad container
              _adContainer('ad.png'),

              // SizedBox(
              //   height: 10,
              // ),

              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      //tab selectors
                      _tabSelectors(),

                      //album section
                      Container(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: [1, 2, 3].length,
                            itemBuilder: (context, index) {
                              return Album();
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Single Tracks',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black.withOpacity(0.7),
                              letterSpacing: 1.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 17,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.purple,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: [1, 2, 3, 4].length,
                            itemBuilder: (context, index) {
                              return SingleTrack();
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Playlists',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black.withOpacity(0.7),
                              letterSpacing: 1.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 17,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.purple,
                                  ),
                                  onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: [1, 2, 3, 4].length,
                            itemBuilder: (context, index) {
                              return PlayList();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//back nav, name and more vertical iconBuilder
Widget _upperSection() {
  return Padding(
    padding: EdgeInsets.all(5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black.withOpacity(0.5),
          ),
          onPressed: () {},
        ),
        Text(
          'Dawit Getachew',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black.withOpacity(0.5),
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _likeAndFollowersStat() {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              '2,168',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Followers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.01,
                color: Colors.black.withOpacity(
                  0.5,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '19,168',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Likes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.01,
                color: Colors.black.withOpacity(
                  0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _followSection() {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 15,
    ),
    child: Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Text(
                  'Follow',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              )),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _socialMediaIcon(
                'facebook.png',
              ),
              _socialMediaIcon(
                'instagram.png',
              ),
              _socialMediaIcon(
                'youtube.png',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _socialMediaIcon(String name) {
  return Container(
    height: 32,
    width: 32,
    child: Image.asset(
      'images/$name',
      fit: BoxFit.cover,
    ),
  );
}

Widget _descriptionSection() {
  return Container(
    padding: EdgeInsets.all(10),
    child: Text(
      '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero...''',
      style: TextStyle(
        letterSpacing: 1.1,
        fontSize: 17,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
  );
}

Widget _adContainer(String path) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 0,
    ),
    width: double.infinity,
    height: 110,
    child: Image.asset(
      'assets/images/$path',
      fit: BoxFit.cover,
    ),
  );
}

Widget _tabSelectors() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 20,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _tabItem('home.svg'),
        _tabItem('search.svg'),
        _tabItem('Pressed Library Icon (notification).svg'),
        _tabItem('account.svg'),
      ],
    ),
  );
}

Widget _tabItem(String svgName) {
  return Container(
    width: 22,
    height: 22,
    child: SvgPicture.asset(
      'images/$svgName',
      fit: BoxFit.cover,
    ),
  );
}

// Widget _trackBuilder(Track track) {
//   return Padding(
//     padding: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 220,
//           height: 180,
//           child: Card(
//             color: Colors.transparent,
//             elevation: 10,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 'images/${track.imageName}',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${track.name}',
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.9),
//                     fontSize: 22,
//                     letterSpacing: 1.05,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${track.artistName}',
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.6),
//                     fontSize: 17,
//                     letterSpacing: 1.05,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 7,
//               ),
//               child: Text(
//                 '${track.duration}',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.yellow[900],
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _playlistBuilder(PlaylistModel playlist) {
//   return Padding(
//     padding: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             color: Colors.purple[900].withOpacity(0.6),
//             borderRadius: BorderRadius.circular(60),
//             image: DecorationImage(
//               colorFilter: new ColorFilter.mode(
//                   Colors.black.withOpacity(0.4), BlendMode.dstATop),
//               image: AssetImage('images/${playlist.imageName}'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             alignment: AlignmentDirectional.center,
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 child: SvgPicture.asset(
//                   'images/search.svg',
//                   color: Colors.white.withOpacity(0.8),
//                   fit: BoxFit.cover,
//                 ),
//               )
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 7,
//         ),
//         Text(
//           '${playlist.length} - New Songs',
//           style: TextStyle(
//             color: Colors.black.withOpacity(0.6),
//             fontSize: 22,
//             letterSpacing: 1.05,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(
//               Icons.favorite,
//               color: Colors.yellow[800],
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Text(
//               '${playlist.loveCount}',
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.6),
//                 fontSize: 17,
//                 letterSpacing: 1.05,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
