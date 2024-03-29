import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/main.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late List<Widget> barNameList;
  final Map<String, BarPlotInfo> plotList;
  final HistoryType historyType;
  final Function showHistoryDialog;

  @override
  Widget build(BuildContext context) {
    final Size textHeight = (TextPainter(
            text: TextSpan(text: 'h ', style: TextStyle(fontSize: FONTSIZE)),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;
    barList = [];
    barNameList = [];
    plotList.forEach((barName, barPlotInfo) {
      int barValue = barPlotInfo.barValue;
      if (historyType == HistoryType.Month) {
        barNameList.add(Text('', style: TextStyle(fontFamily: GoogleFonts.courierPrime().fontFamily),));
      } else if (historyType == HistoryType.All) {
        barNameList.add(Text(barName.substring(2), style: TextStyle(fontFamily: GoogleFonts.inconsolata().fontFamily),));
      } else {
        barNameList.add(Text(barName.substring(0, 1), style: TextStyle(fontFamily: GoogleFonts.inconsolata().fontFamily),));
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
                    barValue * (chartHeight-textHeight.height) / 100,
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
                            Text('100', style: TextStyle(fontSize: VERYSMALL_FONTSIZE),),
                            Text('75', style: TextStyle(fontSize: VERYSMALL_FONTSIZE)),
                            Text('50', style: TextStyle(fontSize: VERYSMALL_FONTSIZE)),
                            Text('25', style: TextStyle(fontSize: VERYSMALL_FONTSIZE)),
                            Text('0', style: TextStyle(fontSize: VERYSMALL_FONTSIZE)),
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
                            children: barNameList,
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
