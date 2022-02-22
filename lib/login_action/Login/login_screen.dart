import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/main_action/widget/home_widget.dart';
import 'package:quan_ly_taiducfood/models/admin.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_screen.dart';
import 'package:quan_ly_taiducfood/repositories/admins_repository.dart';

class Login_screen extends StatefulWidget {
  @override
  _Login_screenState createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  List<Admin> _list = [];
  bool isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  check(String user, String pass) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWidget(),
        ));

    _list.forEach((element) {
      if (user == element.user && pass == element.pass) {}
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  bool isRead = true;
  final key = GlobalKey<FormState>();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 300,
                height: 600,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(padding: EdgeInsets.symmetric()),
                    Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                          color: Color(0xffFAAA1E),
                          fontWeight: FontWeight.bold,
                          fontSize: 32),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Form(
                      key: key,
                      child: Container(
                        width: 400,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) =>
                                  value.trim().isEmpty ? "Empty" : null,
                              controller: _userController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_pin_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                hintText: "Nhập tên tài khoản hoặc email",
                                labelText: 'Tài khoản',
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            TextFormField(
                              validator: (value) =>
                                  value.isEmpty ? "Empty" : null,
                              obscureText: isRead == true ? true : false,
                              controller: _passController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                fillColor: Color(0xffFAAA1E),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      isRead = !isRead;
                                      setState(() {});
                                    },
                                    icon: isRead == false
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.visibility_off)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                hintText: "Nhập mật khẩu của bạn",
                                labelText: 'Mật khẩu',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                    Container(
                      width: 400,
                      child: RaisedButton(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        highlightElevation: 20.0,
                        // hoverColor: Colors.white,
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          padding: EdgeInsets.all(30.0),
                        ),
                        color: Colors.blue,
                        //padding: EdgeInsets.all(0.0),

                        disabledTextColor: Colors.black,
                        disabledColor: Colors.red,
                        onPressed: () {
                          if (key.currentState.validate()) {
                            check(_userController.text, _passController.text);
                          }
                        },
                      ),
                    ),
                    // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    // TextButton(
                    //   child: Text(
                    //     'Quên mật khẩu !!!',
                    //     style: TextStyle(color: Colors.blue, fontSize: 15),
                    //   ),
                    //   onPressed: () {},
                    // )
                  ],
                ),
              ),
            ),
    ));
  }
}
