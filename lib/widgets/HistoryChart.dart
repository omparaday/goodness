import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryChart extends StatelessWidget {
  const HistoryChart({
    Key? key,
    required this.chartWidth,
    required this.chartHeight,
    required this.barList,
    required this.rowList,
  }) : super(key: key);

  final double chartWidth;
  final double chartHeight;
  final List<Widget> barList;
  final List<Widget> rowList;

  @override
  Widget build(BuildContext context) {
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
