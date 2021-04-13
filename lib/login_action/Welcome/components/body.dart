import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/login_action/Login/login_screen.dart';
import 'package:quan_ly_taiducfood/login_action/Signup/signup_screen.dart';
import 'package:quan_ly_taiducfood/login_action/Welcome/components/background.dart';
import 'package:quan_ly_taiducfood/login_action/components/rounded_button.dart';
import 'package:quan_ly_taiducfood/login_action/theme/login_theme.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Quản lý Bán Hàng Demo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: size.height * 0.05),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "Đăng Nhập",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login_screen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "Đăng Ký",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
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
