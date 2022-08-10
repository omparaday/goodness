import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget bigCircle = new Container(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [CupertinoColors.white.withOpacity(1), CupertinoColors.white.withOpacity(0)]
          ),
        ),
      ),
      width: 300.0,
      height: 300.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          startAngle: 0,
          //endAngle: math.pi *2,
          colors: const <Color>[
            CupertinoColors.systemPurple, // blue
            CupertinoColors.systemIndigo,
            CupertinoColors.systemBlue,
            CupertinoColors.systemGreen,
            CupertinoColors.systemYellow,
            CupertinoColors.systemOrange,
            CupertinoColors.systemRed,
            CupertinoColors.systemPurple
          ],
          //stops: const <double>[0.0, 0.5],
        ),
      ),

    );

    return new CupertinoApp(
      color: CupertinoColors.black,
      home: new Center(
        child: new Stack(
          children: <Widget>[
            bigCircle,
            new Positioned(
              child: new CircleButton(onTap: () => print("Cool"), iconData: CupertinoIcons.airplane),
              top: 10.0,
              left: 130.0,
            ),
            new Positioned(
              child: new CircleButton(onTap: () => print("Hot"), iconData: CupertinoIcons.alarm_fill),
              top: 120.0,
              left: 10.0,
            ),
            new Positioned(
              child: new CircleButton(onTap: () => print("Warm"), iconData: CupertinoIcons.scissors),
              top: 120.0,
              right: 10.0,
            ),
            new Positioned(
              child: new CircleButton(onTap: () => print("Cold"), iconData: CupertinoIcons.shopping_cart),
              top: 240.0,
              left: 130.0,
            ),
            new Positioned(
              child: new CircleButton(onTap: () => print("Sweet"), iconData: CupertinoIcons.square_favorites_alt),
              top: 120.0,
              left: 130.0,
            ),

          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key? key, required this.onTap, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new GestureDetector(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: CupertinoColors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: CupertinoColors.black,
        ),
      ),

    );
  }
}


//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.1666667,size.height*0.02727273);
    path_0.lineTo(size.width*0.3333333,size.height*0.2545455);
    path_0.lineTo(size.width*0.3333333,size.height*0.6818182);
    path_0.lineTo(size.width*0.1666667,size.height*0.9090909);
    path_0.lineTo(size.width*0.01000000,size.height*0.6818182);
    path_0.lineTo(size.width*0.01000000,size.height*0.2272727);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01666667;
    paint_0_stroke.color=CupertinoColors.systemYellow.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = CupertinoColors.systemYellow.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Add this CustomPaint widget to the Widget Tree


//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.radial(Offset(size.width*0.5000000,size.height*0.5000000),size.width*0.5000000, [Color.fromRGBO(255,255,255,1.0).withOpacity(0),Color.fromRGBO(0,0,255,1.0).withOpacity(1)], [0,1]);
    canvas.drawOval(Rect.fromCenter(center:Offset(size.width*0.4000000,size.height*0.2000000),width:size.width*0.3400000,height:size.height*0.1100000),paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}