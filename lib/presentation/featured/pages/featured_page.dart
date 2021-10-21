import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/featured/widgets/ad_container.dart';
import 'package:streaming_mobile/presentation/featured/widgets/album_list_tile.dart';
import 'package:streaming_mobile/presentation/featured/widgets/featured_lists.dart';
import 'package:streaming_mobile/presentation/featured/widgets/search_bar.dart';

class FeaturedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.grey.withOpacity(0.8),
              ),
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Featured',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 18,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FeaturedList(albumArt: 'singletrack_one.jpg'),
                  FeaturedList(albumArt: 'album_one.jpg'),
                  FeaturedList(albumArt: 'singletrack_one.jpg'),
                  FeaturedList(albumArt: 'album_one.jpg'),
                ],
              ),
            ),
            Divider(),
            AdContainer('ad.png'),
            SizedBox(
              height: 10,
            ),
            SearchBar(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              child: ListView(
                children: [
                  AlbumListTile(),
                  AlbumListTile(),
                  AlbumListTile(),
                  AlbumListTile(),
                  AlbumListTile(),
                  AlbumListTile(),
                  AlbumListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
