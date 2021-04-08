import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/view/history_customer.dart';

import 'package:quan_ly_taiducfood/customer_action/view/update_customer.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class DetailsCustomer extends StatefulWidget {
  const DetailsCustomer({Key key, this.customer}) : super(key: key);
  final Customer customer;
  @override
  _DetailscustomerScreen createState() => _DetailscustomerScreen(customer);
}

class _DetailscustomerScreen extends State<DetailsCustomer> {
  var customer = Customer();
  _DetailscustomerScreen(this.customer);
  bool isLoading  =  false;
  

  @override
  void initState() {
    super.initState();
  }

    _addCustomer() async {
    setState(() {
      isLoading = true;
    });
    customer.addCustomer(customer);
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
      padding: const EdgeInsets.only(left: 8),
      child: Container(
          child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.person, color: HexColor('#B9BABC')),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: Container(
                            padding: EdgeInsets.zero,
                            child: Text(
                              customer.name,
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.location_city,
                              color: HexColor('#B9BABC')),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 32),
                            child: Container(
                              padding: EdgeInsets.zero,
                              child: Text(
                                customer.address,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                              ),
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.email, color: HexColor('#B9BABC')),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: Container(
                            padding: EdgeInsets.zero,
                            child: Text(
                              customer.mail,
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.phone, color: HexColor('#B9BABC')),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: Container(
                            padding: EdgeInsets.zero,
                            child: Text(
                              customer.phone,
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
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
              ),
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
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  HistoryCustomer.routeName,
                                  arguments: {
                                    'idCustomer': customer.id,
                                  },
                                );
                              },
                              child: Text(
                                "Lịch sử mua hàng",
                                textAlign: TextAlign.center,
                              ),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateCustomer(
                                              customer: customer,
                                            )));
                              },
                              child: Text("Cập nhật"),
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
            padding: EdgeInsets.only(left: 65, right: 45),
            child: Row(
              children: <Widget>[
                Text(
                  'Thông tin khách hàng',
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person_search,
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
