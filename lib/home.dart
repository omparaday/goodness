import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DeedHelper.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:goodness/dbhelpers/WordData.dart';

import 'dbhelpers/QuoteHelper.dart';

enum ProcessState {
  NotTaken,
  Greeting,
  WritingAbout,
  ShowingWord,
  OfferingDeed,
  ShowingQuote,
  Completed
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

const double diameter = 300;
const double inset = 30;
const double radius = diameter/2;
const double sideOfSquare = diameter/(2*math.sqrt2);

class _HomePageState extends State<HomePage> {
  double _x = radius, _y = radius;
  bool _enableSubmit = false;
  ProcessState _processState = ProcessState.NotTaken;
  late TextEditingController _writeAboutController;
  late WordData _wordData;
  bool _showDeed = false;
  late Deed _deed;
  late Quote _quote;

  @override
  void initState() {
    super.initState();
    _writeAboutController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Widget bigCircle = Container(
      margin: const EdgeInsets.all(inset),
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          startAngle: -1.5,
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
              painter: LinePainter(),
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
                  ? (TapUpDetails details) => {
                setState(() {
                  _x = details.localPosition.dx;
                  _y = details.localPosition.dy;
                  print('$_x, $_y');
                  double angle = -math.atan2(_y - 165, _x - 165);
                  double degree = angle * 180/math.pi;
                  //print(degree);
                  _enableSubmit = true;
                })
              }
                  : (TapUpDetails details) => null,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                    top: _y - 15,
                    left: _x - 10,
                    child: Text('🛟'),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );

    return CupertinoApp(
      //color: CupertinoColors.black,
        home: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    bigCircle,
                    const Positioned(
                      top: sideOfSquare,
                      left: diameter + inset,
                      child: Text('😊'),
                    ),
                    const Positioned(
                      top: diameter - sideOfSquare + inset,
                      left: diameter + inset,
                      child: Text("😃"),
                    ),
                    const Positioned(
                      top: diameter + inset/2,
                      left: radius + sideOfSquare,
                      child: Text("😴"),
                    ),
                    const Positioned(
                      top: diameter + inset/2,
                      left: sideOfSquare,
                      child: Text("😢"),
                    ),
                    const Positioned(
                      top: diameter - sideOfSquare + inset,
                      left: inset/2,
                      child: Text("😔"),
                    ),
                    const Positioned(
                      top: sideOfSquare,
                      left: inset/2,
                      child: Text("🤒"),
                    ),
                    const Positioned(
                      top: inset/2,
                      left: sideOfSquare,
                      child: Text("😡"),
                    ),
                    const Positioned(
                      top: inset/2,
                      left: radius + sideOfSquare,
                      child: Text("🤗"),
                    ),
                  ],
                ),
                (_processState.index > ProcessState.NotTaken.index
                    ? Text('Take a deep breath')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.WritingAbout.index
                    ? Text('Your mood')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.WritingAbout.index
                    ? CupertinoTextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _writeAboutController,
                  placeholder: 'Write a few words about why you feel so today.',
                )
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingWord.index
                    ? Text('Word of the Day: ${_wordData.word}')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingWord.index
                    ? Text('Definition:\n${_wordData.meaning}')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.OfferingDeed.index && !_showDeed
                    ? CupertinoButton(
                    onPressed: () => showDeed(),
                    child: Text('Click here you want to do a good deed'))
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.OfferingDeed.index && _showDeed
                    ? Text('Good Deed for the day')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.OfferingDeed.index && _showDeed
                    ? Text(_deed.content)
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingQuote.index
                    ? Text('Quote for the day')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingQuote.index
                    ? Text(_quote.content)
                    : SizedBox.shrink()),
                CupertinoButton(
                  onPressed: _enableSubmit ? () => startFlow() : null,
                  child: _processState == ProcessState.ShowingQuote
                      ? Text('Submit')
                      : Text('Proceed'),
                ),
              ],
            ),
          ),
        ));
  }

  startFlow() async {
    print('inside flow');
    if (_processState == ProcessState.WritingAbout) {
      _wordData = await getNewWord();
    } else if (_processState == ProcessState.ShowingWord) {
      _deed = await getNewDeed();
    } else if (_processState == ProcessState.OfferingDeed) {
      _quote = await getNewQuote();
    }
    setState(() {
      // NotTaken, Greeting, WritingAbout, ShowingWord, OfferingDeed, ShowingQuote, Completed
      switch (_processState) {
        case ProcessState.NotTaken:
          _processState = ProcessState.Greeting;
          break;
        case ProcessState.Greeting:
          _processState = ProcessState.WritingAbout;
          break;
        case ProcessState.WritingAbout:
          _processState = ProcessState.ShowingWord;
          break;
        case ProcessState.ShowingWord:
          _processState = ProcessState.OfferingDeed;
          break;
        case ProcessState.OfferingDeed:
          _processState = ProcessState.ShowingQuote;
          break;
        case ProcessState.ShowingQuote:
          _processState = ProcessState.Completed;
          break;
      }
    });
  }

  showDeed() {
    setState(() {
      _showDeed = true;
    });
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.white
      ..strokeWidth = 5;
    canvas.drawLine(Offset(radius, 0), Offset(radius, diameter), paint);
    canvas.drawLine(Offset(0, radius), Offset(diameter, radius), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius - sideOfSquare), Offset(radius + sideOfSquare, radius + sideOfSquare), paint);
    canvas.drawLine(Offset(radius - sideOfSquare, radius + sideOfSquare), Offset(radius + sideOfSquare, radius - sideOfSquare), paint);
    //canvas.drawLine(Offset(90, 23), Offset(243, 317), paint);
    //canvas.drawLine(Offset(24, 90), Offset(319, 226), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}