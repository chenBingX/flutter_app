import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  var controller = TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      primary: true,
      body: Container(
          // 对齐方式
          alignment: Alignment.bottomCenter,
          // 子 Widget
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 500)),
              TextField(
                autofocus: true,
                focusNode: focusNode,
                decoration: InputDecoration(
                  icon: Icon(Icons.add_a_photo),
                  labelText: '用户名',
                  hintText: '用户名或邮箱',
                  counterText: '100',
                  filled: true,
                  fillColor: Colors.amber,
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.person),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.join,
                controller: controller,
              ),
              TextFormField(
                validator: (v) {
                  return v.length > 2 ? '不能超过2个字' : null;
                },
              )
            ],
          )),
    );
  }
}
