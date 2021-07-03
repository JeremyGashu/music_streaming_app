import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingPlaylistShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey.withOpacity(0.5),
      baseColor: Colors.grey.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Container(
              height: 90,
              width: 90,
              color: Colors.grey.withOpacity(0.3),
            ),
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
