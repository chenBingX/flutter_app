import 'package:flutter/material.dart';

class Button extends Container {
  static const double SIZE_EXPANDED = -1;

  static const int GRADIENT_MODE_LR = 0;
  static const int GRADIENT_MODE_RL = 1;
  static const int GRADIENT_MODE_TB = 2;
  static const int GRADIENT_MODE_BT = 3;

  Button({
    Key key,
    @required VoidCallback onPressed,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    double height,
    double width,
    String text,
    double fontSize = 12,
    Color textColor = Colors.black12,
    FontStyle fontStyle,
    Color disabledTextColor,
    Color color,
    EdgeInsetsGeometry padding,
    Color strokeColor = Colors.black,
    double strokeWidth = 0,
    double corner = 0,
    Clip clipBehavior = Clip.none,
    FocusNode focusNode,
//    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    Duration animationDuration,
    int gradientMode = 0,
    bool gradientEnable = false,
    List<Color> gradientColors,

    /// 是否启用阴影
    bool shadowEnable = false,
    Color shadowColor = Colors.grey,
    Offset shadowOffset = Offset.zero,

    /// 阴影模糊程度，值越大，阴影范围越大
    double shadowBlur = 1.0,
    double marginLeft = 0,
    double marginRight = 0,
    double marginTop = 0,
    double marginBottom = 0,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'The color argument is just a shorthand for "decoration: new BoxDecoration(color: color)".'),
        super(
            key: key,
            width: width != null && width < 0 ? null : width,
            height: height != null && height < 0 ? null : height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: _getGradientBegin(gradientMode),
                  end: _getGradientEnd(gradientMode),
                  colors: ((gradientEnable &&
                          gradientColors != null &&
                          gradientColors.isNotEmpty)
                      ? gradientColors
                      : [color, color])),
              borderRadius: corner > 0
                  ? BorderRadius.all(Radius.circular(corner))
                  : BorderRadius.zero,
              border: strokeWidth > 0
                  ? Border.all(color: strokeColor, width: strokeWidth)
                  : null,
              boxShadow: shadowEnable
                  ? [
                      BoxShadow(
                        color: shadowColor,
                        offset: shadowOffset,
                        blurRadius: shadowBlur,
                      )
                    ]
                  : null,
            ),
            alignment: (width == SIZE_EXPANDED || height == SIZE_EXPANDED)
                ? Alignment.center
                : null,
            margin: EdgeInsets.fromLTRB(
                marginLeft, marginTop, marginRight, marginBottom),
            child: RaisedButton(
                key: key,
                onPressed: onPressed,
                onHighlightChanged: onHighlightChanged,
                textTheme: textTheme,
                textColor: textColor,
                disabledTextColor: disabledTextColor,
                color: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                disabledElevation: 0,
                clipBehavior: clipBehavior,
                focusNode: focusNode,
//                autofocus: autofocus,
                materialTapTargetSize: materialTapTargetSize,
                animationDuration: animationDuration,
                padding: padding,
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontStyle: fontStyle),
                )));
}

Alignment _getGradientBegin(int mode) {
  Alignment r = Alignment.centerLeft;
  switch (mode) {
    case Button.GRADIENT_MODE_LR:
      {
        r = Alignment.centerLeft;
      }
      break;
    case Button.GRADIENT_MODE_RL:
      {
        r = Alignment.centerRight;
      }
      break;
    case Button.GRADIENT_MODE_TB:
      {
        r = Alignment.topCenter;
      }
      break;
    case Button.GRADIENT_MODE_BT:
      {
        r = Alignment.bottomCenter;
      }
      break;
  }
  return r;
}

Alignment _getGradientEnd(int mode) {
  Alignment r = Alignment.centerLeft;
  switch (mode) {
    case Button.GRADIENT_MODE_LR:
      {
        r = Alignment.centerRight;
      }
      break;
    case Button.GRADIENT_MODE_RL:
      {
        r = Alignment.centerLeft;
      }
      break;
    case Button.GRADIENT_MODE_TB:
      {
        r = Alignment.bottomCenter;
      }
      break;
    case Button.GRADIENT_MODE_BT:
      {
        r = Alignment.topCenter;
      }
      break;
  }
  return r;
}
