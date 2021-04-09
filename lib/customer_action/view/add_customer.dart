import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quan_ly_taiducfood/customer_action/models/quan.dart';
import 'package:quan_ly_taiducfood/customer_action/models/thanhpho.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddcustomerScreen createState() => _AddcustomerScreen();
}

class _AddcustomerScreen extends State<AddCustomer> {
  var customer = Customer();
  var _customerService = CustomerService();
  List<Quan> quanList = Quan.quanList;
  List<ThanhPho> tpList = ThanhPho.tpList;
  String thanhpho, quanhuyen, phuongxa, duong, tp;

  bool isLoading = false;

  // String id;
  // String name;
  // String phone;
  // String mail;
  // String address;
  // int point;

  final name = "Họ và tên:";
  final phone = "Số điện thoại:";
  final email = "Email:";
  final address = "Địa chỉ";

  @override
  void initState() {
    // random id cua khach hang
    customer.id = "customer" + Random().nextInt(100000).toString();
    customer.name = "";
    customer.address = "";
    customer.mail = "";
    customer.phone = "";
    customer.point = 0;
    super.initState();
  }

  _isLoading() async {
    setState(() {
      isLoading = true;
    });
    var a = customer.addCustomer(customer);

    setState(() {
      isLoading = false;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  getAppBarUI(),
                  SingleChildScrollView(
                    child: getInfoUI(),
                    padding: EdgeInsets.all(16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getInfoUI() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: OrderAppTheme.buildLightTheme().primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 16),
              child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#F8FAFB'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              return customer.name = value;
                            } else {
                              return "chưa nhập gì";
                            }
                          },
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person_outline_sharp),
                            labelText: name,
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
          Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 16),
              child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#F8FAFB'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              return customer.phone = value;
                            } else {
                              return "chưa nhập gì";
                            }
                          },
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.phone),
                            labelText: phone,
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
          Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 16),
              child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#F8FAFB'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              return customer.mail = value;
                            } else {
                              return "chưa nhập gì";
                            }
                          },
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.mail),
                            labelText: email,
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
          Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 16),
              child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#F8FAFB'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              return customer.address = value;
                            } else {
                              return "chưa nhập gì";
                            }
                          },
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.home),
                            labelText: address,
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    if (customer.toJson().isNotEmpty &&
                        customer.name.isNotEmpty) {
                      _isLoading();
                    }
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          if (isLoading)
            CircularProgressIndicator(
              strokeWidth: 6.5,
            )
          else
            Center(
              child: Text(""),
            )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back,
                color: OrderAppTheme.buildLightTheme().primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              'Thêm khách hàng',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.2,
                color: DesignCourseAppTheme.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
