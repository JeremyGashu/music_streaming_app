import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_detail_page.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/search/pages/search_page.dart';

class ArtistsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          //back button and search page
          _upperSection(context),
          // Divider(),
          BlocBuilder<ArtistBloc, ArtistState>(builder: (context, state) {
            if (state is LoadedArtist) {
              return Expanded(
                  child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: state.artists.map((artist) {
                  return _artistTile(
                      onTap: () {
                        print('artist id => ${artist.artistId}');
                        Navigator.pushNamed(
                            context, ArtistDetailPage.artistDetailPageRouteName,
                            arguments: artist);
                      },
                      name: artist.firstName + ' ' + artist.lastName,
                      imageUrl: artist.image,
                      likes: 0.toString());
                }).toList(),
              ));
            } else if (state is LoadingArtist) {
              return Center(
                child: SpinKitRipple(
                  color: Colors.grey,
                  size: 40,
                ),
              );
            } else if (state is LoadingArtistError) {
              return Expanded(
                child: CustomErrorWidget(
                    onTap: () {
                      BlocProvider.of<ArtistBloc>(context).add(LoadArtists());
                    },
                    message: 'Error Loading Artists!'),
              );
            }
            return Container();
          }),
        ],
      ),
    ));
  }
}

Widget _artistTile(
    {Function onTap, String name, String likes, String imageUrl}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/images/artist_one.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 1.05),
                  ),
                  Text(
                    '3 - Albums, 42 - Tracks',
                    style: TextStyle(
                      color: Colors.yellow[900],
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(likes),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _upperSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage()));
          },
        ),
      ),
    ],
  );
}
