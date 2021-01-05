import 'package:dog_breed/utils/sizing.dart';
import 'package:flutter/material.dart';
import 'package:dog_breed/utils/animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedSplashScreen extends StatefulWidget {
  AnimatedSplashScreen({this.color});

  final Color color;

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController _controller;
  StaggeredRaindropAnimation _animation;

  @override
  void initState()  {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = StaggeredRaindropAnimation(_controller);
    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });

    precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/image_background.svg'), null);
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);

    return Stack(children: [
      Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
              painter: HolePainter(
                  color: widget.color,
                  holeSize: _animation.holeSize.value * size.width))),
      Positioned(
          top: _animation.dropPosition.value * size.height,
          left: size.width / 2 - _animation.dropSize.value / 2,
          child: SizedBox(
              width: _animation.dropSize.value,
              height: _animation.dropSize.value,
              child: CustomPaint(
                painter: DropPainter(visible: _animation.dropVisible.value),
              ))),
      Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                  opacity: _animation.textOpacity.value,
                  child: Text(
                    'AsiaSoft',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: SizeConfig.textSP(90),
                      fontFamily: "Billy",
                      fontWeight: FontWeight.w600,
                    ),
                  )
              )
          )
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DropPainter extends CustomPainter {
  DropPainter({this.visible = true});

  bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) {
      return;
    }

    Path path = new Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height * 0.8, size.width / 2, size.height);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width / 2, 0);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
