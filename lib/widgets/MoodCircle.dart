import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import '../home.dart';
import 'dart:math' as math;

import '../l10n/Localizations.dart';

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
              painter: LinePainter(context, diameter, radius, sideOfSquare),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
                CupertinoTheme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(1),
                CupertinoTheme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0)
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
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            bigCircle,
            Positioned(
              top: sideOfSquare,
              left: diameter + inset,
              child: getEmoji("😊", context),
            ),
            Positioned(
              top: diameter - sideOfSquare + inset,
              left: diameter + inset,
              child: getEmoji("😃", context),
            ),
            Positioned(
              top: diameter + inset / 2,
              left: radius + sideOfSquare,
              child: getEmoji("😴", context),
            ),
            Positioned(
              top: diameter + inset / 2,
              left: sideOfSquare,
              child: getEmoji("😢", context),
            ),
            Positioned(
              top: diameter - sideOfSquare + inset,
              left: inset / 2,
              child: getEmoji("😔", context),
            ),
            Positioned(
              top: sideOfSquare,
              left: inset / 2,
              child: getEmoji("🤒", context),
            ),
            Positioned(
              top: inset / 2,
              left: sideOfSquare,
              child: getEmoji("😡", context),
            ),
            Positioned(
              top: inset / 2,
              left: radius + sideOfSquare,
              child: getEmoji("🤗", context),
            ),
          ],
        ),
        Text(getMoodText(context))
      ],
    );
  }

  String getMoodNameForEmoji(String emoji, BuildContext context) {
    switch (emoji) {
      case "😊":
        return L10n.of(context).resource('happy');
      case "😃":
        return L10n.of(context).resource('excited');
      case "😴":
        return L10n.of(context).resource('peaceful');
      case "😢":
        return L10n.of(context).resource('fear');
      case "😔":
        return L10n.of(context).resource('sad');
      case "🤒":
        return L10n.of(context).resource('weak');
      case "😡":
        return L10n.of(context).resource('angry');
      case "🤗":
        return L10n.of(context).resource('strong');
    }
    return '';
  }

  Widget getEmoji(String s, BuildContext context) {
    return Tooltip(message: getMoodNameForEmoji(s, context), child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: s,
            style: TextStyle(
              fontFamily: 'EmojiOne',
            ),
          ),
        ],
      ),
    ));
  }

  String getMoodText(BuildContext context) {
    if (x == radius && y == radius) {
      return '';
    }
    double distance =
        math.sqrt(math.pow(x - radius, 2) + math.pow(y - radius, 2));
    double strength = distance * 100 / radius;
    String text = '';
    if (strength > 80) {
      text = sprintf(L10n.of(context).resource('highMood'),
          [getMoodNameForEmoji(getEmojiForXy(x, y, radius), context)]);
    } else if (strength > 50) {
      text = sprintf(L10n.of(context).resource('moderateMood'),
          [getMoodNameForEmoji(getEmojiForXy(x, y, radius), context)]);
    } else {
      text = sprintf(L10n.of(context).resource('slightMood'),
          [getMoodNameForEmoji(getEmojiForXy(x, y, radius), context)]);
    }
    return text;
  }
}

String getEmojiForXy(double x, double y, double radius) {
  double angle = -math.atan2(y - radius, x - radius);
  double degree = angle * 180 / math.pi;
  print('degree ' + degree.toString());
  if (degree > 0 && degree <= 45) {
    return '😊';
  } else if (degree > 45 && degree <= 90) {
    return '🤗';
  } else if (degree > -45 && degree <= 0) {
    return '😃';
  } else if (degree > 90 && degree <= 135) {
    return '😡';
  } else if (degree > 135 && degree <= 180) {
    return '🤒';
  } else if (degree > -90 && degree <= -44) {
    return '😴';
  } else if (degree > -135 && degree <= -90) {
    return '😢';
  }
  return '😔';
}

class LinePainter extends CustomPainter {
  LinePainter(this.context, this.diameter, this.radius, this.sideOfSquare) {}
  double radius, diameter, sideOfSquare;
  BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoTheme.of(context).scaffoldBackgroundColor
      ..strokeWidth = 5;
    canvas.drawLine(Offset(radius, 0), Offset(radius, diameter), paint);
    canvas.drawLine(Offset(0, radius), Offset(diameter, radius), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius - sideOfSquare),
        Offset(radius + sideOfSquare, radius + sideOfSquare), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius + sideOfSquare),
        Offset(radius + sideOfSquare, radius - sideOfSquare), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
