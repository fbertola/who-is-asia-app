import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class StaggeredRaindropAnimation {
  StaggeredRaindropAnimation(this.controller)
      : dropSize = Tween<double>(begin: 0, end: maximumDropSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeIn),
          ),
        ),
        dropPosition =
            Tween<double>(begin: 0, end: maximumRelativeDropY).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.2, 0.5, curve: Curves.easeIn),
          ),
        ),
        holeSize = Tween<double>(begin: 0, end: maximumHoleSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
        ),
        dropVisible = Tween<bool>(begin: true, end: false).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.5),
          ),
        ),
        textOpacity = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.7, curve: Curves.easeOut),
          ),
        );

  final AnimationController controller;

  final Animation<double> dropSize;
  final Animation<double> dropPosition;
  final Animation<bool> dropVisible;
  final Animation<double> holeSize;
  final Animation<double> textOpacity;

  static final double maximumDropSize = 20;
  static final double maximumRelativeDropY = 0.5;
  static final double maximumHoleSize = 10;
}

class HolePainter extends CustomPainter {
  HolePainter({
    @required this.color,
    @required this.holeSize,
  });

  Color color;
  double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = holeSize / 2;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect outerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    Rect innerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius / 2);

    Path transparentHole = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()
        ..addOval(outerCircleRect)
        ..close(),
    );

    Path halfTransparentRing = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(outerCircleRect)
        ..close(),
      Path()
        ..addOval(innerCircleRect)
        ..close(),
    );

    canvas.drawPath(transparentHole, Paint()..color = color);
    canvas.drawPath(
        halfTransparentRing, Paint()..color = color.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _JumpingDot extends AnimatedWidget {
  final TextStyle textStyle;

  _JumpingDot({Key key, Animation<double> animation, this.textStyle})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Transform.translate(
      offset: Offset(0, -animation.value),
      child: Text(
        '.',
        style: textStyle,
      ),
    );
  }
}

class JumpingDotsProgressIndicator extends StatefulWidget {
  final int numberOfDots;
  final double dotSpacing;
  final int milliseconds;
  final double beginTweenValue = 0.0;
  final double endTweenValue;
  final TextStyle textStyle;

  JumpingDotsProgressIndicator({
    this.numberOfDots = 3,
    this.dotSpacing = 0.0,
    this.milliseconds = 250,
    this.textStyle,
  }) : endTweenValue = textStyle.fontSize / 4;

  _JumpingDotsProgressIndicatorState createState() =>
      _JumpingDotsProgressIndicatorState(
        numberOfDots: numberOfDots,
        dotSpacing: dotSpacing,
        milliseconds: milliseconds,
        textStyle: textStyle,
      );
}

class _JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  int numberOfDots;
  int milliseconds;
  double dotSpacing;
  TextStyle textStyle;
  final List<AnimationController> controllers = <AnimationController>[];
  final List<Animation<double>> animations = <Animation<double>>[];
  final List<Widget> _widgets = <Widget>[];

  _JumpingDotsProgressIndicatorState({
    this.numberOfDots,
    this.textStyle,
    this.dotSpacing,
    this.milliseconds,
  });

  @override
  initState() {
    super.initState();
    for (var i = 0; i < numberOfDots; i++) {
      _addAnimationControllers();
      _buildAnimations(i);
      _addListOfDots(i);
    }

    controllers[0].forward();
  }

  void _addAnimationControllers() {
    controllers.add(AnimationController(
        duration: Duration(milliseconds: milliseconds), vsync: this));
  }

  void _addListOfDots(int index) {
    _widgets.add(Padding(
      padding: EdgeInsets.only(right: dotSpacing),
      child: _JumpingDot(
        animation: animations[index],
        textStyle: textStyle,
      ),
    ));
  }

  void _buildAnimations(int index) {
    animations.add(
        Tween(begin: widget.beginTweenValue, end: widget.endTweenValue)
            .animate(controllers[index])
              ..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed)
                  controllers[index].reverse();
                if (index == numberOfDots - 1 &&
                    status == AnimationStatus.dismissed) {
                  controllers[0].forward();
                }
                if (animations[index].value > widget.endTweenValue / 2 &&
                    index < numberOfDots - 1) {
                  controllers[index + 1].forward();
                }
              }));
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _widgets,
    );
  }

  dispose() {
    for (var i = 0; i < numberOfDots; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }
}
