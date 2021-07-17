import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';
import 'package:streaming_mobile/presentation/common_widgets/album.dart';
import 'package:streaming_mobile/presentation/search/widgets/custom_list_tile.dart';
import 'package:streaming_mobile/presentation/search/widgets/custom_title_text.dart';
import 'package:streaming_mobile/presentation/search/widgets/play_list_card.dart';
import 'package:streaming_mobile/presentation/search/widgets/search_field.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
            0,
            getHeight(60),
            0,
            getHeight(10),
          ),
          child: Column(
            children: [
              SearchField(),
              CustomTitleText(
                text: 'Recently Searched',
                onTapHandler: () {},
              ),
              Container(
                height: 220,
                padding: EdgeInsets.only(right: 4, left: 4),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: getHeight(6)),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return MusicListTile();
                    }),
              ),
              CustomTitleText(
                text: 'Popular Playlist',
                onTapHandler: () {},
              ),
              Container(
                height:
                    SizeConfig.orientation == Orientation.portrait ? 160 : 200,
                padding: EdgeInsets.only(right: 4, left: 4),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    PlaylistCard(
                      imageUrl: 'assets/images/singletrack_one.jpg',
                    ),
                    PlaylistCard(
                      imageUrl: 'assets/images/artist_image2.jpg',
                    ),
                    PlaylistCard(
                      imageUrl: 'assets/images/singletrack_one.jpg',
                    ),
                    PlaylistCard(
                      imageUrl: 'assets/images/artist_image2.jpg',
                    ),
                  ],
                ),
              ),
              CustomTitleText(
                text: 'New Releases',
                onTapHandler: () {},
              ),
              Container(
                  padding: EdgeInsets.only(right: 4, left: 4),
                  height: 190,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SingleAlbum(
                        album: null,
                      ),
                      SingleAlbum(album: null),
                    ],
                  )),
              CustomTitleText(
                text: 'Albums',
                onTapHandler: () {},
              ),
              Container(
                  padding: EdgeInsets.only(right: 4, left: 4),
                  height: 190,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SingleAlbum(
                        album: null,
                      ),
                      SingleAlbum(album: null),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
