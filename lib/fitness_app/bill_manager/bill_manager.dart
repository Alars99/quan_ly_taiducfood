import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_taiducfood/Screens/Login/components/background.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/fitness_app/fintness_app_theme.dart';

class billManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitnessAppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/back.svg"),
          onPressed: () {},
        ),
      ),
    );
  }
}
