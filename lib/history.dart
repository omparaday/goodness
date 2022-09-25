import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/dbhelpers/QuoteHelper.dart';
import 'package:goodness/dbhelpers/WordData.dart';
import 'package:goodness/home.dart';
import 'package:goodness/widgets/DecoratedText.dart';
import 'package:goodness/widgets/HistoryChart.dart';
import 'package:goodness/widgets/MoodCircle.dart';
import 'dart:math' as math;

import 'dbhelpers/DeedHelper.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryType historyType;
  late List<Widget> recentData;
  late DateTime chartWeek;
  late DateTime chartMonth;
  late DateTime chartYear;
  Map<String, BarPlotInfo> plotInfoMap = {};
  String chartName = '';
  String chartAverage = '0.0';

  @override
  void initState() {
    super.initState();
    print('history initState');
    historyType = HistoryType.Week;
    recentData = [];
    plotInfoMap = {};
    chartWeek = getFirstDayOfWeek(DateTime.now());
    chartMonth = getFirstDayOfMonth(DateTime.now());
    chartYear = getFirstDayOfYear(DateTime.now());
    fetchRecentHistory();
    fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    print('history build');
    var chartWidth = MediaQuery.of(context).size.width;
    var chartHeight = 300.0;
    Widget chart = HistoryChart(
      chartWidth: chartWidth,
      chartHeight: chartHeight,
      plotList: plotInfoMap,
      historyType: historyType, showHistoryDialog: showHistoryDialog,
    );
    return Container(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Text('History'),
              SizedBox(width: 0, height: 10),
              CupertinoSegmentedControl<HistoryType>(
                groupValue: historyType,
                onValueChanged: (HistoryType value) {
                  historyType = value;
                  fetchChartData();
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
                  Text(chartName),
                  Spacer(),
                  Text('Average Score: $chartAverage')
                ],
              ),
              Row(
                children: <Widget>[
                  CupertinoButton(
                      child: Text('Prev'), onPressed: () => goPrevious()),
                  Spacer(),
                  CupertinoButton(
                      child: Text('Next'), onPressed: () => goNext())
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
    Map<String, dynamic>? pastData = await getRecentData();
    recentData.clear();
    pastData?.forEach((key, value) {
      DailyData dd = value;
      DateTime datetime = DateTime(int.parse(key.substring(0, 4)),
          int.parse(key.substring(5, 7)), int.parse(key.substring(8, 10)));
      recentData.add(GestureDetector(
          onTap: () => showHistoryDialog(dd, datetime),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(200, 153, 204, 255),
                ),
                borderRadius: BorderRadius.all(Radius.circular(4)),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getDisplayDateWithoutYear(datetime)),
                      Spacer(),
                      Text(getEmojiForXy(dd.x, dd.y)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dd.goodness >= 100 ? 'Score: Perfect 💯 ' :'Score: ${dd.goodness}'),
                      Spacer(),
                      Text(dd.wordKey),
                    ],
                  ),
                  dd.about.isNotEmpty ? Text(dd.about) : SizedBox.shrink(),
                ],
              ))));
      //recentData.add(Divider());
    });
    setState(() {
      recentData = recentData;
    });
  }

  void showHistoryDialog(DailyData? dd, DateTime? datetime) async {
    if (dd == null || datetime == null) {
      return;
    }
    WordData wd = await getWordForKey(dd.wordKey);
    Quote quote = await getQuoteForKey(dd.quoteKey);
    String deedStr = 'Not opted for deed';
    if (dd.deedKey != null) {
      Deed deed = await getDeedForKey(dd.deedKey ?? '');
      deedStr = deed.content;
    }
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('${getDisplayDate(datetime)}'),
          content: Column(
            children: [
              MoodCircle(150, 15, 75, 150 / (2 * math.sqrt2),
                  ProcessState.Completed, () => {}, dd.x / 2, dd.y / 2),
              DecoratedText(dd.about),
              DecoratedText('Word: ${wd.word}\n${wd.meaning}'),
              DecoratedText('Quote\n${quote.content}'),
              DecoratedText('Deed for the day\n$deedStr'),
              DecoratedText('Score: ${dd.goodness >=100 ? 'Perfect 💯' : dd.goodness}')
            ],
          )),
    );
  }

  Future<void> fetchChartData() async {
    plotInfoMap = {};
    chartName = '';
    chartAverage = 0.toString();
    switch (historyType) {
      case HistoryType.Week:
        await fetchWeeklyData();
        break;
      case HistoryType.Month:
        await fetchMonthlyData();
        break;
      case HistoryType.Year:
        await fetchYearlyData();
        break;
      case HistoryType.All:
        await fetchAllData();
    }
    setState(() {});
  }

  Future<void> fetchAllData() async {
    DateTime start = getFirstDayOfYear(DateTime(2022));
    DateTime today = DateTime.now();
    bool startFound = false;
    double totalDays = 0, totalScore = 0;
    while (start.year <= today.year) {
      Map<String, dynamic>? yearlyData = await getDataForYear(start);
      Map<String, double>? monthlyData = yearlyData!['monthlyData'];
      Map<String, double>? metaData = yearlyData!['metaData'];
      if (metaData!['Average'] != 0 || startFound) {
        startFound = true;
        int avg = metaData!['Average']?.round() ?? 0;
        plotInfoMap.putIfAbsent((start.year).toString(), () => BarPlotInfo(avg, null, null));
        totalDays += metaData!['totalDays'] ?? 0;
        totalScore += metaData!['totalScore'] ?? 0;
      }
      start = getNextYear(start);
    }
    if (totalDays != 0) {
      chartAverage = (totalScore / totalDays).toStringAsFixed(1);
    }
  }

  Future<void> fetchYearlyData() async {
    Map<String, dynamic>? yearlyData = await getDataForYear(chartYear);
    Map<String, double>? monthlyData = yearlyData!['monthlyData'];
    Map<String, double>? metaData = yearlyData!['metaData'];
    chartName = chartYear.year.toString();
    if (yearlyData != null) {
      chartAverage = metaData!['Average']?.toStringAsFixed(1) ?? '0.0';
      monthlyData?.forEach((key, value) {
        int intval = value.round();
        plotInfoMap.putIfAbsent(key, () => BarPlotInfo(intval, null, null));
      });
    }
  }

  Future<void> fetchMonthlyData() async {
    DailyData dd;
    Map<String, dynamic>? chartData =
        await getDataForMonth(getDateKeyFormat(chartMonth));
    DateTime trans = chartMonth;
    chartName = getMonthName(chartMonth);
    chartAverage = '0.0';
    int count = 0, sum = 0;
    if (chartData != null) {
      while (trans.month == chartMonth.month) {
        var transKey = getDateKeyFormat(trans);
        var json = chartData[transKey];
        if (json != null) {
          dd = DailyData.fromJson(json);
          plotInfoMap.putIfAbsent(transKey, () => BarPlotInfo(dd.goodness, dd, trans));
          count++;
          sum = sum + dd.goodness;
        } else {
          plotInfoMap.putIfAbsent(transKey, () => BarPlotInfo(0, null, null));
        }
        trans = trans.add(Duration(days: 1));
      }
    }
    if (count != 0) {
      chartAverage = (sum / count).toStringAsFixed(1);
    }
  }

  Future<void> fetchWeeklyData() async {
    DailyData dd;
    Map<String, dynamic>? chartData = await getDataForWeek(chartWeek);
    DateTime movingDate = chartWeek;
    chartName = 'Week ${getDateKeyFormat(chartWeek)}';
    chartAverage = '0.0';
    int count = 0, sum = 0;
    if (chartData != null) {
      for (int i = 0; i < 7; i++) {
        var movingDateKey = getDateKeyFormat(movingDate);
        var json = chartData[movingDateKey];
        if (json != null) {
          dd = DailyData.fromJson(json);
          plotInfoMap.putIfAbsent(getDayOfWeek(movingDate), () => BarPlotInfo(dd.goodness, dd, movingDate));
          count++;
          sum = sum + dd.goodness;
        } else {
          plotInfoMap.putIfAbsent(getDayOfWeek(movingDate), () => BarPlotInfo(0, null, null));
        }
        movingDate = movingDate.add(Duration(days: 1));
      }
    }
    if (count != 0) {
      chartAverage = (sum / count).toStringAsFixed(1);
    }
  }

  goPrevious() {
    switch (historyType) {
      case HistoryType.Week:
        chartWeek = getPreviousWeek(chartWeek);
        break;
      case HistoryType.Month:
        chartMonth = getPreviousMonth(chartMonth);
        break;
      case HistoryType.Year:
        chartYear = getPreviousYear(chartYear);
        break;
      case HistoryType.All:
    }
    fetchChartData();
  }

  goNext() {
    switch (historyType) {
      case HistoryType.Week:
        chartWeek = getNextWeek(chartWeek);
        break;
      case HistoryType.Month:
        chartMonth = getNextMonth(chartMonth);
        break;
      case HistoryType.Year:
        chartYear = getNextYear(chartYear);
        break;
      case HistoryType.All:
    }
    fetchChartData();
  }
}
