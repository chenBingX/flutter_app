import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPainterPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomPainterPage2();
  }
}

class _CustomPainterPage2 extends State<CustomPainterPage2>
    with TickerProviderStateMixin {
  ui.Image background;
  ui.Image maliao;
  ui.Size deviceSize;
  Point position = Point(0, 0);
  double ratio = ui.window.devicePixelRatio;

  @override
  void initState() {
    super.initState();
    deviceSize = ui.window.physicalSize / ratio;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          CustomPaint(
            isComplex: true,
            willChange: true,
            size: Size(deviceSize.width, deviceSize.height),
            painter: MyPainter(),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.bottom,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    Paint paint = Paint()
          ..isAntiAlias = true
          ..color = Colors.orangeAccent
          ..strokeWidth = 5
          ..style = PaintingStyle.fill
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
//      ..strokeJoin = StrokeJoin.round
//      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50)
//      ..invertColors = false
//      ..blendMode = BlendMode.color
//      ..shader = ui.Gradient.linear(
//          Offset(0, 0), Offset(100, 100), [Colors.red, Colors.blueAccent])
        ;

//    canvas.drawLine(Offset(50, 100), Offset(250, 250), paint);

//    canvas.drawPoints(
//        ui.PointMode.polygon,
//        [Offset(200, 200), Offset(250, 250), Offset(50, 200), Offset(100, 250)],
//        paint);
//    Path path = Path();
//    path.moveTo(100, 100);
//    path.lineTo(200, 200);
//    path.lineTo(250, 200);
//    path.lineTo(200, 250);
//    path.close();
//    canvas.drawPath(path, paint);
//    Rect rect1 = Rect.fromCircle(
//        center: Offset(size.width / 2, size.height / 2), radius: 140);
//    Rect rect2 = Rect.fromCircle(
//        center: Offset(size.width / 2, size.height / 2), radius: 160);
//    RRect rRect1 = RRect.fromRectAndRadius(rect1, Radius.circular(20));
//    RRect rRect2 = RRect.fromRectAndRadius(rect2, Radius.circular(20));
//    canvas.drawRRect(rRect, paint);

//    canvas.drawDRRect(rRect2, rRect1, paint);

//    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
//    Rect rect = Rect.fromLTRB(size.width / 2 - 100, size.height / 2 - 50,
//        size.width / 2 + 100, size.height / 2 + 50);
//    canvas.drawOval(rect, paint);
//    paint..color = Colors.blueAccent;
//    paint..style = PaintingStyle.stroke;
//    canvas.drawRect(rect, paint);

    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: 140);
//    canvas.drawArc(rect, 0, math.pi * 2, true, paint);

//    Path path = Path()..addRect(rect.translate(20, 0));
//    canvas.drawShadow(path, Colors.amberAccent, 20, true);

    canvas.drawRect(rect, paint);

    canvas.drawColor(Colors.redAccent, BlendMode.color);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ImageLoader {
  static AssetBundle getAssetBundle() => (rootBundle != null)
      ? rootBundle
      : new NetworkAssetBundle(new Uri.directory(Uri.base.origin));

  static Future<ui.Image> load(String url) async {
    ImageStream stream = AssetImage(url, bundle: getAssetBundle())
        .resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    }

    stream.addListener(listener);
    return completer.future;
  }
}
