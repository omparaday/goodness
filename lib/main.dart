import 'package:flutter/cupertino.dart';
import 'package:goodness/home.dart';
import 'package:goodness/l10n/Localizations.dart';
import 'package:goodness/profile.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history.dart';

const double FONTSIZE = 18;
const double MEDIUM_FONTSIZE = 20;
const double LARGE_FONTSIZE = 22;

void main() {
  runApp(new CupertinoApp(
      theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        color: CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.black,
          darkColor: CupertinoColors.white,
        ),
      ))),
      localizationsDelegates: const [
        L10nDelegate(),
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ta', ''),
      ],
      home: new Main()));
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  late int _currentIndex;
  bool _showWelcome = false;
  int _welcomeIndex = 1;

  @override
  void initState() {
    _currentIndex = 0;
    checkAndShowWelcomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: CupertinoDynamicColor.withBrightness(
              color: Color.fromARGB(0, 0, 0, 0),
              darkColor: Color.fromARGB(0, 0, 0, 0),
            ),
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: L10n.of(context).resource('home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chart_bar),
                label: L10n.of(context).resource('history'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                label: L10n.of(context).resource('profile'),
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SafeArea(
                  child: CupertinoApp(
                    theme: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                            textStyle: TextStyle(
                      fontSize: FONTSIZE,
                      fontFamily: GoogleFonts.nunito().fontFamily,
                      color: CupertinoDynamicColor.withBrightness(
                        color: CupertinoColors.black,
                        darkColor: CupertinoColors.white,
                      ),
                    ))),
                    localizationsDelegates: const [
                      L10nDelegate(),
                      GlobalCupertinoLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: [
                      Locale('en', ''),
                      Locale('ta', ''),
                    ],
                    home: CupertinoPageScaffold(
                      resizeToAvoidBottomInset: false,
                      child: IndexedStack(
                        index: _currentIndex,
                        children: [
                          HomePage(),
                          HistoryPage(),
                          ProfilePage(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      _showWelcome
          ? SizedBox.expand(
              child: CupertinoApp(
                  theme: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                          textStyle: TextStyle(
                    fontFamily: GoogleFonts.nunito().fontFamily,
                    color: CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.black,
                      darkColor: CupertinoColors.white,
                    ),
                  ))),
                  home: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20.0, bottom: 100.0, right: 20.0),
                      decoration: BoxDecoration(
                          color: CupertinoDynamicColor.withBrightness(
                        color: Color.fromARGB(100, 60, 60, 60),
                        darkColor: Color.fromARGB(100, 255, 255, 255),
                      )),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Spacer(),
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20.0,
                                    bottom: 20.0,
                                    right: 20.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: CupertinoDynamicColor.withBrightness(
                                      color: Color.fromARGB(230, 60, 60, 60),
                                      darkColor:
                                          Color.fromARGB(230, 255, 255, 255),
                                    )),
                                child: Column(children: <Widget>[
                                  Row(children: <Widget>[
                                    CupertinoButton(
                                        child: Text(
                                          L10n.of(context).resource('prev'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: _welcomeIndex == 1
                                            ? null
                                            : previousWelcomeScreen),
                                    Spacer(),
                                    CupertinoButton(
                                        child: Text(
                                          _welcomeIndex == 5
                                              ? L10n.of(context)
                                                  .resource('close')
                                              : L10n.of(context)
                                                  .resource('next'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: nextWelcomeScreen)
                                  ]),
                                  getWelcomeText(),
                                ])),
                            (_welcomeIndex <= 4 && _welcomeIndex >= 2)
                                ? Container(child: getArrowWidget())
                                : SizedBox.shrink()
                          ]))))
          : SizedBox.shrink()
    ]);
  }

  Widget getArrowWidget() {
    switch (_welcomeIndex) {
      case 2:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(CupertinoIcons.arrow_down),
              SizedBox(
                width: 60,
                height: 10,
              ),
              SizedBox(
                width: 60,
                height: 10,
              )
            ]);
      case 3:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 60,
                height: 10,
              ),
              Icon(CupertinoIcons.arrow_down),
              SizedBox(
                width: 60,
                height: 10,
              )
            ]);
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: 60,
            height: 10,
          ),
          SizedBox(
            width: 60,
            height: 10,
          ),
          Icon(CupertinoIcons.arrow_down)
        ]);
  }

  Text getWelcomeText() {
    var textStyle = TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: CupertinoColors.white);
    switch (_welcomeIndex) {
      case 1:
        return Text(
          L10n.of(context).resource('welcome'),
          style: textStyle,
        );
      case 2:
        return Text(L10n.of(context).resource('homeWelcome'), style: textStyle);
      case 3:
        return Text(L10n.of(context).resource('historyWelcome'),
            style: textStyle);
      case 4:
        return Text(L10n.of(context).resource('profileWelcome'),
            style: textStyle);
    }
    return Text(L10n.of(context).resource('getStarted'), style: textStyle);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void nextWelcomeScreen() {
    if (_welcomeIndex == 5) {
      finishWelcome();
    } else {
      setState(() {
        _welcomeIndex++;
        if (_welcomeIndex < 5 && _welcomeIndex > 1) {
          _currentIndex = _welcomeIndex - 2;
        } else {
          _currentIndex = 0;
        }
      });
    }
  }

  void previousWelcomeScreen() {
    setState(() {
      _welcomeIndex--;
      if (_welcomeIndex < 5 && _welcomeIndex > 1) {
        _currentIndex = _welcomeIndex - 2;
      } else {
        _currentIndex = 0;
      }
    });
  }

  Future<void> checkAndShowWelcomeScreen() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showWelcome = prefs.getBool('SHOW_WELCOME') ?? true;
    });
  }

  Future<void> finishWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('SHOW_WELCOME', false);
      _showWelcome = false;
      _currentIndex = 0;
    });
  }
}
