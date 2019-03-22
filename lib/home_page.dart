import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/datas/page.dart';
import 'package:flutter_app/datas/page_data.dart';
import 'package:flutter_app/pages/anim_page.dart';
import 'package:flutter_app/pages/backdrop_filter_page.dart';
import 'package:flutter_app/pages/clip_xxx_page.dart';
import 'package:flutter_app/pages/custom_paint_page2.dart';
import 'package:flutter_app/pages/custom_painter_page.dart';
import 'package:flutter_app/pages/custom_scroll_view_page.dart';
import 'package:flutter_app/pages/file_demo.dart';
import 'package:flutter_app/pages/hero_page.dart';
import 'package:flutter_app/pages/http_demo.dart';
import 'package:flutter_app/pages/list_view_page.dart';
import 'package:flutter_app/pages/message_page.dart';
import 'package:flutter_app/pages/notification_demo.dart';
import 'package:flutter_app/pages/page_view_demo.dart';
import 'package:flutter_app/pages/scanffold_page.dart';
import 'package:flutter_app/pages/single_child_scroll_view_page.dart';
import 'package:flutter_app/pages/tab_page.dart';
import 'package:flutter_app/pages/test_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  var pages;
  var message = 'Welcome!';

  @override
  void initState() {
    // TODO: implement initState
    print("initState");
    super.initState();

    MethodChannel channel = MethodChannel("foo");
    channel.setMethodCallHandler((MethodCall call) async {});

    pages = <Page>[
      Page('Message Page', (context) {
        var data = PageData('Hi, it\'s Home Page!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessagePage(data: data))).then((result) {
          print('received message');
          setState(() {
            message = result;
          });
        });
      }),
      Page('Animation Page', (context) {
        Navigator.push(context, PageRouteBuilder(pageBuilder:
            (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
          return ScaleTransition(
              scale: animation,
              alignment: Alignment.bottomRight,
              child: AnimPage());
        }));
      }),
      Page('Hero Demo', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HeroPage()));
      }),
      Page('ListView Demo', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListViewPage()));
      }),
      Page('Scaffold Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScaffoldPage()));
      }),
      Page('Tab Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabPage()));
      }),
      Page('CustomScrollView Page', (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomScrollViewPage()));
      }),
      Page('PageView Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PageViewPage()));
      }),
      Page('SingleChildScrollView Page', (context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleChildScrollViewPage()));
      }),
      Page('Notification Page', (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationPage()));
      }),
      Page('FileDemo Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FileDemoPage()));
      }),
      Page('HttpDemo Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HttpDemoPage()));
      }),
      Page('ClipXXX Page', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ClipXXXPage()));
      }),
      Page('BackDropFilter Page', (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BackDropFilterPage()));
      }),
      Page('SimpleDialog', (context) {
        showSimpleDialog(context);
      }),
      Page('AlertDialog', (context) {
        showAlertDialog(context);
      }),
      Page('CustomDialog', (context) {
        showCustomDialog(context);
      }),
      Page('CustomPainterPage', (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomPainterPage()));
      }),
      Page('CustomPainterPage2', (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomPainterPage2()));
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("build HomePage");
    return Scaffold(
        appBar: AppBar(
            title: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TestPage();
            }));
          },
          child: Text('Home Page'),
        )),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  // 分割线构造器
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.red,
                      height: 1,
                    );
                  },
                  itemCount: pages.length,
                  // 子 Widget 构造器
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(context, pages[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(BuildContext context, Page page, int index) {
    return GestureDetector(
        onTap: () => page.action(context),
        child: Container(
          margin: EdgeInsets.only(top: index == 0 ? 8 : 0),
          alignment: Alignment.center,
          color: Colors.white,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                page.pageName,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ));
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  void showAlertDialog(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Dialog'),
              content: Text(('Dialog content..')),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void showCustomDialog(context) {
    showDialog(
      context: context,
      builder: (_) => Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Custom Dialog',
                            style: TextStyle(
                                fontSize: 16, decoration: TextDecoration.none)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 8),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(_);
                            },
                            child: Text('确定')),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
    );
  }

  void showSimpleDialog(context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("SimpleDialog"),
            titlePadding: EdgeInsets.all(10),
            backgroundColor: Colors.amber,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            children: <Widget>[
              ListTile(
                title: Center(child: Text("Item_1"),),
              ),
              ListTile(
                title: Center(child: Text("Item_2"),),
              ),
              ListTile(
                title: Center(child: Text("Item_3"),),
              ),
              ListTile(
                title: Center(child: Text("Close"),),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
