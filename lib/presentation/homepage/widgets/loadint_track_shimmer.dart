import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTrackShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey.withOpacity(0.5),
      baseColor: Colors.grey.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 130,
            margin: EdgeInsets.all(5),
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12,
                width: 100,
                color: Colors.grey.withOpacity(0.3),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                height: 12,
                width: 80,
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
