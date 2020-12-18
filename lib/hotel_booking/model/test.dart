import 'dart:ffi';

import 'package:quan_ly_taiducfood/hotel_booking/View/Order/order_list_view.dart';
import 'package:quan_ly_taiducfood/hotel_booking/View/Order/order_screen.dart';

class Sanpham {
  String brand;
  String id;
  String name;
  String price;
  int amout;
  bool isSelected;
  String img;
  int count;

  Sanpham({
    this.brand = '',
    this.id = '',
    this.name = '',
    this.price = '',
    this.amout = 5,
    this.img = '',
    this.isSelected = false,
    this.count = 1,
  });

  sanphamMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['brand'] = brand;
    mapping['price'] = price;
    mapping['count'] = count;
    return mapping;
  }
}
