import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/playlistStat.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/search_bar.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/upper_section.dart';

class PlaylistDetail extends StatelessWidget {
  final List<Music> _musics = [
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Dawit Getachew',
      name: 'Amelkalew',
    ),
    Music(
      imageName: 'artist_image2.jpg',
      duration: '4:12',
      artistName: 'Hana Tekle',
      name: 'Anileyayem',
    ),
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Bereket Tesfaye',
      name: 'Yibezal',
    ),
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Dawit Getachew',
      name: 'Etebkihalehi',
    ),
    Music(
      imageName: 'image3.jpg',
      duration: '4:12',
      artistName: 'Aster Abebe',
      name: 'Eski Yengeregn',
    ),
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Dawit Getachew',
      name: 'Amelkalew',
    ),
    Music(
      imageName: 'artist_image2.jpg',
      duration: '4:12',
      artistName: 'Hana Tekle',
      name: 'Anileyayem',
    ),
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Bereket Tesfaye',
      name: 'Yibezal',
    ),
    Music(
      imageName: 'artist_image.jpg',
      duration: '4:12',
      artistName: 'Dawit Getachew',
      name: 'Etebkihalehi',
    ),
    Music(
      imageName: 'image3.jpg',
      duration: '4:12',
      artistName: 'Aster Abebe',
      name: 'Eski Yengeregn',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //upper section containing the image, svg, shuffle button and healing track
              upperSection(context),
              SizedBox(
                height: 20,
              ),

              playListStat(),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.8),
              ),
              SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 160,
                  height: 40,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Shuffle Play',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //ad section
              // _adContainer('ad.png'),
              SizedBox(
                height: 15,
              ),
              searchBar(),

              SizedBox(
                height: 15,
              ),

              Container(
                height: 320,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _musics.length,
                    itemBuilder: (context, index) {
                      return musicTile(
                        _musics[index],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Music {
  String name;
  String artistName;
  String duration;
  String imageName;
  Music({this.artistName, this.name, this.imageName, this.duration});
}
