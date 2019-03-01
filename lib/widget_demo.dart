import 'package:flutter/material.dart';

class TextPage extends Text {
  TextPage(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          "Hello Flutter",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 32, color: Colors.lightBlueAccent),
        ),
      ),
    );
  }
}

class FavoriteStatefulWidget extends StatefulWidget {

  // 重写 createState()，返回一个 State，它包含了视图和交互逻辑
  @override
  State<StatefulWidget> createState() => _FavoriteStatefulWidgetState();
}

class _FavoriteStatefulWidgetState extends State<FavoriteStatefulWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    // 通过 setState() 更新数据
    // 组件树就会自动刷新了
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  // 重写 build() 函数，构建视图树
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: _toggleFavorite,
            ),
          ),
          SizedBox(
            width: 18,
            child: Container(
              child: Text('$_favoriteCount'),
            ),
          ),
        ],
      );
}




