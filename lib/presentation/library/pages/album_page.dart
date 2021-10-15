import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/presentation/library/widgets/album.dart';
import 'package:streaming_mobile/presentation/library/widgets/music_list_tile.dart';
import 'package:streaming_mobile/presentation/library/widgets/search_bar.dart';

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black.withOpacity(0.8),
                ),
                onPressed: () {},
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Recommended for you',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View All >',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:  Colors.orange,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Album(),
                    Album(),
                    Album(),
                    Album(),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    color: Colors.orange,
                    width: 160,
                    height: 40,
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.shuffle, color: Colors.white),
                        label: Text(
                          'Shuffle Play',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                    MusicListTile(),
                    MusicListTile(),
                    MusicListTile(),
                    MusicListTile(),
                    MusicListTile(),
                    MusicListTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
