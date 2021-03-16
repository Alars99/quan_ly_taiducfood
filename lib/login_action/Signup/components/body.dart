import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/login_action/theme/login_theme.dart';
import 'package:quan_ly_taiducfood/login_action/Signup/components/background.dart';
import 'package:quan_ly_taiducfood/login_action/components/already_have_an_account_acheck.dart';
import 'package:quan_ly_taiducfood/login_action/components/rounded_button.dart';
import '../../../login_action/components/rounded_button.dart';

class Body extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const Body({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  static var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "ĐĂNG KÝ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Chưa nhập email";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[600]),
                    hintText: "Nhập email cá nhân",
                    fillColor: kPrimaryLightColor,
                    icon: Icon(
                      icon,
                      color: kPrimaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusColor: kPrimaryLightColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Chưa nhập mật khẩu";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Mật khẩu",
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[600]),
                    fillColor: kPrimaryLightColor,
                    focusColor: kPrimaryLightColor,
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              RoundedButton(
                text: "Đăng ký",
                press: () {
                  if (formKey.currentState.validate()) {}
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
