import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/Screens/Login/login_screen.dart';
import 'package:quan_ly_taiducfood/Screens/Signup/components/background.dart';
import 'package:quan_ly_taiducfood/Screens/Signup/components/or_divider.dart';
import 'package:quan_ly_taiducfood/Screens/Signup/components/social_icon.dart';
import 'package:quan_ly_taiducfood/components/already_have_an_account_acheck.dart';
import 'package:quan_ly_taiducfood/components/rounded_button.dart';
import 'package:quan_ly_taiducfood/components/rounded_input_field.dart';
import 'package:quan_ly_taiducfood/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ĐĂNG KÝ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Nhập email công ty",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "Đăng Ký",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
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
