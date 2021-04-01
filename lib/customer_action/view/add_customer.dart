import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/customer_action/models/quan.dart';
import 'package:quan_ly_taiducfood/customer_action/models/thanhpho.dart';
import 'package:quan_ly_taiducfood/main.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getInfoUI(),
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

  Widget getInfoUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 50),
      child: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
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
                                labelText: 'Họ và tên: ',
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.person, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
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
                                labelText: 'Số điện thoại: ',
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.phone, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  return customer.email = value;
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
                                labelText: 'Email: ',
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.email, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: DropdownButton<String>(
                                value: thanhpho,
                                style: TextStyle(color: Colors.blue[400]),
                                underline: Container(
                                  height: 0,
                                  color: Colors.deepPurpleAccent,
                                  alignment: Alignment.center,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    thanhpho = newValue;
                                  });
                                },
                                items: tpList.map((valueItem) {
                                  return DropdownMenuItem<String>(
                                    value: valueItem.name,
                                    child: Text(valueItem.name),
                                  );
                                }).toList(),
                              )),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.location_city,
                              color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: DropdownButton<String>(
                                value: tp,
                                style: TextStyle(color: Colors.blue[400]),
                                underline: Container(
                                  height: 0,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    customer.idship = newValue;
                                    tp = newValue;
                                  });
                                },
                                items: quanList.map((valueItem) {
                                  return DropdownMenuItem<String>(
                                    value: valueItem.id.toString(),
                                    child: Text(valueItem.name),
                                    onTap: () {
                                      quanhuyen = valueItem.name;
                                    },
                                  );
                                }).toList(),
                              )),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.location_city,
                              color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  return duong = value;
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
                                labelText: 'Địa chỉ: ',
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.location_city,
                              color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: RaisedButton(
                              onPressed: () {
                                customer.idCustomer =
                                    "cus" + Random().nextInt(100).toString();
                                customer.address = "Đường " +
                                    duong +
                                    "/ " +
                                    quanhuyen +
                                    "/ " +
                                    thanhpho;
                                print(customer.idship);
                                _customerService.saveOrderList(customer);
                                Navigator.pop(context);
                              },
                              child: Text("Tạo"),
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              color: Colors.green[300],
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Hủy"),
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              color: Colors.red[300],
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
        ],
      )),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
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
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 70, right: 65),
            child: Row(
              children: <Widget>[
                Text(
                  'Thêm khách hàng',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
