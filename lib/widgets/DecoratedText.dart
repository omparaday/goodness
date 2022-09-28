import 'package:flutter/cupertino.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(String this._text, {Key? key, TextStyle? this.textStyle})
      : super(key: key);

  final String _text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: const EdgeInsets.all(5.0),
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.opaqueSeparator.withAlpha(100),
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          _text,
          style: textStyle,
        ));
  }
}
