import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/widgets/HistoryChart.dart';

import 'dbhelpers/DeedHelper.dart';

enum HistoryType { Week, Month, Year, All }

const List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
const List<String> months = [
  'J',
  'F',
  'M',
  'A',
  'M',
  'J',
  'J',
  'A',
  'S',
  'O',
  'N',
  'D'
];
const List<int> monthData = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80];
const List<int> weekData = [3, 25, 75, 1, 100, 50, 0];

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryType historyType;
  late List<Widget> recentData;

  @override
  void initState() {
    super.initState();
    print('init state');
    historyType = HistoryType.Week;
    recentData = [];
    fetchRecentHistory();
  }

  @override
  Widget build(BuildContext context) {
    var chartWidth = MediaQuery.of(context).size.width;
    var chartHeight = 300.0;
    final Size textHeight = (TextPainter(
            text: TextSpan(text: 'S'),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    final List<Widget> rowList = [];
    /*for (String data in weekDays) {
      rowList.add(Text(data));
    }*/
    for (int i = 1; i <= 31; i++) {
      if (i % 2 == 1) {
        rowList.add(Text('$i'));
      }
    }

    final List<Widget> barList = [];
    /*for (int data in weekData) {
      barList.add(Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBlue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
        ),
        ),
        height: data*(chartHeight-(textHeight.height+3))/100,
        width: 10,
      ));
    }*/
    for (int i = 1; i <= 31; i++) {
      barList.add(Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        height: 100,
        width: 5,
      ));
    }
    Widget chart = HistoryChart(
        chartWidth: chartWidth,
        chartHeight: chartHeight,
        barList: barList,
        rowList: rowList);
    return CupertinoApp(
      home: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Text('History'),
              SizedBox(width: 0, height: 10),
              CupertinoSegmentedControl<HistoryType>(
                groupValue: historyType,
                onValueChanged: (HistoryType value) {
                  print('value changed');
                  setState(() {
                    print(value);
                    historyType = value;
                  });
                },
                children: const <HistoryType, Widget>{
                  HistoryType.Week: Text('Week'),
                  HistoryType.Month: Text('Month'),
                  HistoryType.Year: Text('Year'),
                  HistoryType.All: Text('All'),
                },
              ),
              SizedBox(width: 0, height: 10),
              Row(
                children: <Widget>[
                  CupertinoButton(child: Text('Prev'), onPressed: () => {}),
                  Spacer(),
                  CupertinoButton(child: Text('Next'), onPressed: () => {})
                ],
              ),
              SizedBox(width: 0, height: 10),
              chart,
              SizedBox(width: 0, height: 10),
              Text('Recent Submissions'),
              SizedBox(width: 0, height: 10),
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: recentData,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchRecentHistory() async {
    print('fetch recent history');
    Map<String, dynamic>? pastData = await getRecentData();
    print('length ${pastData?.length}');
    DailyData dd;
    pastData?.forEach((key, value) async {
      dd = value;
      String deedStr = 'Not opted for deed';
      if (dd.deedKey != null) {
        Deed deed = await getDeedForKey(dd.deedKey ?? '');
        deedStr = deed.content;
      }
      recentData.add(Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(key),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Score: ${dd.goodness}'),
              Spacer(),
              Text(dd.wordKey),
            ],
          ),
          Text(deedStr)
        ],
      )));
      recentData.add(Divider());
    });
    setState(() {
      recentData = recentData;
    });
  }
}
