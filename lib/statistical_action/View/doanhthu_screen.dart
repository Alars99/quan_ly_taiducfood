import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';

import '../design_course_app_theme.dart';

class DoanhthuScreen extends StatefulWidget {
  @override
  _DoanhthuScreen createState() => _DoanhthuScreen();
}

class _DoanhthuScreen extends State<DoanhthuScreen> {
  CategoryType categoryType = CategoryType.ui;

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
  int touchedGroupIndex;
  DateTime startDate = DateTime.now();

  double a = 900000;
  double tong7ngay = 0.0;

  final Color leftBarColor = const Color(0xff53fdd7);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  List<OrderList> orderList = [];
  double tong6;
  double tong5;
  double tong4;
  double tong3;
  double tong2;
  double tong1;
  double tongDay;

  double day6;
  double day5;
  double day4;
  double day3;
  double day2;
  double day1;
  double today;

  DateTime _dateTime6;
  DateTime _dateTime5;
  DateTime _dateTime4;
  DateTime _dateTime3;
  DateTime _dateTime2;
  DateTime _dateTime1;
  DateTime _dateTimeToday;

  @override
  void initState() {
    super.initState();
    tong6 = 0;
    tong5 = 0;
    tong4 = 0;
    tong3 = 0;
    tong2 = 0;
    tong1 = 0;
    tongDay = 0;

    day6 = 0;
    day5 = 0;
    day4 = 0;
    day3 = 0;
    day2 = 0;
    day1 = 0;
    today = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then((DataSnapshot snapshot) {
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
        );
        orderList.add(order);
      }
      _dateTime6 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 6);
      _dateTime5 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 5);
      _dateTime4 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 4);
      _dateTime3 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 3);
      _dateTime2 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 2);
      _dateTime1 =
          DateTime.utc(startDate.year, startDate.month, startDate.day - 1);
      _dateTimeToday =
          DateTime.utc(startDate.year, startDate.month, startDate.day);
      for (var sp in orderList) {
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime6) &&
            sp.trangthai == "4") {
          tong6 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime5) &&
            sp.trangthai == "4") {
          tong5 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime4) &&
            sp.trangthai == "4") {
          tong4 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime3) &&
            sp.trangthai == "4") {
          tong3 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime2) &&
            sp.trangthai == "4") {
          tong2 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime1) &&
            sp.trangthai == "4") {
          tong1 += double.parse(sp.tongTienhang);
        }
        if (sp.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTimeToday) &&
            sp.trangthai == "4") {
          tongDay += double.parse(sp.tongTienhang);
        }
      }
      day6 = tong6;
      day5 = tong5;
      day4 = tong4;
      day3 = tong3;
      day2 = tong2;
      day1 = tong1;
      today = tongDay;
      print(day6.toString() + " 6");
      print(day5.toString() + " 5");
      print(day4.toString() + " 4");
      print(day3.toString() + " 3");
      print(day2.toString() + " 2");
      print(day1.toString() + " 1");
      print(today.toString() + " today");

      tong7ngay = day6 + day5 + day4 + day3 + day2 + day1 + today;

      final barGroup1 = makeGroupData(0, day6, 12);
      final barGroup2 = makeGroupData(1, day5, 12);
      final barGroup3 = makeGroupData(2, day4, 5);
      final barGroup4 = makeGroupData(3, day3, 16);
      final barGroup5 = makeGroupData(4, day2, 6);
      final barGroup6 = makeGroupData(5, day1, 1.5);
      final barGroup7 = makeGroupData(6, today, 1.5);

      final items = [
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
    });
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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    getKhoUI(),
                    getBaoCai(),
                  ],
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
            width: 320,
            height: 280,
            decoration: BoxDecoration(
                color: HexColor('#F8FAFB'),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              children: [
                SizedBox(height: 23),
                // BarChart(
                //   BarChartData(
                //     maxY: 20,
                //     barGroups: [
                //       BarChartGroupData(
                //         barsSpace: 10,
                //         x: 0,
                //         barRods: [
                //           BarChartRodData(
                //             y: 11,
                //             width: 5,
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //         ],
                //       ),
                //     ],
                //     titlesData: FlTitlesData(
                //       leftTitles: SideTitles(
                //         showTitles: true,
                //         getTextStyles: (value) => const TextStyle(
                //             color: Color(0xff7589a2),
                //             fontWeight: FontWeight.bold,
                //             fontSize: 14),
                //         margin: 32,
                //         reservedSize: 14,
                //         interval: 5,
                //       ),
                //     ),
                //   ),
                // ),
                BarChart(
                  BarChartData(
                    maxY: a,
                    // barTouchData: BarTouchData(
                    //     touchTooltipData: BarTouchTooltipData(
                    //       tooltipBgColor: Colors.grey,
                    //       getTooltipItem: (_a, _b, _c, _d) => null,
                    //     ),
                    //     touchCallback: (response) {
                    //       if (response.spot == null) {
                    //         setState(() {
                    //           touchedGroupIndex = -1;
                    //           showingBarGroups = List.of(rawBarGroups);
                    //         });
                    //         return;
                    //       }
                    //       touchedGroupIndex =
                    //           response.spot.touchedBarGroupIndex;
                    //       setState(() {
                    //         if (response.touchInput is FlLongPressEnd ||
                    //             response.touchInput is FlPanEnd) {
                    //           touchedGroupIndex = -1;
                    //           showingBarGroups = List.of(rawBarGroups);
                    //         } else {
                    //           showingBarGroups = List.of(rawBarGroups);
                    //           if (touchedGroupIndex != -1) {
                    //             double sum = 0;
                    //             for (BarChartRodData rod
                    //                 in showingBarGroups[touchedGroupIndex]
                    //                     .barRods) {
                    //               sum += rod.y;
                    //             }
                    //             final avg = sum /
                    //                 showingBarGroups[touchedGroupIndex]
                    //                     .barRods
                    //                     .length;
                    //             showingBarGroups[touchedGroupIndex] =
                    //                 showingBarGroups[touchedGroupIndex]
                    //                     .copyWith(
                    //               barRods: showingBarGroups[touchedGroupIndex]
                    //                   .barRods
                    //                   .map((rod) {
                    //                 return rod.copyWith(y: avg);
                    //               }).toList(),
                    //             );
                    //           }
                    //         }
                    //       });
                    //     }),

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
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 32,
                        reservedSize: 14,
                        interval: a / 4,
                        // getTitles: (value) {
                        //   if (value == 0) {
                        //     return '0';
                        //   } else if (value == 10) {
                        //     return '5K';
                        //   } else if (value == 19) {
                        //     return '10K';
                        //   } else if (value == 12) {
                        //     return '10K';
                        //   } else {
                        //     return '';
                        //   }
                        // },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                  ),
                ),
                // Expanded(
                //   child: Icon(
                //     Icons.payments,
                //     color: Colors.green[400],
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // Expanded(
                //   child: Text("Tồn kho cuối kỳ"),
                // ),
                // Expanded(
                //   child: Text("22/11 - 23/12"),
                // ),
                // Expanded(
                //   child: Text(
                //     "1,500,000",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     "SL: 15",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     print("Chi tiết");
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.only(),
                //         child: Text(
                //           "Chi tiết",
                //           style: TextStyle(color: Colors.blue[300]),
                //         ),
                //       ),
                //       Icon(Icons.chevron_right)
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 8, right: 8),
                //   child: Divider(
                //     color: Colors.black87,
                //   ),
                // ),
                // Row(
                //   children: [
                //     Column(
                //       children: [
                //         Container(
                //           padding: EdgeInsets.all(8),
                //           child: Column(
                //             children: [
                //               Text("Nhập trong kỳ"),
                //               Text("3,000,000"),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //     SizedBox(
                //       width: 60,
                //     ),
                //     Column(
                //       children: [
                //         Container(
                //           padding: EdgeInsets.all(8),
                //           child: Column(
                //             children: [
                //               Text("Xuất trong kỳ"),
                //               Text("1,500,000"),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 8, right: 8),
                //   child: Divider(
                //     color: Colors.black87,
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     "Giá trị tồn kho = Số lượng * Giá vốn",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
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
          padding: EdgeInsets.only(top: 8),
          child: Text("Xem báo cáo chi tiết"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            print("1");
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
            print("2");
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
            print("3");
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
