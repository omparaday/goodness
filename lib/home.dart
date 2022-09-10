import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart' as dailydata;
import 'package:goodness/dbhelpers/DeedHelper.dart' as deed;
import 'dart:math' as math;

import 'package:goodness/dbhelpers/WordData.dart' as word;

import 'dbhelpers/QuoteHelper.dart' as quote;

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
  late word.WordData _wordData;
  bool _showDeed = false;
  late deed.Deed? _deed;
  late quote.Quote _quote;
  late int _goodnessScore;
  late dailydata.DailyData? _todayData;
  late String _dateKey;

  @override
  void initState() {
    super.initState();
    _writeAboutController = TextEditingController();
    _dateKey = dailydata.getDateKeyFormat(DateTime.now());
    readTodayData();
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
                  enabled: _processState.index != ProcessState.Completed.index,
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
                    ? Text(_deed!.content)
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingQuote.index
                    ? Text('Quote for the day')
                    : SizedBox.shrink()),
                (_processState.index >= ProcessState.ShowingQuote.index
                    ? Text(_quote.content)
                    : SizedBox.shrink()),
                (_processState.index < ProcessState.Completed.index
                    ? CupertinoButton(
                  onPressed: _enableSubmit ? () => startFlow() : null,
                  child: _processState == ProcessState.ShowingQuote
                      ? Text('Submit')
                      : Text('Proceed'),
                ) : Text('Your goodness score is $_goodnessScore')),
              ],
            ),
          ),
        ));
  }

  startFlow() async {
    if (_processState == ProcessState.WritingAbout) {
      _wordData = await word.getNewWord();
    } else if (_processState == ProcessState.ShowingWord) {
      _deed = await deed.getNewDeed();
    } else if (_processState == ProcessState.OfferingDeed) {
      _quote = await quote.getNewQuote();
    } else if (_processState == ProcessState.ShowingQuote) {
      measureGoodness();
      submit();
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

  void measureGoodness() {
    double angle = -math.atan2(_y - 165, _x - 165);
    double degree = angle * 180/math.pi;
    print('angle $angle');
    bool isHappy = (degree >= -95 && degree <=95);
    print('ishappy $isHappy');
    double distance = math.sqrt(math.pow(_x-radius, 2) + math.pow(_y-radius, 2));
    print('distance $distance');
    print('angle $degree');
    _goodnessScore = (50 * distance/radius).round();
    print('gs1 $_goodnessScore');
    int aboutLength = _writeAboutController.text.length;
    double aboutFactor = 1;
    if (aboutLength <= 10) {
      aboutFactor = 0.6;
    } else if (aboutLength <= 30) {
      aboutFactor = 0.8;
    }
    print('about fac $aboutFactor');
    if (isHappy) {
      _goodnessScore += 50;
      print('gs2 $_goodnessScore');
      _goodnessScore = (_goodnessScore * aboutFactor).round();
      print('gs3 $_goodnessScore');
    } else {
      _goodnessScore = 50-_goodnessScore;
      print('gs4 $_goodnessScore');
      _goodnessScore = (_goodnessScore * aboutFactor).round();
      print('gs5 $_goodnessScore');
    }
    if (_showDeed) {
      _goodnessScore = (_goodnessScore * 1.1).round();
      print('gs6 $_goodnessScore');
    }
    if (_goodnessScore >100) {
      _goodnessScore = 100;
      print('gs7 $_goodnessScore');
    }
    print('gs8 $_goodnessScore');
  }

  Future<void> readTodayData() async {
    _todayData = await dailydata.getDataForDay(_dateKey);
    if (_todayData != null) {
      var quote2 = await quote.getQuoteForKey(_todayData!.quoteKey);
      var wordData2 = await word.getWordForKey(_todayData!.wordKey);
      var deedKey2 = _todayData!.deedKey;
      if (deedKey2 != null) {
        _showDeed = true;
        _deed = await deed.getDeedForKey(deedKey2);
      }
      setState(() {
        _processState = ProcessState.Completed;
        _x = _todayData!.x;
        _y = _todayData!.y;
        _goodnessScore = _todayData!.goodness;
        _writeAboutController.text = _todayData!.about;
        _quote = quote2;
        _wordData = wordData2;
      });
    }
  }

  void submit() {
    _todayData = new dailydata.DailyData(_x, _y, _quote.name, _writeAboutController.text, _wordData.word, _showDeed ? _deed!.name: null, _goodnessScore);
    dailydata.addDailyData(_dateKey, _todayData!);
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