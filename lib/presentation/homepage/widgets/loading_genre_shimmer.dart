import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGenreShimmer extends StatelessWidget {
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
        ],
      ),
    );
  }
}
