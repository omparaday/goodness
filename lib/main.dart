import 'package:flutter/cupertino.dart';
import 'package:goodness/home.dart';
import 'package:goodness/l10n/Localizations.dart';
import 'package:goodness/profile.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'history.dart';

void main() {
  runApp(new CupertinoApp(localizationsDelegates: const [
    // Add this line
    L10nDelegate(),
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ], supportedLocales: [
    Locale('en', ''),
    Locale('ta', ''),
  ], home: new Main()));
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    print('main initstate');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
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
                  localizationsDelegates: const [
                    // Add this line
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
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
