import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'dart:math' as math;

class MoodCircle extends StatelessWidget {
  MoodCircle(double this.diameter, this.inset, this.radius, this.sideOfSquare,
      this._processState, this.onTapUp, this.x, this.y,
      {Key? key})
      : super(key: key);

  double diameter;
  double inset;
  double radius;
  double sideOfSquare;
  ProcessState _processState;
  Function onTapUp;
  double x, y;

  @override
  Widget build(BuildContext context) {
    Widget bigCircle = Container(
      margin: EdgeInsets.all(inset),
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          transform: GradientRotation(-math.pi / 5),
          colors: <Color>[
            CupertinoColors.systemIndigo,
            CupertinoColors.systemBlue,
            CupertinoColors.systemTeal,
            CupertinoColors.systemGreen,
            CupertinoColors.systemYellow,
            CupertinoColors.systemOrange,
            CupertinoColors.systemRed,
            CupertinoColors.systemPurple,
            CupertinoColors.systemIndigo,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            child: CustomPaint(
              painter: LinePainter(diameter, radius, sideOfSquare),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
                CupertinoColors.white.withOpacity(1),
                CupertinoColors.white.withOpacity(0)
              ]),
            ),
            child: GestureDetector(
              onTapUp: _processState == ProcessState.NotTaken
                  ? (TapUpDetails details) => onTapUp(details)
                  : (TapUpDetails details) => null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                    top: y - 15,
                    left: x - 10,
                    child: Text('🛟'),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
    return Stack(
      children: <Widget>[
        bigCircle,
        Positioned(
          top: sideOfSquare,
          left: diameter + inset,
          child: getEmoji('😊', 'Happy'),
        ),
        Positioned(
          top: diameter - sideOfSquare + inset,
          left: diameter + inset,
          child: getEmoji("😃", 'Excited'),
        ),
        Positioned(
          top: diameter + inset / 2,
          left: radius + sideOfSquare,
          child: getEmoji("😴", 'Peaceful'),
        ),
        Positioned(
          top: diameter + inset / 2,
          left: sideOfSquare,
          child: getEmoji("😢", 'Fear'),
        ),
        Positioned(
          top: diameter - sideOfSquare + inset,
          left: inset / 2,
          child: getEmoji("😔", 'Sad'),
        ),
        Positioned(
          top: sideOfSquare,
          left: inset / 2,
          child: getEmoji("🤒", 'Weak'),
        ),
        Positioned(
          top: inset / 2,
          left: sideOfSquare,
          child: getEmoji("😡", 'Angry'),
        ),
        Positioned(
          top: inset / 2,
          left: radius + sideOfSquare,
          child: getEmoji("🤗", 'Strong'),
        ),
      ],
    );
  }

  Widget getEmoji(String s, String tip) {
    return Tooltip(message: tip, child: Text(s));
  }
}

String getEmojiForXy(double x, double y) {
  double angle = -math.atan2(y - 165, x - 165);
  double degree = angle * 180 / math.pi;
  if (degree > 6 && degree <= 52) {
    return '😊';
  } else if (degree > 52 && degree <= 95) {
    return '🤗';
  } else if (degree > -44 && degree <= 6) {
    return '😃';
  } else if (degree > 95 && degree <= 134) {
    return '😡';
  } else if (degree > 134 && degree <= 175) {
    return '🤒';
  } else if (degree > -94 && degree <= -44) {
    return '😴';
  } else if (degree > -143 && degree <= -94) {
    return '😢';
  }
  return '😔';
}

class LinePainter extends CustomPainter {
  LinePainter(this.diameter, this.radius, this.sideOfSquare) {}
  double radius, diameter, sideOfSquare;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.white
      ..strokeWidth = 5;
    canvas.drawLine(Offset(radius, 0), Offset(radius, diameter), paint);
    canvas.drawLine(Offset(0, radius), Offset(diameter, radius), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius - sideOfSquare),
        Offset(radius + sideOfSquare, radius + sideOfSquare), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius + sideOfSquare),
        Offset(radius + sideOfSquare, radius - sideOfSquare), paint);
    //canvas.drawLine(Offset(90, 23), Offset(243, 317), paint);
    //canvas.drawLine(Offset(24, 90), Offset(319, 226), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
