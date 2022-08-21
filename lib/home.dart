import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DeedHelper.dart';
import 'dart:ui' as ui;

import 'package:goodness/dbhelpers/WordData.dart';

enum ProcessState { NotTaken, Greeting, WritingAbout, ShowingWord, OfferingDeed, ShowingQuote, Completed }

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _x = 165, _y = 175;
  bool _enableSubmit = false;
  ProcessState _processState = ProcessState.NotTaken;
  late TextEditingController _writeAboutController;
  late WordData _wordData;
  late Deed _deed;

  @override
  void initState() {
    super.initState();
    _writeAboutController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Widget bigCircle = Container(
      margin: const EdgeInsets.all(30.0),
      width: 340.0,
      height: 340.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          startAngle: 0,
          colors: <Color>[
            CupertinoColors.systemIndigo,
            CupertinoColors.systemBlue,
            CupertinoColors.systemGreen,
            CupertinoColors.systemYellow,
            CupertinoColors.systemOrange,
            CupertinoColors.systemRed,
            CupertinoColors.systemPurple,
            CupertinoColors.systemIndigo,
          ],
          //stops: const <double>[0.0, 0.5],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            CupertinoColors.white.withOpacity(1),
            CupertinoColors.white.withOpacity(0)
          ]),
        ),
        child: GestureDetector(
          onTapUp: _processState == ProcessState.NotTaken ? (TapUpDetails details) => {
            setState(() {
              _x = details.localPosition.dx;
              _y = details.localPosition.dy;
              print('$_x, $_y');
              _enableSubmit = true;
            })
          } : (TapUpDetails details) => null,
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
    );

    return CupertinoApp(
        color: CupertinoColors.black,
        home: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  bigCircle,
                  const Positioned(
                    top: 180.0,
                    left: 370.0,
                    child: Text('😊'),
                  ),
                  const Positioned(
                    top: 310.0,
                    left: 330.0,
                    child: Text("😃"),
                  ),
                  const Positioned(
                    top: 370.0,
                    left: 180.0,
                    child: Text("😴"),
                  ),
                  const Positioned(
                    top: 310.0,
                    left: 50.0,
                    child: Text("😢"),
                  ),
                  const Positioned(
                    top: 180.0,
                    left: 5.0,
                    child: Text("😔"),
                  ),
                  const Positioned(
                    top: 60.0,
                    left: 50.0,
                    child: Text("🤒"),
                  ),
                  const Positioned(
                    top: 0.0,
                    left: 180.0,
                    child: Text("😡"),
                  ),
                  const Positioned(
                    top: 60.0,
                    left: 330.0,
                    child: Text("🤗"),
                  ),
                ],
              ),
              //SizedBox.shrink(),
              (_processState.index > ProcessState.NotTaken.index ? Text('Take a deep breath') : SizedBox.shrink()),
              (_processState.index >= ProcessState.WritingAbout.index ? Text('Write a few words about why you feel so today.') : SizedBox.shrink()),
              (_processState.index >= ProcessState.WritingAbout.index ?
              CupertinoTextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _writeAboutController,
                placeholder: 'About your mind',
              ) : SizedBox.shrink()),
              (_processState.index >= ProcessState.ShowingWord.index ? Text('Word of the Day: ${_wordData.word}') : SizedBox.shrink()),
              (_processState.index >= ProcessState.ShowingWord.index ? Text('Definition:\n${_wordData.meaning}') : SizedBox.shrink()),
              (_processState.index >= ProcessState.OfferingDeed.index ? Text('Good Deed for the day:\n${_deed.content}') : SizedBox.shrink()),
              CupertinoButton(
                onPressed: _enableSubmit ? () => startFlow() :null,
                child: Text('Proceed'),
              ),
            ],
          ),
        ));
  }

  startFlow() async {
    print('inside flow');
    if (_processState == ProcessState.WritingAbout) {
      _wordData = await getNewWord();
    } else if (_processState == ProcessState.ShowingWord) {
      _deed = await getNewDeed();
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
}
