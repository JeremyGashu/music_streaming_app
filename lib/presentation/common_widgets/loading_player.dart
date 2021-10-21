import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streaming_mobile/core/size_constants.dart';

class LoadingPlayerWidget extends StatelessWidget {
  const LoadingPlayerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: kWidth(context),
      height: kHeight(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          //image
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  child: Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/images/artist_placeholder.png',
                        width: 400,
                        height: 400,
                      ),
                    ),
                  ),
                ),
                SpinKitRipple(
                  color: Colors.grey,
                  size: 50,
                ),
              ],
            ),
          ),

          //seekbar
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.black,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Container(
                    width: 100,
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          //controls
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.shuffle,
                    color: Colors.grey.withOpacity(0.3),
                    size: 34,
                  ),
                  Icon(
                    Icons.skip_previous,
                    color: Colors.grey.withOpacity(0.3),
                    size: 34,
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.grey.withOpacity(0.3),
                    size: 34,
                  ),
                  Icon(
                    Icons.skip_next,
                    color: Colors.grey.withOpacity(0.3),
                    size: 34,
                  ),
                  Icon(
                    Icons.repeat,
                    color: Colors.grey.withOpacity(0.3),
                    size: 34,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
