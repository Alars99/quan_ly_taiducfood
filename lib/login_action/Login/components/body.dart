import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/login_action/Login/components/background.dart';
import 'package:quan_ly_taiducfood/login_action/Signup/signup_screen.dart';
import 'package:quan_ly_taiducfood/login_action/components/already_have_an_account_acheck.dart';
import 'package:quan_ly_taiducfood/login_action/components/rounded_button.dart';
import 'package:quan_ly_taiducfood/login_action/components/rounded_input_field.dart';
import 'package:quan_ly_taiducfood/login_action/components/rounded_password_field.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ĐĂNG NHẬP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Nhập email công ty",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "Đăng nhập",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
