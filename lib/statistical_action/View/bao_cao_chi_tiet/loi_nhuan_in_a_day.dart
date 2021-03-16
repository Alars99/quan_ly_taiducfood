import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_detail_screen.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';

class DonhangInADay extends StatefulWidget {
  @override
  _DonhangInADayState createState() => _DonhangInADayState();
  static const routeName = '/donhang-in-a-day';
}

class _DonhangInADayState extends State<DonhangInADay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  int tongtienAll = 0;

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');

  List<OrderList> orderList = [];
  List<OrderList> orderListSortDate = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    orderListSortDate.clear();
    tongtienAll = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map data = ModalRoute.of(context).settings.arguments;
    var dateGetData = data['date'];
    var dataGetName = data['name'];
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
      orderListSortDate.clear();
      tongtienAll = 0;
      double tongMoney = 0;
      double tongMoneyVon = 0;
      for (var order in orderList) {
        if (order.ngaymua == dateGetData.toString() && order.trangthai == "4") {
          tongMoney += double.parse(order.tongTienhang).round();
          tongMoneyVon += double.parse(order.tongGiaVon).round();
          tongtienAll += (tongMoney - tongMoneyVon).round();
          OrderList orderSort = new OrderList(
            order.idDonHang,
            order.idGioHang,
            order.tongTienhang,
            order.tongSoluong,
            order.phiGiaohang,
            order.chietKhau,
            order.banSiLe,
            order.paymethod,
            order.idKhachHang,
            order.ngaymua,
            order.trangthai,
            order.giomua,
            order.tongGiaVon,
            order.datetime,
          );
          orderListSortDate.add(orderSort);
        }
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
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    var datetitle = data['date'];
    var dataGetName = data['name'];
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            datetitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
        ),
        body: Container(
          child: Column(
            children: [
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
                        dataGetName.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency.format(tongtienAll),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              orderListSortDate.length == 0
                  ? Center(
                      child: Text(
                      "Không có dữ liệu",
                      style: TextStyle(fontSize: 20),
                    ))
                  : Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: orderListSortDate.length,
                          itemBuilder: (_, index) {
                            return orderListWidget(
                              orderListSortDate[index].idDonHang,
                              orderListSortDate[index].idKhachHang,
                              orderListSortDate[index].ngaymua,
                              orderListSortDate[index].trangthai,
                              orderListSortDate[index].idGioHang,
                              orderListSortDate[index].banSiLe,
                              orderListSortDate[index].chietKhau,
                              orderListSortDate[index].paymethod,
                              orderListSortDate[index].phiGiaohang,
                              orderListSortDate[index].tongSoluong,
                              orderListSortDate[index].tongTienhang,
                              orderListSortDate[index].giomua,
                              orderListSortDate[index].tongGiaVon,
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderListWidget(
      String idDonHang,
      String idKhachHang,
      String ngaymua,
      String trangthai,
      String idGioHang,
      String banSiLe,
      String chietKhau,
      String paymethod,
      String phiGiaohang,
      String tongSoluong,
      String tongTienhang,
      String giomua,
      String tongGiaVon) {
    var tong = double.parse(tongTienhang) - double.parse(tongGiaVon);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(OrderDetailScreen.routeName, arguments: {
          'idGioHang': idGioHang,
          'idDonHang': idDonHang,
          'banSiLe': banSiLe,
          'chietKhau': chietKhau,
          'idKhachHang': idKhachHang,
          'ngaymua': ngaymua,
          'paymethod': paymethod,
          'phiGiaohang': phiGiaohang,
          'trangthai': trangthai,
          'tongSoluong': tongSoluong,
          'tongTienhang': tongTienhang,
          'tongGiaVon': tongGiaVon,
        });
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        child: Text(
                          idDonHang,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ngaymua + " " + giomua),
                    ],
                  ),
                  Text(
                    formatCurrency.format(tong.round()),
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
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
