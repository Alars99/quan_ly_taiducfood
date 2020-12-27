import 'package:firebase_database/firebase_database.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:flutter/material.dart';

class Statistical {
  List<OrderList> _list = List();
  int dem = 0;

  getAll() {
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then((DataSnapshot snapshot) {
      _list.clear();
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
        _list.add(order);
      }
      dem = _list.length;
      print(dem);
    });
  }

  double getDoanhThuThang() {
    return 1200000;
  }

  // ignore: missing_return

  int getDonHuy() {
    return 1;
  }

  int getDonTra() {
    return 1;
  }

  getAllOrderList() {
    List<OrderList> orderList = [];
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
    });
  }
}
