import 'package:flutter/cupertino.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(String this._text, {Key? key}) : super(key: key);

  final String _text;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.opaqueSeparator,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
        child: Text(_text));
  }
}
