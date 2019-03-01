import 'package:flutter/material.dart';

class AnimPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimPage();
}

class _AnimPage extends State<AnimPage> with TickerProviderStateMixin {
  var w = 100.0;
  var h = 100.0;
  var x = 0.0;
  var y = 0.0;
  var opacity = 1.0;
  var xAngle = 0.0;
  var yAngle = 0.0;
  var zAngle = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Anim Demo'),
      ),
      body: _build(context),
    );
  }

  _build(context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 500,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
            child: Transform(
              origin: Offset(w / 2, h / 2),
              transform: Matrix4.identity()
                ..rotateX(xAngle)
                ..rotateY(yAngle)
                ..rotateZ(zAngle),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: w,
                  height: h,
                  margin: EdgeInsets.only(left: x, top: y),
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(left: 6, right: 3),
                            child: RaisedButton(
                              onPressed: () => playTransitionAnim(),
                              textColor: Colors.white,
                              child: Text("位移动画"),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(left: 3, right: 3),
                            child: RaisedButton(
                              onPressed: () => playOpacityAnim(),
                              textColor: Colors.white,
                              child: Text("透明度动画"),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(left: 3, right: 6),
                            child: RaisedButton(
                              onPressed: () => playRotateAnim(),
                              textColor: Colors.white,
                              child: Text("旋转动画"),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: invalid_required_param
  playAnim(@required var updateFunc, var begin, var end,
      {var resetFunc, var duration = 800, var curve = Curves.linear}) {
    var controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
//    final anim = Tween(begin: begin, end: end).animate(controller);
    final anim = CurvedAnimation(parent: controller, curve: curve);
    anim.addListener(() {
      print('value = ${anim.value}');
      setState(() => updateFunc(anim));
    });
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        controller.dispose();
        setState(() => resetFunc(anim));
      }
    });
    controller.forward();
  }

  playTransitionAnim() {
    playAnim(
        (anim) {
//          x = (1 - anim.value) * 300.0;
          y = (anim.value) * 400.0;
        },
        0.0,
        400.0,
        resetFunc: (anim) {
//          x = 0;
          y = 0;
        },
        duration: 1500,
        curve: Curves.bounceOut);
  }

  playOpacityAnim() {
    playAnim(
        (anim) {
          opacity = 1 - anim.value;
        },
        1.0,
        0.0,
        resetFunc: (anim) {
          opacity = 1.0;
        },
        duration: 1000);
  }

  playRotateAnim() {
    playAnim(
        (anim) {
          xAngle = (1 - anim.value) * 6.28;
          yAngle = (1 - anim.value) * 6.28;
          zAngle = (1 - anim.value) * 6.28;
        },
        0.0,
        6.28,
        resetFunc: (anim) {
          xAngle = 0.0;
          yAngle = 0.0;
          zAngle = 0.0;
        },
        duration: 1000);
  }
}
