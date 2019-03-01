import 'package:flutter/material.dart';
import 'package:flutter_app/tap_box.dart';

class ParentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ParentWidget();
  }
}

class _ParentWidget extends State<ParentWidget> {
  bool _active = false;

  void _handleTapBoxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: TapBox(
        active: _active,
        // 传入函数
        onChanged: _handleTapBoxChanged,
      ),
    );
  }
}
