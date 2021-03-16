import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:quan_ly_taiducfood/statistical_action/View/bao_cao_chi_tiet/loi_nhuan_in_a_day.dart';
import 'package:quan_ly_taiducfood/statistical_action/View/bao_cao_chi_tiet/thanh_toan_in_a_day.dart';
import 'package:quan_ly_taiducfood/statistical_action/models/doanhthu_Days.dart';

class BaoCaoThanhToanScreen extends StatefulWidget {
  @override
  _BaoCaoThanhToanScreenState createState() => _BaoCaoThanhToanScreenState();
}

class _BaoCaoThanhToanScreenState extends State<BaoCaoThanhToanScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  DateTime startTime;
  DateTime endTime;
  DateTime _date;
  String _dateString;
  int tongMoneyDH;
  int tongMoneyDHtra;
  int sl;
  int dem;
  int tongDHtheoThang;

  List dateList = [];
  List<DoanhThuDays> dateListSort = [];
  List<OrderList> orderList = [];

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    endTime = DateTime.now();
    startTime = DateTime.utc(endTime.year, endTime.month - 1, endTime.day);
    tongDHtheoThang = 0;
    getdata();
  }

  getdata() {
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
          values[key]["giomua"],
          values[key]["tongGiaVon"],
          values[key]["datetime"],
        );
        orderList.add(order);
      }
      for (int i = 0; i < 32; i++) {
        _date =
            DateTime.utc(startTime.year, startTime.month, startTime.day + i);
        dateList.add(_date);
      }
      dateList.sort((a, b) => b.compareTo(a));
      dateListSort.clear();
      for (int i = 0; i < 32; i++) {
        _dateString = DateFormat("dd/MM/yyyy").format(dateList[i]);
        DoanhThuDays doanhThuDays = new DoanhThuDays(
          date: _dateString,
          tienAlldonhang: 0,
          soluong: 0,
        );
        dateListSort.add(doanhThuDays);
      }

      for (var dl in dateListSort) {
        tongMoneyDH = 0;
        tongMoneyDHtra = 0;

        sl = 0;
        for (var order in orderList) {
          if (order.ngaymua == dl.date) {
            if (order.trangthai == "4" || order.trangthai == "5") {
              sl++;
              tongMoneyDH += double.parse(order.tongTienhang).round();
            }
            if (order.trangthai == "5") {
              tongMoneyDHtra += double.parse(order.tongTienhang).round();
            }
          }
          dl.tienAlldonhang = tongMoneyDH - tongMoneyDHtra;

          dl.soluong = sl;
        }
        tongDHtheoThang += dl.tienAlldonhang;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Thanh toán theo ngày",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 12, bottom: 12, right: 7),
                      child: Icon(Icons.calendar_today),
                    ),
                    Text(
                      "${DateFormat("dd/MM/yyyy").format(startTime)} - ${DateFormat("dd/MM/yyyy").format(endTime)}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Thanh toán".toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatCurrency.format(tongDHtheoThang),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: dateListSort.length,
                      itemBuilder: (_, index) {
                        return datewidget(
                          dateListSort[index].date,
                          dateListSort[index].tienAlldonhang,
                          dateListSort[index].soluong,
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget datewidget(date, int tienAlldonhang, int soluong) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(DonhangInADay2.routeName,
            arguments: {'date': date, 'name': 'Thanh toán KH'});
      },
      child: new Container(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 8, top: 8),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    date.toUpperCase(),
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatCurrency.format(tienAlldonhang).toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(soluong.toString() + " đơn hàng"),
                    ],
                  ),
                ],
              ),
            ),
            new Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
