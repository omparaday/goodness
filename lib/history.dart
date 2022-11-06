import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/dbhelpers/QuestionHelper.dart';
import 'package:goodness/dbhelpers/QuoteHelper.dart';
import 'package:goodness/home.dart';
import 'package:goodness/main.dart';
import 'package:goodness/widgets/DecoratedText.dart';
import 'package:goodness/widgets/DecoratedWidget.dart';
import 'package:goodness/widgets/HistoryChart.dart';
import 'package:goodness/widgets/MoodCircle.dart';
import 'package:sprintf/sprintf.dart';

import 'dbhelpers/DeedHelper.dart';
import 'l10n/Localizations.dart';

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

  void dataChangeCallback() {
    fetchChartData();
    fetchRecentHistory();
  }

  @override
  void initState() {
    super.initState();
    historyType = HistoryType.Week;
    recentData = [];
    plotInfoMap = {};
    chartWeek = getFirstDayOfWeek(DateTime.now());
    chartMonth = getFirstDayOfMonth(DateTime.now());
    chartYear = getFirstDayOfYear(DateTime.now());
    registerWriteCallback(dataChangeCallback);
    fetchRecentHistory();
    fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    var chartWidth = MediaQuery.of(context).size.width;
    var chartHeight = max(180.0, MediaQuery.of(context).size.height / 3);
    Widget chart = HistoryChart(
      chartWidth: chartWidth,
      chartHeight: chartHeight,
      plotList: plotInfoMap,
      historyType: historyType,
      showHistoryDialog: showHistoryDialog,
    );
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Text(
                L10n.of(context).resource('history'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 0, height: 10),
              CupertinoSegmentedControl<HistoryType>(
                groupValue: historyType,
                onValueChanged: (HistoryType value) {
                  historyType = value;
                  fetchChartData();
                },
                children: <HistoryType, Widget>{
                  HistoryType.Week: Text(L10n.of(context).resource('week')),
                  HistoryType.Month: Text(L10n.of(context).resource('month')),
                  HistoryType.Year: Text(L10n.of(context).resource('year')),
                  HistoryType.All: Text(L10n.of(context).resource('all')),
                },
              ),
              SizedBox(width: 0, height: 10),
              Row(
                children: <Widget>[
                  Flexible(fit: FlexFit.tight, child: Text(chartName)),
                  Spacer(),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        sprintf(L10n.of(context).resource('averageScore'),
                            [chartAverage]),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Row(
                children: <Widget>[
                  CupertinoButton(
                      child: Text(
                        L10n.of(context).resource('prev'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => goPrevious()),
                  Spacer(),
                  CupertinoButton(
                      child: Text(
                        L10n.of(context).resource('next'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => goNext())
                ],
              ),
              SizedBox(width: 0, height: 10),
              chart,
              SizedBox(width: 0, height: 10),
              Text(
                L10n.of(context).resource('recentSubmissions'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
          behavior: HitTestBehavior.translucent,
          onTap: () => showHistoryDialog(dd, datetime),
          child: DecoratedWidget(Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getDisplayDateWithoutYear(datetime)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          dd.goodness >= 100
                              ? L10n.of(context).resource('scorePerfect100')
                              : sprintf(
                                  L10n.of(context).resource('scoreWithVal'),
                                  [dd.goodness]),
                          style: TextStyle(
                              fontSize: MEDIUM_FONTSIZE,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                        getEmojiForXy(dd.x, dd.y, radius),
                        style: TextStyle(fontSize: LARGE_FONTSIZE),
                      ),
                    ],
                  ),
                  dd.about.isNotEmpty
                      ? Text(dd.about,
                          style: TextStyle(fontSize: MEDIUM_FONTSIZE))
                      : SizedBox.shrink(),
                ],
              )))));
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
    Question? question = dd.questionKey != null
        ? await getQuestionForKey(dd.questionKey ?? '')
        : null;
    Quote quote = await getQuoteForKey(dd.quoteKey);
    String deedStr = L10n.of(context).resource('notOptedForDeed');
    if (dd.deedKey != null) {
      Deed deed = await getDeedForKey(dd.deedKey ?? '');
      deedStr = deed.content;
    }
    Color backgroundColor = CupertinoDynamicColor.withBrightness(
        color: Color.fromARGB(125, 215, 215, 215),
        darkColor: Color.fromARGB(125, 50, 50, 50));
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('${getDisplayDate(datetime)}'),
          content: Column(
            children: [
              MoodCircle(diameter / 2, inset, radius / 2, sideOfSquare / 2,
                  ProcessState.Completed, () => {}, dd.x / 2, dd.y / 2),
              DecoratedText(
                dd.about.isEmpty
                    ? L10n.of(context).resource('didNotWrite')
                    : dd.about,
                backgroundColor: backgroundColor,
              ),
              dd.questionKey != null
                  ? DecoratedText(
                      sprintf('%s\n%s', [
                        question?.content,
                        dd.answer!.isEmpty
                            ? L10n.of(context).resource('didNotWrite')
                            : dd.answer
                      ]),
                      backgroundColor: backgroundColor)
                  : SizedBox.shrink(),
              DecoratedText(
                  sprintf(
                      L10n.of(context).resource('deedForTheDay'), [deedStr]),
                  backgroundColor: backgroundColor),
              DecoratedText(
                  sprintf(L10n.of(context).resource('quoteWithContent'),
                      [quote.content]),
                  backgroundColor: backgroundColor),
              DecoratedText(
                sprintf(
                    L10n.of(context).resource('scoreWithVal'), [dd.goodness]),
                backgroundColor: backgroundColor,
                textStyle: TextStyle(
                    fontSize: MEDIUM_FONTSIZE, fontWeight: FontWeight.bold),
              )
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
        plotInfoMap.putIfAbsent(
            (start.year).toString(), () => BarPlotInfo(avg, null, null));
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
          plotInfoMap.putIfAbsent(
              transKey, () => BarPlotInfo(dd.goodness, dd, trans));
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
    chartName = sprintf(L10n.of(context).resource('weekWithStart'),
        [getDisplayDateWithoutDoW(chartWeek)]);
    chartAverage = '0.0';
    int count = 0, sum = 0;
    if (chartData != null) {
      for (int i = 0; i < 7; i++) {
        var movingDateKey = getDateKeyFormat(movingDate);
        var json = chartData[movingDateKey];
        if (json != null) {
          dd = DailyData.fromJson(json);
          plotInfoMap.putIfAbsent(getDayOfWeek(movingDate),
              () => BarPlotInfo(dd.goodness, dd, movingDate));
          count++;
          sum = sum + dd.goodness;
        } else {
          plotInfoMap.putIfAbsent(
              getDayOfWeek(movingDate), () => BarPlotInfo(0, null, null));
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
