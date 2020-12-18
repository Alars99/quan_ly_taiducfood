import 'dart:core';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/Database/Repostitory.dart';
import 'package:quan_ly_taiducfood/order_action/model/test.dart';

class CustomerService {
  Repository _repository;
  CustomerService() {
    _repository = Repository();
  }

  saveOrderList(Customer customer) async {
    return await _repository.insertData('customerList', customer.customerMap());
  }

  readOrderList() async {
    return await _repository.readData('customerList');
  }

  deleteOrderList() async {
    return await _repository.deleteData('customerList');
  }

  deleteOneOrderList(String id) async {
    return await _repository.deleteOneData('customerList', id);
  }
}
