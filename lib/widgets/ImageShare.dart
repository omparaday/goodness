import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:goodness/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ImageShare extends StatefulWidget {
  final String text;

  const ImageShare(String this.text);

  @override
  ImageShareState createState() => ImageShareState(text);
}

class ImageShareState extends State<ImageShare> {
  String text;

  ImageShareState(String this.text);

  GlobalKey globalKey = GlobalKey();
  late Uint8List pngBytes;
  bool clicked = false;

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 4.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      pngBytes = byteData!.buffer.asUint8List();
      clicked = true;
    });
  }

  Future<void> shareImage() async {
    if (!clicked) {
      await _capturePng();
    }
    final box = context.findRenderObject() as RenderBox?;
    Share.shareXFiles([XFile.fromData(pngBytes, mimeType: 'image/png')], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        RepaintBoundary(
            key: globalKey,
            child: Container(
              width: 300,
              color: Color.fromARGB(255, 250, 224, 190),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Image.asset(
                      'assets/goodness.png',
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'goodness.day',
                      style: TextStyle(
                          fontFamily: GoogleFonts.caveat().fontFamily,
                          color: CupertinoColors.black,
                          fontSize: VERYSMALL_FONTSIZE),
                    )
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(text,
                      style: TextStyle(
                          fontFamily: GoogleFonts.caveat().fontFamily,
                          color: CupertinoColors.black,
                          fontSize: LARGE_FONTSIZE))
                ],
              ),
            )),
        CupertinoButton(
          onPressed: shareImage,
          child: Icon(CupertinoIcons.share),
        )
      ]),
    );
  }
}
