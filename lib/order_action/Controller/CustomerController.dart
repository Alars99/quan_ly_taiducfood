import 'dart:core';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/Database/Repostitory.dart';

class CustomerService {
  Repository _repository1;
  CustomerService() {
    _repository1 = Repository();
  }

  saveOrderList(Customer customer) async {
    return await _repository1.insertData(
        'customerList', customer.customerMap());
  }

  readCustomerList() async {
    return await _repository1.readData('customerList');
  }

  readCustomer(String id) async {
    return await _repository1.readOneData('customerList', id);
  }

  deleteOrderList() async {
    return await _repository1.deleteData('customerList');
  }

  deleteOneOrderList(String id) async {
    return await _repository1.deleteOneData('customerList', id);
  }

  updateCustomer(Customer customer) async {
    return await _repository1.updateData(
        'customerList', customer.customerMap());
  }
}
