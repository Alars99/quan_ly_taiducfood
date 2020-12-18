import 'dart:core';
import 'package:quan_ly_taiducfood/hotel_booking/Database/Repostitory.dart';
import 'package:quan_ly_taiducfood/hotel_booking/model/test.dart';

class OrderService {
  Repository _repository;
  OrderService() {
    _repository = Repository();
  }

  saveOrderList(Sanpham sanpham) async {
    return await _repository.insertData('OrderList', sanpham.sanphamMap());
  }

  readOrderList() async {
    return await _repository.readData('OrderList');
  }

  deleteOrderList() async {
    return await _repository.deleteData('OrderList');
  }

  deleteOneOrderList(String id) async {
    return await _repository.deleteOneData('OrderList', id);
  }
}
