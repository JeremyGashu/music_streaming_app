import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streaming_mobile/bloc/singletrack/track_bloc.dart';
import 'package:streaming_mobile/bloc/singletrack/track_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';

class SingleTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TrackBloc, TrackState>(
        builder: (ctx, state) {
          if (state is LoadedTrack) {
            return GestureDetector(
              onTap: () {
                print(state.track);
              },
              child: Container(
                width: 140,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 120,
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/images/singletrack_one.jpg',
                              width: 140.0,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Amelkalew',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'Dawit Getachew',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: kGray,
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '04:13',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kYellow,
                                  fontSize: 12.0),
                            ),
                          )
                        ],
                      )
                    ]),
              ),
            );
          } else if (state is LoadingTrackError) {
            return Center(
              child: Text(
                'Failed Loading playlists!',
              ),
            );
          } else if (state is LoadingTrack) {
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
