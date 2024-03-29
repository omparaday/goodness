import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/dbhelpers/QuestionHelper.dart';
import 'package:goodness/dbhelpers/QuoteHelper.dart';
import 'package:goodness/home.dart';
import 'package:goodness/main.dart';
import 'package:goodness/widgets/DecoratedText.dart';
import 'package:goodness/widgets/DecoratedWidget.dart';
import 'package:goodness/widgets/HistoryChart.dart';
import 'package:goodness/widgets/ImageShare.dart';
import 'package:goodness/widgets/MoodCircle.dart';
import 'package:goodness/widgets/MoodSummaryBars.dart';
import 'package:goodness/widgets/RounderSegmentControl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import 'dbhelpers/DeedHelper.dart';
import 'dbhelpers/Utils.dart';
import 'l10n/Localizations.dart';

enum ChartType { MoodSummary, GoodnessScoreAverage }

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryType historyType;
  late ChartType chartType;
  late List<Widget> recentData;
  late DateTime chartWeek;
  late DateTime chartMonth;
  late DateTime chartYear;
  Map<String, BarPlotInfo> plotInfoMap = {};
  Map<String, double> moodPlotInfo = {};
  late double takenCount = 0;
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
    chartType = ChartType.MoodSummary;
    recentData = [];
    plotInfoMap = {};
    moodPlotInfo = {};
    takenCount = 0;
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
    var chartHeight = max(chartType == ChartType.GoodnessScoreAverage ? 180.0 : 312.0, MediaQuery.of(context).size.height / 3);
    Widget chart = HistoryChart(
      chartWidth: chartWidth,
      chartHeight: chartHeight,
      plotList: plotInfoMap,
      historyType: historyType,
      showHistoryDialog: showHistoryDialog,
    );
    Widget moodBars = MoodSummaryBars(
      chartWidth: chartWidth,
      chartHeight: chartHeight,
      plotList: moodPlotInfo,
      totalCount: takenCount,
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
              RoundedSegmentControl<HistoryType>(
                groupValue: historyType,
                onValueChanged: (HistoryType value) {
                  historyType = value;
                  fetchChartData();
                },
                children: <HistoryType, String>{
                  HistoryType.Week: L10n.of(context).resource('week'),
                  HistoryType.Month: L10n.of(context).resource('month'),
                  HistoryType.Year: L10n.of(context).resource('year'),
                  HistoryType.All: L10n.of(context).resource('all'),
                },
              ),
              SizedBox(width: 0, height: 10),
              Row(
                children: <Widget>[
                  Flexible(fit: FlexFit.tight, child: Text(chartName)),
                  Spacer(),
                  chartType == ChartType.GoodnessScoreAverage
                      ? Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            sprintf(L10n.of(context).resource('averageScore'),
                                [chartAverage]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                      : SizedBox.shrink()
                ],
              ),
              SizedBox(width: 0, height: 10),
              CupertinoSegmentedControl<ChartType>(
                groupValue: chartType,
                onValueChanged: (ChartType value) {
                  chartType = value;
                  fetchChartData();
                },
                children: <ChartType, Widget>{
                  ChartType.MoodSummary:
                  Text(L10n.of(context).resource('moodSummary')),
                  ChartType.GoodnessScoreAverage:
                  Text(L10n.of(context).resource('goodnessScoreAverage')),
                },
              ),
              SizedBox(width: 0, height: 10),
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
              chartType == ChartType.GoodnessScoreAverage ? chart : moodBars,
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
                      Text(dd.goodness >= 100
                          ? L10n.of(context).resource('scorePerfect100')
                          : sprintf(L10n.of(context).resource('scoreWithVal'),
                              [dd.goodness])),
                      Spacer(),
                      Text(
                        getEmojiForXy(getValueFromPer3centage(dd.x),
                            getValueFromPer3centage(dd.y), radius),
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
              MoodCircle(
                  diameter / 2,
                  inset,
                  radius / 2,
                  sideOfSquare / 2,
                  ProcessState.Completed,
                  () => {},
                  getValueFromPer3centage(dd.x) / 2,
                  getValueFromPer3centage(dd.y) / 2),
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
              DecoratedWidget(
                  Column(children: <Widget>[
                    Row(children: <Widget>[
                      Text(L10n.of(context).resource('quote')),
                      Spacer(),
                      CupertinoButton(
                          child: Text(L10n.of(context).resource('share')),
                          onPressed: () => {showSharePopup(quote.content)})
                    ]),
                    Text(sprintf(L10n.of(context).resource('quoteWithContent'),
                        [quote.content]))
                  ]),
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
    moodPlotInfo = {
      '🤗': 0,
      '😊': 0,
      '😃': 0,
      '😴': 0,
      '😡': 0,
      '🤒': 0,
      '😢': 0,
      '😔': 0
    };
    takenCount = 0;
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
      Map<String, double>? monthlyData = yearlyData![KEY_MONTHLY_DATA];
      Map<String, double>? metaData = yearlyData![KEY_METADATA];
      if (metaData![KEY_AVERAGE] != 0 || startFound) {
        startFound = true;
        int avg = metaData![KEY_AVERAGE]?.round() ?? 0;
        plotInfoMap.putIfAbsent(
            (start.year).toString(), () => BarPlotInfo(avg, null, null));
        totalDays += metaData![KEY_TOTAL_DAYS] ?? 0;
        totalScore += metaData![KEY_TOTAL_SCORE] ?? 0;
      }
      takenCount = takenCount + (metaData![KEY_TOTAL_DAYS] ?? 0);
      moodPlotInfo.update('🤗', (value) => value + (metaData!['🤗'] ?? 0));
      moodPlotInfo.update('😊', (value) => value + (metaData!['😊'] ?? 0));
      moodPlotInfo.update('😃', (value) => value + (metaData!['😃'] ?? 0));
      moodPlotInfo.update('😴', (value) => value + (metaData!['😴'] ?? 0));
      moodPlotInfo.update('😡', (value) => value + (metaData!['😡'] ?? 0));
      moodPlotInfo.update('🤒', (value) => value + (metaData!['🤒'] ?? 0));
      moodPlotInfo.update('😢', (value) => value + (metaData!['😢'] ?? 0));
      moodPlotInfo.update('😔', (value) => value + (metaData!['😔'] ?? 0));
      start = getNextYear(start);
    }
    if (totalDays != 0) {
      chartAverage = (totalScore / totalDays).toStringAsFixed(1);
    }
  }

  Future<void> fetchYearlyData() async {
    Map<String, dynamic>? yearlyData = await getDataForYear(chartYear);
    Map<String, double>? monthlyData = yearlyData![KEY_MONTHLY_DATA];
    Map<String, double>? metaData = yearlyData![KEY_METADATA];
    chartName = chartYear.year.toString();
    if (yearlyData != null) {
      chartAverage = metaData![KEY_AVERAGE]?.toStringAsFixed(1) ?? '0.0';
      monthlyData?.forEach((key, value) {
        int intval = value.round();
        plotInfoMap.putIfAbsent(key, () => BarPlotInfo(intval, null, null));
      });
      takenCount = metaData![KEY_TOTAL_DAYS] ?? 0;
      moodPlotInfo.update('🤗', (value) => metaData!['🤗'] ?? 0);
      moodPlotInfo.update('😊', (value) => metaData!['😊'] ?? 0);
      moodPlotInfo.update('😃', (value) => metaData!['😃'] ?? 0);
      moodPlotInfo.update('😴', (value) => metaData!['😴'] ?? 0);
      moodPlotInfo.update('😡', (value) => metaData!['😡'] ?? 0);
      moodPlotInfo.update('🤒', (value) => metaData!['🤒'] ?? 0);
      moodPlotInfo.update('😢', (value) => metaData!['😢'] ?? 0);
      moodPlotInfo.update('😔', (value) => metaData!['😔'] ?? 0);
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
          String mood = getEmojiForXy(getValueFromPer3centage(dd.x),
              getValueFromPer3centage(dd.y), radius);
          moodPlotInfo.update(mood, (value) => ++value);
          takenCount++;
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
          String mood = getEmojiForXy(getValueFromPer3centage(dd.x),
              getValueFromPer3centage(dd.y), radius);
          moodPlotInfo.update(mood, (value) => ++value);
          count++;
          takenCount++;
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

  void showSharePopup(String quote) {
    if (!kIsWeb) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Dialog(
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              child: ImageShare(quote)));
    } else {
      Share.share(quote);
    }
  }
}
