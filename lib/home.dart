import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart' as dailydata;
import 'package:goodness/dbhelpers/DeedHelper.dart' as deed;
import 'package:goodness/main.dart';
import 'dart:math' as math;

import 'package:goodness/widgets/DecoratedText.dart';
import 'package:goodness/widgets/DecoratedWidget.dart';
import 'package:goodness/widgets/MoodCircle.dart';
import 'package:sprintf/sprintf.dart';

import 'dbhelpers/QuestionHelper.dart' as question;
import 'dbhelpers/QuoteHelper.dart' as quote;
import 'l10n/Localizations.dart';

enum ProcessState {
  NotTaken,
  Greeting,
  WritingAbout,
  ShowingQuestion,
  OfferingDeed,
  ShowingQuote,
  Completed
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

const double diameter = 300;
const double inset = 40;
const double radius = diameter / 2;
const double sideOfSquare = radius / math.sqrt2;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  double _x = radius, _y = radius;
  bool _enableSubmit = false;
  ProcessState _processState = ProcessState.NotTaken;
  late TextEditingController _writeAboutController;
  late question.Question? _question;
  late TextEditingController _answerController;
  bool _showDeed = false;
  late deed.Deed? _deed;
  late quote.Quote? _quote;
  late int _goodnessScore;
  late dailydata.DailyData? _todayData;
  late String _dateKey;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_dateKey != dailydata.getDateKeyFormat(DateTime.now())) {
          _dateKey = dailydata.getDateKeyFormat(DateTime.now());
          readTodayData();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _writeAboutController = TextEditingController();
    _answerController = TextEditingController();
    _dateKey = dailydata.getDateKeyFormat(DateTime.now());
    readTodayData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Widget moodCircle = getMoodCircle();

    return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  moodCircle,
                  (_processState.index > ProcessState.NotTaken.index
                      ? DecoratedText(
                          getHappyState()
                              ? L10n.of(context).resource('lookAroundSmile')
                              : L10n.of(context).resource('deepBreath'),
                          textStyle: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : SizedBox.shrink()),
                  (_processState.index >= ProcessState.WritingAbout.index
                      ? DecoratedWidget(Column(children: <Widget>[
                          Text(L10n.of(context).resource('yourMood')),
                          CupertinoTextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _writeAboutController,
                            enabled: _processState.index !=
                                ProcessState.Completed.index,
                            placeholder: _processState.index !=
                                    ProcessState.Completed.index
                                ? L10n.of(context).resource('writeAboutFeel')
                                : L10n.of(context).resource('didNotWrite'),
                          )
                        ]))
                      : SizedBox.shrink()),
                  (_processState.index >= ProcessState.ShowingQuestion.index
                      ? DecoratedWidget(Column(
                          children: <Widget>[
                            Text(_question?.content ?? ''),
                            CupertinoTextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _answerController,
                              enabled: _processState.index !=
                                  ProcessState.Completed.index,
                              placeholder: _processState.index !=
                                      ProcessState.Completed.index
                                  ? L10n.of(context).resource('yourAnswer')
                                  : L10n.of(context).resource('didNotWrite'),
                            )
                          ],
                        ))
                      : SizedBox.shrink()),
                  (_processState.index >= ProcessState.OfferingDeed.index &&
                          _processState != ProcessState.Completed &&
                          !_showDeed
                      ? CupertinoButton(
                          onPressed: () => showDeed(),
                          child: Text(
                              L10n.of(context).resource('clickForGoodDeed')))
                      : SizedBox.shrink()),
                  (_processState.index >= ProcessState.OfferingDeed.index &&
                          _showDeed
                      ? DecoratedText(sprintf(
                          L10n.of(context).resource('deedForTheDay'),
                          [_deed!.content]))
                      : SizedBox.shrink()),
                  (_processState.index >= ProcessState.ShowingQuote.index
                      ? DecoratedText(sprintf(
                          L10n.of(context).resource('quoteWithContent'),
                          [_quote!.content]))
                      : SizedBox.shrink()),
                  (_processState.index < ProcessState.Completed.index
                      ? CupertinoButton(
                          onPressed: _enableSubmit ? () => startFlow() : null,
                          child: AnimatedOpacity(
                              opacity: _enableSubmit ? 1.0 : 0.0,
                              duration: Duration(seconds: 1),
                              child: _processState == ProcessState.ShowingQuote
                                  ? Text(L10n.of(context).resource('submit'))
                                  : Text(L10n.of(context).resource('proceed'))),
                        )
                      : DecoratedText(
                          _goodnessScore >= 100
                              ? L10n.of(context).resource('yourscorePerfect100')
                              : sprintf(
                                  L10n.of(context).resource('yourscoreWithVal'),
                                  [_goodnessScore]),
                          textStyle: TextStyle(fontSize: MEDIUM_FONTSIZE, fontWeight: FontWeight.bold),
                        )),
                ],
              ),
            ),
          ),
        ));
  }

  MoodCircle getMoodCircle() {
    return MoodCircle(diameter, inset, radius, sideOfSquare, _processState,
        onTapUpCallback, _x, _y);
  }

  Set<void> onTapUpCallback(TapUpDetails details) {
    return {
      setState(() {
        _x = details.localPosition.dx;
        _y = details.localPosition.dy;
        _enableSubmit = true;
      })
    };
  }

  startFlow() async {
    _enableSubmit = false;
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _enableSubmit = true;
      });
    });
    if (_processState == ProcessState.WritingAbout) {
      _question = await question.getNewQuestion();
    } else if (_processState == ProcessState.ShowingQuestion) {
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
          _processState = ProcessState.ShowingQuestion;
          break;
        case ProcessState.ShowingQuestion:
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
    bool isHappy = getHappyState();
    double distance =
        math.sqrt(math.pow(_x - radius, 2) + math.pow(_y - radius, 2));
    _goodnessScore = (50 * distance / radius).round();
    int writtenLength = _writeAboutController.text.length;
    writtenLength += _answerController.text.length;
    double writtenFactor = 1.2;
    if (writtenLength <= 10) {
      writtenFactor = 0.8;
    } else if (writtenLength <= 30) {
      writtenFactor = 1.0;
    }
    if (isHappy) {
      _goodnessScore += 50;
      _goodnessScore = (_goodnessScore * writtenFactor).round();
    } else {
      _goodnessScore = 50 - _goodnessScore;
      _goodnessScore = (_goodnessScore < 10) ? 10 : _goodnessScore;
      _goodnessScore = (_goodnessScore * writtenFactor).round();
    }
    if (_showDeed) {
      _goodnessScore = (_goodnessScore * 1.1).round();
    }
    if (_goodnessScore > 100) {
      _goodnessScore = 100;
    }
  }

  bool getHappyState() {
    double angle = -math.atan2(_y - 165, _x - 165);
    double degree = angle * 180 / math.pi;
    bool isHappy = (degree >= -95 && degree <= 95);
    return isHappy;
  }

  Future<void> readTodayData() async {
    _todayData = await dailydata.getDataForDay(_dateKey);
    if (_todayData != null) {
      var quote2 = await quote.getQuoteForKey(_todayData!.quoteKey);
      var question2 =
          await question.getQuestionForKey(_todayData!.questionKey ?? '');
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
        _question = question2;
        _answerController.text = _todayData!.answer ?? '';
      });
    } else {
      setState(() {
        _processState = ProcessState.NotTaken;
        _x = radius;
        _y = radius;
        _goodnessScore = 0;
        _writeAboutController.text = '';
        _quote = null;
        _question = null;
        _answerController.text = '';
        _showDeed = false;
        _deed = null;
        _enableSubmit = false;
      });
    }
  }

  void submit() {
    _todayData = new dailydata.DailyData(
        _x,
        _y,
        _quote!.name,
        _writeAboutController.text,
        _question!.key,
        _answerController.text,
        _showDeed ? _deed!.name : null,
        _goodnessScore);
    dailydata.addDailyData(_dateKey, _todayData!);
  }
}
