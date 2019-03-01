import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'widget_demo.dart';
import 'parent_widget.dart';
import 'pages/splash_page.dart';

void main() => runApp(MaterialApp(
  title: 'Flutter',
  home: SplashPage(),
));




//main() => runApp(MaterialApp(
//      title: 'Flutter Demo',
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Flutter Demo'),
//        ),
//        body: Container(
//          color: Colors.white,
////          child: _buildImage(),
////          child: _buildRowImg(),
////          child: _buildIcons(),
////          child: MyStatefulWidget(),
////      child: _buildListView(),
//          child: Center(
////            child: FavoriteStatefulWidget(),
//            child: ParentWidget(),
//          ),
//        ),
//      ),
//    ));



//main() => runApp(Center(
//      child: RichText(
//          textDirection: TextDirection.rtl,
//          text: TextSpan(text: "Hello ", children: <TextSpan>[
//            TextSpan(
//                text: "bold",
//                style: TextStyle(
//                    color: Colors.deepPurpleAccent,
//                    fontSize: 56,
//                    fontWeight: FontWeight.bold)),
//            TextSpan(text: " world")
//          ])),
//    ));

//void main() => runApp(Container(
//      decoration: BoxDecoration(color: Colors.white),
//      // 设置 padding
//      padding: EdgeInsets.all(16),
//      child: Center(
//        child: Text(
//            "Hello Flutter!Hello Flutter!Hello Flutter!Hello Flutter!Hello Flutter!",
//            // 设置字体风格
//            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 26),
//            textDirection: TextDirection.ltr,
//            // 设置对齐方式
//            textAlign: TextAlign.right,
//            // 设置最大行数
//            maxLines: 2,
//            // 设置超长处理方式
//            overflow: TextOverflow.fade),
//      ),
//    ));

//void main() => runApp(
//    // 在中心
//    Center(
//        // 添加 Container
//        child: Container(
//            // 设置子 View 的在容器中的相对位置
//            alignment: Alignment.center,
//            width: 200,
//            height: 200,
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color: Colors.white,
//              image: DecorationImage(
//                  image: ExactAssetImage("images/collection.png"),
//                  fit: BoxFit.cover),
//            ),
//            // 添加 Container
//            child: Container(
//              width: 100.0,
//              height: 100.0,
//              // 设置边框装饰
//              decoration: BoxDecoration(
//                color: Colors.deepPurpleAccent,
//                // 设置边框
//                border: Border.all(width: 10, color: Colors.red),
//                // 设置圆角
//                borderRadius: BorderRadius.all(Radius.circular(8)),
//              ),
//              margin: EdgeInsets.all(4),
//              // 添加图片
//              child: Image.asset("images/dart_logo.png"),
//            ))));

//main() => runApp(Center(
//      child: Container(
//        width: 400,
//        height: 400,
//        decoration: BoxDecoration(
//            // 背景色
//            color: Colors.white,
//            // 绘制区域颜色
//            shape: BoxShape.circle,
//            // 图片
//            image: DecorationImage(
//                image: ExactAssetImage("images/flutter_logo.png"),
//                fit: BoxFit.cover),
//            // 边框
//            border: Border.all(color: Colors.lightBlueAccent, width: 8)),
//        child: Center(
//          child: Text(
//            "Box Decoration",
//            textDirection: TextDirection.ltr,
//            style: TextStyle(
//                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
//          ),
//        ),
//      ),
//    ));

//main() => runApp(
//      MaterialApp(
//          title: "Flutter Demo",
//          home: Scaffold(
//              appBar: AppBar(title: Text("Flutter Demo")),
//              body: Container(
//                  color: Colors.grey[500],
//                  child: Center(
//                      child: Container(
//                          width: 300,
//                          height: 300,
//                          color: Colors.deepPurpleAccent,
//                          child: Center(child: _buildRowImg())))))),
//    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter!',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
//          child: Text(wordPair.asPascalCase),
          child: RandomWords(),
        ),
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RandomWordsState();
}

Widget _buildStack() => Stack(
      // 影响非第一个 Widget 的相对位置
      alignment: Alignment(0.5, 0.5),
      children: [
        // 第一个 Widget
        CircleAvatar(
          backgroundImage: AssetImage('images/flutter_logo.png'),
          radius: 100,
        ),
        // 第二个 Widget
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            'CoorChice',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

Widget _buildRowImg() => Row(
      // 主要对齐方式
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/pic.png',
          width: 100,
          height: 200,
          fit: BoxFit.fill,
        ),
        Image.asset(
          'images/pic.png',
          width: 100,
          height: 100,
        ),
        Image.network(
          'https://raw.githubusercontent.com/chenBingX/img/master/其它/download.jpg',
          width: 100,
          height: 100,
        ),
        Icon(Icons.access_alarm, color: Colors.black, size: 26)
      ],
    );

Widget _buildImage() => Center(
      child: Image.network(
        'https://raw.githubusercontent.com/chenBingX/img/master/其它/download.jpg',
        width: 200,
        height: 200,
      ),
    );

Widget _buildIcons() => Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.account_box, color: Colors.black, size: 26),
          Icon(Icons.add_a_photo, color: Colors.black, size: 26),
          Icon(Icons.add_circle, color: Colors.black, size: 26),
          Icon(Icons.android, color: Colors.black, size: 26),
        ],
      ),
    );

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Code'),
      ),
      body: Center(
        child: Text('You have pressed the button $_count times.'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
              _count++;
            }),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _buildListView() {
  Widget _buildItem(var index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 6),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.lightBlue, width: 1),
                image: DecorationImage(
                    image: NetworkImage(
                  'http://www.gx8899.com.img.800cdn.com/uploads/allimg/160804/3-160P4111639.jpg',
                ))),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(
              'Player ${index + 1}',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createDatas() {
    var items = <Widget>[];
    for (var i = 0; i < 20; i++) {
      items.add(_buildItem(i));
    }
    return items;
  }

  return ListView(
    itemExtent: 80,
    children: createDatas(),
  );
}
