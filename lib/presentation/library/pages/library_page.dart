import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/presentation/library/widgets/ad_container.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 8.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/playlist_top_bg.png'))),
                child: Table(
                  border: TableBorder(
                      horizontalInside:
                          BorderSide(width: 1, color: kBlack.withOpacity(.2)),
                      verticalInside:
                          BorderSide(width: 1, color: kBlack.withOpacity(.2))),
                  children: [
                    TableRow(children: [
                      _buildPlayListTopOptionsItem(
                          'assets/svg/playlist_album.svg', () {}, 'Albums'),
                      _buildPlayListTopOptionsItem(
                          'assets/svg/playlist_playlist.svg',
                          () {},
                          'Playlists'),
                    ]),
                    TableRow(children: [
                      _buildPlayListTopOptionsItem(
                          'assets/svg/playlist_songs.svg', () {}, 'Songs'),
                      _buildPlayListTopOptionsItem(
                          'assets/svg/playlist_artists.svg', () {}, 'Artists'),
                    ])
                  ],
                ),
              ),
              AdContainer('ad.png'),
              Container(
                height: 60,
                color: kPurple.withOpacity(.2),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/search.svg',
                      fit: BoxFit.fill,
                      width: 20,
                      color: kBlack,
                    ),
                    SvgPicture.asset(
                      'assets/svg/playlist_mode.svg',
                      fit: BoxFit.fill,
                      width: 22,
                      color: kBlack,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              _sectionTitle(title: 'Recently Played', callback: () {}),
              SizedBox(
                height: 20.0,
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  _trackListItem(),
                  _trackListItem(),
                  _trackListItem(),
                  _trackListItem(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildPlayListTopOptionsItem(svg, onPressed, text) {
    return Container(
      height: 120,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svg,
            color: kPurple,
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 18),
          )
        ],
      ),
    );
  }

  _sectionTitle({title, callback}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$title',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: kBlack, fontSize: 16),
          ),
          GestureDetector(
            onTap: () => callback(),
            child: Text(
              'View All >',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: kBlack, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  _trackListItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _imageWithDetailRow(),
          Spacer(),
          SizedBox(
            width: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '04:13',
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0x882D2D2D)),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
                color: Color(0x882D2D2D),
              )
            ],
          )
        ],
      ),
    );
  }

  Row _imageWithDetailRow() {
    return Row(
      children: [
        Row(
          children: [
            _customClippedImage(),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amelkalew',
                  style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xDD2D2D2D)),
                ),
                Text(
                  'Dawit Getachew',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0x882D2D2D)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Container _customClippedImage() {
    return Container(
        height: 50,
        width: 50,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            color: Color(0x882D2D2D),
          )
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: AssetImage('assets/images/artist_two.jpg'),
            fit: BoxFit.cover,
          ),
        ));
  }
}
