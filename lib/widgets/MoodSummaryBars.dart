import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodness/main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MoodCircle.dart';

class MoodSummaryBars extends StatelessWidget {
  MoodSummaryBars(
      {Key? key,
      required this.chartWidth,
      required this.chartHeight,
      required this.plotList,
      required this.totalCount})
      : super(key: key);

  final double chartWidth;
  final double chartHeight;
  late List<Widget> barList;
  final Map<String, double> plotList;
  final double totalCount;

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
    plotList.forEach((barName, barPlotInfo) {
      double barValue = barPlotInfo;
      double percentage = barValue * 100/totalCount;
      barList.add(Tooltip(
          message: '${getMoodNameForEmoji(barName, context)}: ${barValue.truncate()}/${totalCount.truncate()}',
          child: GestureDetector(
              child: Row(children: <Widget>[
            Text(
              barName,
              style:
                  TextStyle(fontFamily: GoogleFonts.inconsolata().fontFamily),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 153, 102),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              width: totalCount != 0
                  ? barValue * (chartWidth) * 0.7 / totalCount
                  : 0,
              height: 12,
            ),
            barValue != 0
                ? Text(
                    '${percentage.truncate()}% (${barValue.truncate()}/${totalCount.truncate()})',
              style: TextStyle(fontSize: VERYSMALL_FONTSIZE),
                  )
                : SizedBox.shrink(),
          ]))));
    });
    return Container(
      width: chartWidth,
      height: chartHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: barList,
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
