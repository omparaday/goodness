import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _x = 180, _y = 180;
  bool enableSubmit = false;
  @override
  Widget build(BuildContext context) {
    Widget bigCircle = Container(
      margin: const EdgeInsets.all(30.0),
      width: 340.0,
      height: 340.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          startAngle: 0,
          colors: <Color>[
            CupertinoColors.systemIndigo,
            CupertinoColors.systemBlue,
            CupertinoColors.systemGreen,
            CupertinoColors.systemYellow,
            CupertinoColors.systemOrange,
            CupertinoColors.systemRed,
            CupertinoColors.systemPurple,
            CupertinoColors.systemIndigo,
          ],
          //stops: const <double>[0.0, 0.5],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [CupertinoColors.white.withOpacity(1), CupertinoColors.white.withOpacity(0)]
          ),
        ),
        child:
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            setState(() {
              _x = details.localPosition.dx;
              _y = details.localPosition.dy;
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Stack(
                children: <Widget>[
                  Positioned(
                    top: _y-15,
                    left: _x-10,
                    child: Text('🛟'),
                  )
                ]
            ),
          ),
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
              child: Text('😊'),
              top: 180.0,
              left: 370.0,
            ),
            new Positioned(
              child: new Text("😃"),
              top: 310.0,
              left: 330.0,
            ),
            new Positioned(
              child: new Text("😴"),
              top: 370.0,
              left: 180.0,
            ),
            new Positioned(
              child: new Text("😢"),
              top: 310.0,
              left: 50.0,
            ),
            new Positioned(
              child: new Text("😔"),
              top: 180.0,
              left: 5.0,
            ),
            new Positioned(
              child: new Text("🤒"),
              top: 60.0,
              left: 50.0,
            ),
            new Positioned(
              child: new Text("😡"),
              top: 0.0,
              left: 180.0,
            ),
            new Positioned(
              child: new Text("🤗"),
              top: 60.0,
              left: 330.0,
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