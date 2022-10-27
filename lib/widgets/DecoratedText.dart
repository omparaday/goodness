import 'package:flutter/cupertino.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(String this._text,
      {Key? key, TextStyle? this.textStyle, Color? this.backgroundColor})
      : super(key: key);

  final String _text;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: PhysicalModel(
            color: CupertinoDynamicColor.resolve(
                backgroundColor ??
                    CupertinoDynamicColor.withBrightness(
                        color: Color.fromARGB(125, 230, 230, 230),
                        darkColor: Color.fromARGB(125, 70, 70, 70)),
                context),
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
                padding: const EdgeInsets.all(5.0),
                width: mediaQuery.size.width,
                child: Text(
                  _text,
                  style: textStyle,
                ))));
  }
}
