import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodness/main.dart';
import 'package:sprintf/sprintf.dart';

import '../home.dart';
import '../home.dart' as home;
import 'dart:math' as math;
import 'dart:io' show Platform;

import '../l10n/Localizations.dart';
import 'ArcText.dart';

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
    final Size smileySize = getSmileySize(context);
    final Size arctextSize = getArcTextSize(context);
    Widget bigCircle = Container(
      margin: EdgeInsets.only(
          left: inset - 10, right: inset - 10, top: inset, bottom: inset),
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
              onPanUpdate: _processState != ProcessState.Completed
                  ? (details) => onTapUp(
                      details.localPosition.dx, details.localPosition.dy)
                  : (details) => null,
              onPanStart: _processState != ProcessState.Completed
                  ? (details) => onTapUp(
                      details.localPosition.dx, details.localPosition.dy)
                  : (details) => null,
              onTapUp: _processState != ProcessState.Completed
                  ? (details) => onTapUp(
                  details.localPosition.dx, details.localPosition.dy)
                  : (details) => null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                    top: y - 15,
                    left: x - 10,
                    child: getEmoji(Platform.isAndroid ? '🔔' : '🛟', context),
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
          fit: StackFit.passthrough,
          children: <Widget>[
            bigCircle,
            Positioned(
              top: getTop(11*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(11*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😊", context),
            ),
            Positioned(
              top: getTop(13*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(13*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😃", context),
            ),
            Positioned(
              top: getTop(15*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(15*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😴", context),
            ),
            Positioned(
              top: getTop(math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😢", context),
            ),
            Positioned(
              top: getTop(3 * math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(3 * math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😔", context),
            ),
            Positioned(
              top: getTop(5*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(5*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("🤒", context),
            ),
            Positioned(
              top: getTop(7*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(7*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("😡", context),
            ),
            Positioned(
              top: getTop(9*math.pi/8, smileySize.height, arctextSize.height),
              left: getLeft(9*math.pi/8, smileySize.height, smileySize.width, arctextSize.height),
              child: getEmoji("🤗", context),
            ),
            this.diameter != home.diameter ? SizedBox.shrink() : Positioned(
                top: radius + inset,
                left: radius + inset - 10,
                child: Stack(children: <Widget>[
                  buildArcText(context, '😊', 0.25+ math.pi / 4),
                  buildArcText(context, '😃', 0.2 + math.pi / 2),
                  buildArcText(context, '😴', 0.15 + (3 * math.pi / 4)),
                  buildArcText(context, '😢', 0.3 + math.pi),
                  buildArcText(context, '😔', 0.3 + (5 * math.pi / 4)),
                  buildArcText(context, '🤒', 0.25 + (3 * math.pi / 2)),
                  buildArcText(context, '😡', 0.25 + (7 * math.pi / 4)),
                  buildArcText(context, '🤗', 0.25 + 0)
                ])),
          ],
        ),
        Text(
          getMoodText(context),
          style: TextStyle(fontSize: LARGE_FONTSIZE),
        ),
      ],
    );
  }

  ArcText buildArcText(BuildContext context, String emoji, double startAngle) {
    return ArcText(
      radius: radius - 2,
      text: getMoodNameForEmoji(emoji, context),
      textStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: SMALL_FONTSIZE),
      startAngle: startAngle,
      key: null,
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
    return Tooltip(
        message: getMoodNameForEmoji(s, context),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: s,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: LARGE_FONTSIZE,
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

  getTop(double angle, double smileyHeight, double arctextHeight) {
    return inset + radius + (((diameter != home.diameter ? 0 : arctextHeight) + smileyHeight/2 + radius) * math.cos(angle)) - smileyHeight/2;
  }

  getLeft(double angle, double smileyHeight, double smileyWidth, double arctextHeight) {
    return (inset-10) + radius + (-((diameter != home.diameter ? 0 : arctextHeight) + smileyHeight/2 + radius) * math.sin(angle)) - smileyWidth/2;
  }
}

String getEmojiForXy(double x, double y, double radius) {
  double angle = -math.atan2(y - radius, x - radius);
  double degree = angle * 180 / math.pi;
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

Size getSmileySize(BuildContext context) {
  return (TextPainter(
      text: TextSpan(text: '😡', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: LARGE_FONTSIZE,
        fontFamily: 'EmojiOne',)),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity))
      .size;
}

Size getArcTextSize(BuildContext context) {
  return (TextPainter(
      text: TextSpan(text: 'W', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: SMALL_FONTSIZE)),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity))
      .size;
}
