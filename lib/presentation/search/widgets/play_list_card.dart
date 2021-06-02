import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';

class PlaylistCard extends StatelessWidget {
  final String imageUrl;
  const PlaylistCard({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getWidth(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                ),
              ),
              CircleAvatar(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50)),
                ),
                backgroundColor: Colors.transparent,
                maxRadius: 50,
              ),
              Container(
                child: SvgPicture.asset(
                  'assets/svgs/Playlist.svg',
                  height: 40,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: getHeight(5)),
                child: Text(
                  '50 New songs',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.amber,
                      size: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      '35,926',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: Colors.grey,
                          fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
