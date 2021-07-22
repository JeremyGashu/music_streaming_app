import 'package:flutter/material.dart';

class SpinningImage extends StatefulWidget {
  final String imageUrl;
  final bool spin;
  SpinningImage({@required this.imageUrl, this.spin=true});

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
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
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
    print("Widget spinning ${widget.spin}");
    if(!widget.spin){
      if(_controller.isAnimating)
      _controller.stop();
    }else{
      if(!_controller.isAnimating)
        _controller.forward();
    }
    // TODO: implement build
    return RotationTransition(
      turns: _animation,
      child: Image.asset(
        "assets/images/album_disk_new.png",
        height: 45,
        width: 45,
      ),
    );
  }
}
