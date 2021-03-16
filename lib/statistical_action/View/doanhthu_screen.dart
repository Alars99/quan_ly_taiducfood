import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:quan_ly_taiducfood/statistical_action/View/bao_cao_chi_tiet/bao_cao_doanh_thu.dart';

import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';
import 'bao_cao_chi_tiet/bao_cao_loi_nhuan.dart';
import 'bao_cao_chi_tiet/bao_cao_thanh_toan.dart';

class DoanhthuScreen extends StatefulWidget {
  @override
  _DoanhthuScreen createState() => _DoanhthuScreen();
}

class _DoanhthuScreen extends State<DoanhthuScreen> {
  CategoryType categoryType = CategoryType.ui;

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
  int touchedGroupIndex;
  DateTime now = DateTime.now();

  double a = 0.0;
  double tong7ngay = 0.0;

  GlobalKey<RefreshIndicatorState> reKey;

  final Color leftBarColor = const Color(0xff53fdd7);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  List<BarChartGroupData> items;

  BarChartGroupData barGroup1;
  BarChartGroupData barGroup2;
  BarChartGroupData barGroup3;
  BarChartGroupData barGroup4;
  BarChartGroupData barGroup5;
  BarChartGroupData barGroup6;
  BarChartGroupData barGroup7;

  List<OrderList> orderList = [];

  double tong;
  double day;
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    reKey = GlobalKey<RefreshIndicatorState>();
    getData();
  }

  getData() {
    tong = 0;
    day = 0;
    tong7ngay = 0.0;

    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then(
      (DataSnapshot snapshot) {
        orderList.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          OrderList order = new OrderList(
            values[key]["idDonHang"],
            values[key]["idGioHang"],
            values[key]["tongTienhang"],
            values[key]["tongSoluong"],
            values[key]["phiGiaohang"],
            values[key]["chietKhau"],
            values[key]["banSiLe"],
            values[key]["paymethod"],
            values[key]["idKhachHang"],
            values[key]["ngaymua"],
            values[key]["trangthai"],
            values[key]["giomua"],
            values[key]["tongGiaVon"],
            values[key]["datetime"],
          );
          orderList.add(order);
        }
        for (int i = 0; i < 7; i++) {
          tong = 0;
          day = 0;
          _dateTime = DateTime.utc(now.year, now.month, now.day - i);
          for (var sp in orderList) {
            if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime) &&
                sp.trangthai == "4") {
              tong += double.parse(sp.tongTienhang);
              if (a < tong) {
                a = tong;
              }
            }
          }
          day = tong;
          tong7ngay += day;

          if (i == 6) {
            barGroup1 = makeGroupData(0, day);
          }
          if (i == 5) {
            barGroup2 = makeGroupData(1, day);
          }
          if (i == 4) {
            barGroup3 = makeGroupData(2, day);
          }
          if (i == 3) {
            barGroup4 = makeGroupData(3, day);
          }
          if (i == 2) {
            barGroup5 = makeGroupData(4, day);
          }
          if (i == 1) {
            barGroup6 = makeGroupData(5, day);
          }
          if (i == 0) {
            barGroup7 = makeGroupData(6, day);
          }
          items = [
            barGroup1,
            barGroup2,
            barGroup3,
            barGroup4,
            barGroup5,
            barGroup6,
            barGroup7,
          ];
          rawBarGroups = items;

          showingBarGroups = rawBarGroups;
          setState(() {});
        }
      },
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getData();
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
              child: RefreshIndicator(
                key: reKey,
                onRefresh: () async {
                  await refreshList();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getKhoUI(),
                      getBaoCai(),
                      SizedBox(
                        height: 50,
                      ),
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
    final formatCurrency = new NumberFormat.simpleCurrency(
        locale: 'vi', name: "VNĐ", decimalDigits: 0);
    int dt = tong7ngay.round();
    final now = DateTime.now();
    final dday = new DateTime(now.year, now.month, now.day);
    final day6 = new DateTime(now.year, now.month, now.day - 6);
    var d = DateFormat('dd/MM/yyyy').format(dday).toString();
    var d7 = DateFormat('dd/MM/yyyy').format(day6).toString();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 16),
            child: Text(
              'Doanh thu: ' + formatCurrency.format(dt),
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
            padding: EdgeInsets.only(),
            child: Text(d7 + " - " + d),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: HexColor('#F8FAFB'),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              children: [
                SizedBox(height: 23),
                BarChart(
                  BarChartData(
                    maxY: a,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                        margin: 20,
                        getTitles: (double value) {
                          final y1 =
                              new DateTime(now.year, now.month, now.day - 1);
                          final y2 =
                              new DateTime(now.year, now.month, now.day - 2);
                          final y3 =
                              new DateTime(now.year, now.month, now.day - 3);
                          final y4 =
                              new DateTime(now.year, now.month, now.day - 4);
                          final y5 =
                              new DateTime(now.year, now.month, now.day - 5);
                          final y6 =
                              new DateTime(now.year, now.month, now.day - 6);
                          switch (value.toInt()) {
                            case 0:
                              return DateFormat('dd/MM').format(y6).toString();
                            case 1:
                              return DateFormat('dd/MM').format(y5).toString();
                            case 2:
                              return DateFormat('dd/MM').format(y4).toString();
                            case 3:
                              return DateFormat('dd/MM').format(y3).toString();
                            case 4:
                              return DateFormat('dd/MM').format(y2).toString();
                            case 5:
                              return DateFormat('dd/MM').format(y1).toString();
                            case 6:
                              return DateFormat('dd/MM').format(now).toString();
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: a == 0
                          ? SideTitles()
                          : SideTitles(
                              showTitles: true,
                              getTextStyles: (value) => const TextStyle(
                                  color: Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              margin: 32,
                              reservedSize: 14,
                              interval: a / 4,
                            ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
    ]);
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
          padding: EdgeInsets.only(top: 16),
          child: Text("Xem báo cáo chi tiết"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 16),
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => BaoCaoDoanhThuScreen()));
          },
          child: Container(
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
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => BaoCaoLoiNhuanScreen()));
          },
          child: Container(
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
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => BaoCaoThanhToanScreen()));
          },
          child: Container(
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
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
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
