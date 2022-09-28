import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodness/dbhelpers/DailyData.dart';

enum HistoryType { Week, Month, Year, All }

class HistoryChart extends StatelessWidget {
  HistoryChart(
      {Key? key,
      required this.chartWidth,
      required this.chartHeight,
      required this.plotList,
      required this.historyType,
      required this.showHistoryDialog})
      : super(key: key);

  final double chartWidth;
  final double chartHeight;
  late List<Widget> barList;
  late List<Widget> rowList;
  final Map<String, BarPlotInfo> plotList;
  final HistoryType historyType;
  final Function showHistoryDialog;

  @override
  Widget build(BuildContext context) {
    final Size textHeight = (TextPainter(
            text: TextSpan(text: 'S'),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;
    barList = [];
    rowList = [];
    plotList.forEach((barName, barPlotInfo) {
      int barValue = barPlotInfo.barValue;
      if (historyType == HistoryType.Month) {
        rowList.add(Text(''));
      } else if (historyType == HistoryType.All) {
        rowList.add(Text(barName.substring(2)));
      } else {
        rowList.add(Text(barName.substring(0, 1)));
      }
      barList.add(Tooltip(
          message: '$barName: $barValue',
          child: GestureDetector(
              onTap: () => showHistoryDialog(
                  barPlotInfo.dailyData, barPlotInfo.dateTime),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 153, 102),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                height:
                    barValue * (chartHeight - (textHeight.height + 10)) / 100,
                width: historyType == HistoryType.Month ? 8 : 12,
              ))));
    });
    return Container(
      width: chartWidth,
      height: chartHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 0,
                  fit: FlexFit.tight,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('100'),
                            Text('75'),
                            Text('50'),
                            Text('25'),
                            Text('0'),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        fit: FlexFit.tight,
                        child: Text(''),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Divider(),
                                Divider(),
                                Divider(),
                                Divider(),
                                Divider(),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(child: Container()),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: barList,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 0,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: rowList,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.5,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: CupertinoColors.inactiveGray),
      ),
    );
  }
}

class BarPlotInfo {
  int barValue;
  DailyData? dailyData;
  DateTime? dateTime;

  BarPlotInfo(this.barValue, this.dailyData, this.dateTime);
}
