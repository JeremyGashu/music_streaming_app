import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/presentation/artist/pages/account_profile.dart';

class Artist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountProfile()));
        },
        child: Container(
          width: 120,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100,
              height: 100,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    'assets/images/artist_one.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Fenan Befikadu',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    '3 Albums, 42 Tracks',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kYellow,
                        fontSize: 12.0),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.favorite,
                        color: kYellow,
                        size: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '35,926',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kGray,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
