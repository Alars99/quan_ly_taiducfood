import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'design_course_app_theme.dart';

class HistoryCustomer extends StatefulWidget {
  @override
  _HistoryCustomerScreen createState() => _HistoryCustomerScreen();
}

class _HistoryCustomerScreen extends State<HistoryCustomer> {
  var customer = Customer();
  var _customerService = CustomerService();

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
    customer.name = 'nhật trường';
    customer.email = 'nnhattruong23@gmail.com';
    customer.address = 'Ung văn khiêm - Bình Thạnh';
    customer.phone = '0943502207';

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
          child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 85,
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 8, left: 10, right: 8),
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  "dh01",
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 8, left: 8, right: 16),
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  "Nguyễn Nhật Trường",
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 8, left: 8, right: 8),
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  "23/12/2020",
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 16, top: 8),
                              child: Text(
                                "Đã giao hàng",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
            padding: EdgeInsets.only(left: 65, right: 45),
            child: Row(
              children: <Widget>[
                Text(
                  'Lịch sử mua hàng',
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
          Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.filter_list_alt,
                    color: OrderAppTheme.buildLightTheme().primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
