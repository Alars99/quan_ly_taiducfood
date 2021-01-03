
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/main.dart';

import '../design_course_app_theme.dart';

class LoiNhuanScreen extends StatefulWidget {
  @override
  _LoiNhuanScreen createState() => _LoiNhuanScreen();
}

class _LoiNhuanScreen extends State<LoiNhuanScreen> {
  CategoryType categoryType = CategoryType.ui;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getKhoUI(),
                      getBaoCai(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getKhoUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 16),
          child: Text(
            'Lợi nhuận gộp:' + " 555555 vnd",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text("17/12/20 - 23/12/20"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
        ),
        Container(
          width: 300,
          height: 250,
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  Icons.payments,
                  color: Colors.green[400],
                ),
              ),
              Expanded(
                child: Text("Tồn kho cuối kỳ"),
              ),
              Expanded(
                child: Text("22/11 - 23/12"),
              ),
              Expanded(
                child: Text(
                  "1,500,000",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  "SL: 15",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  print("Chi tiết");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Text(
                        "Chi tiết",
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Divider(
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Nhập trong kỳ"),
                            Text("3,000,000"),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Xuất trong kỳ"),
                            Text("1,500,000"),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Divider(
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  "Giá trị tồn kho = Số lượng * Giá vốn",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getBaoCai() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 16),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text("Xem báo cáo chi tiết"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Icon(
                  Icons.payments,
                  color: Colors.green[400],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text("Báo cáo doanh thu"),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 64,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.green[400],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Icon(
                  Icons.payments,
                  color: Colors.green[400],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text("Báo cáo lợi nhuận"),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 70,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.green[400],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Icon(
                  Icons.payments,
                  color: Colors.green[400],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text("Báo cáo thanh toán"),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 59,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.green[400],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Báo cáo',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  'Kinh doanh',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
