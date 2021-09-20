import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class SpinningImage extends StatefulWidget {
  final String imageUrl;
  SpinningImage({@required this.imageUrl});

  @override
  State<StatefulWidget> createState() {
    return _SpinningImageState();
  }
}

class _SpinningImageState extends State<SpinningImage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  // Animation<double> _animationStopped;
  double animationValue = 0.0;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
      value: animationValue,
      
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

  _controller.addStatusListener((status) { 
    print('current animation status =>  $status');
    if(status == AnimationStatus.completed) {
      _controller.repeat();
    }
  });

    // _animationStopped = Tween(begin: _animation.value, end: _animation.value).animate(_controller);
    print("Animation Value: ${_animation.value}");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, AsyncSnapshot<PlaybackState> snapshot) {
        if (snapshot.hasData) {
          print("please tell me the current playing state: ${snapshot.data.playing}");

          if (!snapshot.data.playing) {
            if (_controller.isAnimating) _controller.stop();
          } else {
            if (!_controller.isAnimating) _controller.forward();
          }
        }
        if (snapshot.hasData) {
          return snapshot.data.playing
              ? RotationTransition(
                  turns: _animation,
                  child: Image.asset(
                    "assets/images/album_disk_new.png",
                    height: 45,
                    width: 45,
                  ),
                )
              : Image.asset(
                  "assets/images/album_disk_new.png",
                  height: 45,
                  width: 45,
                );
        }
        return SizedBox();
      },
    );
  }
}
